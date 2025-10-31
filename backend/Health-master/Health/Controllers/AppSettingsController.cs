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
    public class AppSettingsController : ControllerBase
    {
        private readonly ApplicationDbContext _context;

        public AppSettingsController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: api/AppSettings
        [HttpGet]
        public async Task<ActionResult<IEnumerable<AppSettings>>> GetAppSettings()
        {
            return await _context.AppSettings.ToListAsync();
        }

        // GET: api/AppSettings/5
        [HttpGet("{id}")]
        public async Task<ActionResult<AppSettings>> GetAppSettings(int id)
        {
            var appSettings = await _context.AppSettings.FindAsync(id);

            if (appSettings == null)
            {
                return NotFound();
            }

            return appSettings;
        }

        // PUT: api/AppSettings/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutAppSettings(int id, AppSettings appSettings)
        {
            if (id != appSettings.Id)
            {
                return BadRequest();
            }

            _context.Entry(appSettings).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!AppSettingsExists(id))
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

        // POST: api/AppSettings
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<AppSettings>> PostAppSettings(AppSettingsCreateDto dto)
        {
            var userId = int.Parse(User.FindFirst("UserId")!.Value);

            var settings = new AppSettings
            {
                UserId = userId,
                NotificationsEnabled = dto.NotificationsEnabled,
                Theme = dto.Theme
            };

            _context.AppSettings.Add(settings);
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetAppSettings), new { id = settings.Id }, settings);
        }


        // DELETE: api/AppSettings/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteAppSettings(int id)
        {
            var appSettings = await _context.AppSettings.FindAsync(id);
            if (appSettings == null)
            {
                return NotFound();
            }

            _context.AppSettings.Remove(appSettings);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool AppSettingsExists(int id)
        {
            return _context.AppSettings.Any(e => e.Id == id);
        }
    }
}
