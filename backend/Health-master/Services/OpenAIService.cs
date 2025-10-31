using Models;
using OpenAI.Chat;

namespace Services
{
    public sealed class OpenAIService : IOpenAIService
    {
        private readonly ChatClient _chatClient;
        private readonly string _model;

        public OpenAIService(ChatClient chatClient, OpenAIOptions options)
        {
            _chatClient = chatClient;
            _model = options.Model;
        }

        public async Task<OpenAIResponseDto> GenerateAsync(OpenAIRequestDto request)
        {
            var messages = new List<ChatMessage>
    {
        new SystemChatMessage("You are a helpful API that answers in concise JSON when possible."),
        new UserChatMessage(request.Prompt)
    };

            var completion = (await _chatClient.CompleteChatAsync(messages)).Value;

            var text = completion.Content.Count > 0 ? completion.Content[0].Text : string.Empty;

            return new OpenAIResponseDto
            {
                Model = _model,
                Output = text
            };
        }

    }
}
