using BackendTrack.Interfaces;
using static BackendTrack.Interfaces.IAiSpeechService;

namespace BackendTrack.Services
{
    public class StubAiSpeechService : IAiSpeechService
    {
        public Task<string> GetOpeningLineAsync(string topicName)
        {
            return Task.FromResult($"Hi! Let's talk about {topicName}. Tell me a bit about it — how would you start?");
        }

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
