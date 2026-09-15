namespace BackendTrack.Interfaces
{
    public interface IAiSpeechService
    {
        public record TurnAiResult(string TranscribedText, string AiReplyText, double PronunciationScore, string FeedbackText);
        Task<string> GetOpeningLineAsync(string topicName);
        Task<TurnAiResult> ProcessTurnAsync(string audioUrl, string topicName, List<string> conversationHistory);
    }
}
