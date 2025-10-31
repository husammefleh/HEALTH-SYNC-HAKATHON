using Data;
using Entites;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Health.Controllers
{
    [Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class SleepEntriesController : ControllerBase
    {
        private readonly ApplicationDbContext _context;

        public SleepEntriesController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: api/SleepEntries
        [HttpGet]
        public async Task<ActionResult<IEnumerable<SleepEntry>>> GetSleepEntry()
        {
            return await _context.SleepEntry.ToListAsync();
        }

        // GET: api/SleepEntries/5
        [HttpGet("{id}")]
        public async Task<ActionResult<SleepEntry>> GetSleepEntry(int id)
        {
            var sleepEntry = await _context.SleepEntry.FindAsync(id);

            if (sleepEntry == null)
            {
                return NotFound();
            }

            return sleepEntry;
        }

        // PUT: api/SleepEntries/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutSleepEntry(int id, SleepEntry sleepEntry)
        {
            if (id != sleepEntry.Id)
            {
                return BadRequest();
            }

            _context.Entry(sleepEntry).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!SleepEntryExists(id))
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

        // POST: api/SleepEntries
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<SleepEntry>> PostSleepEntry(SleepEntryCreateDto dto)
        {
            var userId = int.Parse(User.FindFirst("UserId")!.Value);

            var sleepEntry = new SleepEntry
            {
                UserId = userId,
                HoursSlept = dto.HoursSlept,
                SleepDate = dto.SleepDate
            };

            _context.SleepEntry.Add(sleepEntry);
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetSleepEntry), new { id = sleepEntry.Id }, sleepEntry);
        }


        // DELETE: api/SleepEntries/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteSleepEntry(int id)
        {
            var sleepEntry = await _context.SleepEntry.FindAsync(id);
            if (sleepEntry == null)
            {
                return NotFound();
            }

            _context.SleepEntry.Remove(sleepEntry);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool SleepEntryExists(int id)
        {
            return _context.SleepEntry.Any(e => e.Id == id);
        }
    }
}
