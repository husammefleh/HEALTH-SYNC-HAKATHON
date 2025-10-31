namespace Models
{
    public sealed class OpenAIRequestDto
    {
        public string Prompt { get; set; } = string.Empty;

        // Optional: extra data you might inject into the prompt
        public Dictionary<string, string>? Meta { get; set; }
    }
}
