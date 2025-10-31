namespace Models
{
    public sealed class OpenAIOptions
    {
        public const string SectionName = "OpenAI";
        public string ApiKey { get; init; } = string.Empty;
        public string Model { get; init; } = "gpt-4o-mini";
    }
}
