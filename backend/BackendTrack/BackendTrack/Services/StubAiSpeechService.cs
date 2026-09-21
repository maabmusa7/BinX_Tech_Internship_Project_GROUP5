namespace Backend.Services
{
    public record TurnAiResult(
        string TranscribedText,
        string AiReplyText,
        double PronunciationScore,
        double FluencyScore,
        double VocabularyScore,
        string FeedbackText,
        string? PhonemeFocusSound,
        string? PhonemeTip,
        string? NativeAudioUrl);

    public interface IAiSpeechService
    {
        Task<TurnAiResult> ProcessTurnAsync(string? audioUrl, string? textInput, string topicName, List<string> conversationHistory);
    }

    public class StubAiSpeechService : IAiSpeechService
    {
        public Task<TurnAiResult> ProcessTurnAsync(string? audioUrl, string? textInput, string topicName, List<string> conversationHistory)
        {
            var result = new TurnAiResult(
                TranscribedText: textInput ?? "[stub transcription]",
                AiReplyText: "That's interesting! Can you tell me more?",
                PronunciationScore: 82,
                FluencyScore: 76,
                VocabularyScore: 85,
                FeedbackText: "Good effort! Watch the 'th' sound.",
                PhonemeFocusSound: "/θ/",
                PhonemeTip: "Place your tongue lightly between your teeth for a soft, unvoiced breath release.",
                NativeAudioUrl: "https://storage.googleapis.com/demo/native-th.mp3");

            return Task.FromResult(result);
        }
    }
}