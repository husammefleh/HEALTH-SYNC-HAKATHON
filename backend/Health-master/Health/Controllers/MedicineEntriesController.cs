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
    public class MedicineEntriesController : ControllerBase
    {
        private readonly ApplicationDbContext _context;

        public MedicineEntriesController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: api/MedicineEntries
        [HttpGet]
        public async Task<ActionResult<IEnumerable<MedicineEntry>>> GetMedicineEntry()
        {
            return await _context.MedicineEntry.ToListAsync();
        }

        // GET: api/MedicineEntries/5
        [HttpGet("{id}")]
        public async Task<ActionResult<MedicineEntry>> GetMedicineEntry(int id)
        {
            var medicineEntry = await _context.MedicineEntry.FindAsync(id);

            if (medicineEntry == null)
            {
                return NotFound();
            }

            return medicineEntry;
        }

        // PUT: api/MedicineEntries/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutMedicineEntry(int id, MedicineEntry medicineEntry)
        {
            if (id != medicineEntry.Id)
            {
                return BadRequest();
            }

            _context.Entry(medicineEntry).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!MedicineEntryExists(id))
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

        // POST: api/MedicineEntries
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<MedicineEntry>> PostMedicineEntry(MedicineEntryCreateDto dto)
        {
            var userId = int.Parse(User.FindFirst("UserId")!.Value);

            var medicine = new MedicineEntry
            {
                UserId = userId,
                MedicineName = dto.MedicineName,
                Dosage = dto.Dosage,
                TimeTaken = dto.TimeTaken
            };

            _context.MedicineEntry.Add(medicine);
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetMedicineEntry), new { id = medicine.Id }, medicine);
        }


        // DELETE: api/MedicineEntries/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteMedicineEntry(int id)
        {
            var medicineEntry = await _context.MedicineEntry.FindAsync(id);
            if (medicineEntry == null)
            {
                return NotFound();
            }

            _context.MedicineEntry.Remove(medicineEntry);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool MedicineEntryExists(int id)
        {
            return _context.MedicineEntry.Any(e => e.Id == id);
        }
    }
}
