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
    public class HealthReadingsController : ControllerBase
    {
        private readonly ApplicationDbContext _context;

        public HealthReadingsController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: api/HealthReadings
        [HttpGet]
        public async Task<ActionResult<IEnumerable<HealthReading>>> GetHealthReading()
        {
            return await _context.HealthReading.ToListAsync();
        }

        // GET: api/HealthReadings/5
        [HttpGet("{id}")]
        public async Task<ActionResult<HealthReading>> GetHealthReading(int id)
        {
            var healthReading = await _context.HealthReading.FindAsync(id);

            if (healthReading == null)
            {
                return NotFound();
            }

            return healthReading;
        }

        // PUT: api/HealthReadings/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutHealthReading(int id, HealthReading healthReading)
        {
            if (id != healthReading.Id)
            {
                return BadRequest();
            }

            _context.Entry(healthReading).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!HealthReadingExists(id))
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

        // POST: api/HealthReadings
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<HealthReading>> PostHealthReading(HealthReadingCreateDto dto)
        {
            var userId = int.Parse(User.FindFirst("UserId")!.Value);

            var reading = new HealthReading
            {
                UserId = userId,
                BloodPressure = dto.BloodPressure,
                HeartRate = dto.HeartRate,
                RecordedAt = dto.RecordedAt
            };

            _context.HealthReading.Add(reading);
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetHealthReading), new { id = reading.Id }, reading);
        }


        // DELETE: api/HealthReadings/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteHealthReading(int id)
        {
            var healthReading = await _context.HealthReading.FindAsync(id);
            if (healthReading == null)
            {
                return NotFound();
            }

            _context.HealthReading.Remove(healthReading);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool HealthReadingExists(int id)
        {
            return _context.HealthReading.Any(e => e.Id == id);
        }
    }
}
