using Data;
using Entites;
using Humanizer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Models;
using Services;

namespace Health.Controllers
{
    [Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class ActivityEntriesController : ControllerBase
    {
        private readonly ApplicationDbContext _context;
        private readonly IOpenAIService _openAI;

        public ActivityEntriesController(ApplicationDbContext context,IOpenAIService openAI)
        {
            _context = context;
            _openAI = openAI;
        }

        // GET: api/ActivityEntries
        [HttpGet]
        public async Task<ActionResult<IEnumerable<ActivityEntry>>> GetActivityEntry()
        {
            return await _context.ActivityEntry.ToListAsync();
        }

        // GET: api/ActivityEntries/5
        [HttpGet("{id}")]
        public async Task<ActionResult<ActivityEntry>> GetActivityEntry(int id)
        {
            var activityEntry = await _context.ActivityEntry.FindAsync(id);

            if (activityEntry == null)
            {
                return NotFound();
            }

            return activityEntry;
        }

        // PUT: api/ActivityEntries/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutActivityEntry(int id, ActivityEntry activityEntry)
        {
            if (id != activityEntry.Id)
            {
                return BadRequest();
            }

            _context.Entry(activityEntry).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!ActivityEntryExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        // POST: api/ActivityEntries
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<ActivityEntry>> PostActivityEntry([FromBody] ActivityEntryCreateDto dto)
        {
            var userId = int.Parse(User.FindFirst("UserId")!.Value);

            var activityEntry = new ActivityEntry
            {
                UserId = userId,
                ActivityType = dto.ActivityType,
                Duration = dto.Duration,
                CaloriesBurned = dto.CaloriesBurned,
                Date = dto.Date
            };

            _context.ActivityEntry.Add(activityEntry);
            await _context.SaveChangesAsync();
            var dto2 = new OpenAIRequestDto
            {
                Prompt = $@"
Return ONLY a valid JSON object (no text) with:
- ""activityType"": string (use '{dto.ActivityType}')
- ""duration"": number (minutes, use {dto.Duration})
- ""caloriesBurned"": number {dto.CaloriesBurned}
- ""date"": ISO string (use '{dto.Date:yyyy-MM-dd}')
"
            };
            var result = await _openAI.GenerateAsync(dto2);

            return CreatedAtAction("GetActivityEntry", new { id = activityEntry.Id }, activityEntry);
        }

        // DELETE: api/ActivityEntries/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteActivityEntry(int id)
        {
            var activityEntry = await _context.ActivityEntry.FindAsync(id);
            if (activityEntry == null)
            {
                return NotFound();
            }

            _context.ActivityEntry.Remove(activityEntry);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool ActivityEntryExists(int id)
        {
            return _context.ActivityEntry.Any(e => e.Id == id);
        }
    }
}
