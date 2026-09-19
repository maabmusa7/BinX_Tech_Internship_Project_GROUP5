namespace Backend.Services
{
    public record TurnAiResult(string TranscribedText, string AiReplyText, double PronunciationScore, string FeedbackText);

    public interface IAiSpeechService
    {
        Task<TurnAiResult> ProcessTurnAsync(string audioUrl, string topicName, List<string> conversationHistory);
    }

    public class StubAiSpeechService : IAiSpeechService
    {
        public Task<TurnAiResult> ProcessTurnAsync(string audioUrl, string topicName, List<string> conversationHistory)
        {
            var result = new TurnAiResult(
                TranscribedText: "[stub transcription]",
                AiReplyText: "That's interesting! Can you tell me more?",
                PronunciationScore: 75.0,
                FeedbackText: "Watch the 'th' sound — try placing your tongue between your teeth.");

            return Task.FromResult(result);
        }
    }
}