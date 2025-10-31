namespace Models
{
    public class MedicineEntryCreateDto
    {
        public string MedicineName { get; set; } = string.Empty;
        public string Dosage { get; set; } = string.Empty;
        public DateTime TimeTaken { get; set; }
    }
}
