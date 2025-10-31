using Data;
using Entites;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Models;

namespace Health.Controllers
{
    [Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class FoodEntriesController : ControllerBase
    {
        private readonly ApplicationDbContext _context;

        public FoodEntriesController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: api/FoodEntries
        [HttpGet]
        public async Task<ActionResult<IEnumerable<FoodEntry>>> GetFoodEntry()
        {
            return await _context.FoodEntry.ToListAsync();
        }

        // GET: api/FoodEntries/5
        [HttpGet("{id}")]
        public async Task<ActionResult<FoodEntry>> GetFoodEntry(int id)
        {
            var foodEntry = await _context.FoodEntry.FindAsync(id);

            if (foodEntry == null)
            {
                return NotFound();
            }

            return foodEntry;
        }

        // PUT: api/FoodEntries/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutFoodEntry(int id, FoodEntry foodEntry)
        {
            if (id != foodEntry.Id)
            {
                return BadRequest();
            }

            _context.Entry(foodEntry).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!FoodEntryExists(id))
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

        // POST: api/FoodEntries
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<FoodEntry>> PostFoodEntry(FoodEntryCreateDto dto)
        {
            var userId = int.Parse(User.FindFirst("UserId")!.Value);

            var foodEntry = new FoodEntry
            {
                UserId = userId,
                FoodName = dto.FoodName,
                Calories = dto.Calories,
                Protein = dto.Protein,
                Carbs = dto.Carbs,
                Fat = dto.Fat,
                Date = dto.Date
            };

            _context.FoodEntry.Add(foodEntry);
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetFoodEntry), new { id = foodEntry.Id }, foodEntry);
        }


        // DELETE: api/FoodEntries/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteFoodEntry(int id)
        {
            var foodEntry = await _context.FoodEntry.FindAsync(id);
            if (foodEntry == null)
            {
                return NotFound();
            }

            _context.FoodEntry.Remove(foodEntry);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool FoodEntryExists(int id)
        {
            return _context.FoodEntry.Any(e => e.Id == id);
        }
    }
}
