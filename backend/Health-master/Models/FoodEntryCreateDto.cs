namespace Models
{
    public class FoodEntryCreateDto
    {
        public string FoodName { get; set; } = string.Empty;
        public double Calories { get; set; }
        public double Protein { get; set; }
        public double Carbs { get; set; }
        public double Fat { get; set; }
        public DateTime Date { get; set; }
    }
}
