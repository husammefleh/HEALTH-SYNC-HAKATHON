using Models;

namespace Services
{
    public interface IOpenAIService
    {
        Task<OpenAIResponseDto> GenerateAsync(OpenAIRequestDto request);
    }
}
