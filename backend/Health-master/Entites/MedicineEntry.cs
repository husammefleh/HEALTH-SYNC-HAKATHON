namespace Entites
{
    public class MedicineEntry
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public string MedicineName { get; set; } = string.Empty;
        public string Dosage { get; set; } = string.Empty;
        public DateTime TimeTaken { get; set; }

        public User? User { get; set; }
    }
}
