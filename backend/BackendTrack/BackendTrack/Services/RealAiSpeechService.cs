using BackendTrack.Interfaces;
using System.Net.Http.Json;
using System.Text.Json.Serialization;
using static BackendTrack.Interfaces.IAiSpeechService;

namespace Backend.Services
{
    // Implementation حقيقي — بيكلم POST /process-turn (endpoint وحيد، حسب مستند فريق الـ AI/ML)
    // بيرسل مرجع الصوت (Firebase URL) + سياق المحادثة، ويرجع transcript + رد + درجة + فييدباك مع بعض
    public class RealAiSpeechService : IAiSpeechService
    {
        private readonly HttpClient _http;

        public RealAiSpeechService(HttpClient http)
        {
            _http = http; 
        }

        public async Task<TurnAiResult> ProcessTurnAsync(string audioUrl, string topicName, List<string> conversationHistory)
        {
            var request = new ProcessTurnRequest(audioUrl, topicName, conversationHistory);

            var response = await _http.PostAsJsonAsync("/process-turn", request);
            response.EnsureSuccessStatusCode();

            var result = await response.Content.ReadFromJsonAsync<ProcessTurnResponse>()
                ?? throw new InvalidOperationException("رد فاضي من خدمة الـ AI/ML.");

            return new TurnAiResult(result.Transcript, result.AiReply, result.Score, result.Feedback);
        }

        private record ProcessTurnRequest(
            [property: JsonPropertyName("audio_url")] string AudioUrl,
            [property: JsonPropertyName("topic")] string Topic,
            [property: JsonPropertyName("conversation_history")] List<string> ConversationHistory);

        private record ProcessTurnResponse(
            [property: JsonPropertyName("transcript")] string Transcript,
            [property: JsonPropertyName("ai_reply")] string AiReply,
            [property: JsonPropertyName("score")] double Score,
            [property: JsonPropertyName("feedback")] string Feedback);
    }
}