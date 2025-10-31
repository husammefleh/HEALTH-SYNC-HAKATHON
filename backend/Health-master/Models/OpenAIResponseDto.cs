namespace Models
{
    public sealed class OpenAIResponseDto
    {
        public string Model { get; init; } = string.Empty;
        public string Output { get; init; } = string.Empty;

        // Include raw if you want (ids, usage, etc.). Kept simple here.
    }
}
