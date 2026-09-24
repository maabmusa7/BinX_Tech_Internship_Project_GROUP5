using System.Net.Http.Json;
using System.Text.Json.Serialization;

namespace Backend.Services
{
    public class RealAiSpeechService : IAiSpeechService
    {
        private readonly HttpClient _http;

        public RealAiSpeechService(HttpClient http)
        {
            _http = http; 
        }

        public async Task<TurnAiResult> ProcessTurnAsync(string? audioUrl, string? textInput, string topicName, List<string> conversationHistory)
        {
            var request = new ProcessTurnRequest(audioUrl, textInput, topicName, conversationHistory);

            var response = await _http.PostAsJsonAsync("/process-turn", request);
            response.EnsureSuccessStatusCode();

            var result = await response.Content.ReadFromJsonAsync<ProcessTurnResponse>()
                ?? throw new InvalidOperationException("رد فاضي من خدمة الـ AI/ML.");

            return new TurnAiResult(
                result.Transcript,
                result.AiReply,
                result.PronunciationScore,
                result.FluencyScore,
                result.VocabularyScore,
                result.Feedback,
                result.PhonemeFocus,
                result.PhonemeTip,
                result.NativeAudioUrl);
        }

        // أسماء الحقول snake_case (خدمتهم FastAPI/Python) — تأكدي معهم إنها مطابقة فعليًا وقت التكامل
        private record ProcessTurnRequest(
            [property: JsonPropertyName("audio_url")] string? AudioUrl,
            [property: JsonPropertyName("text_input")] string? TextInput,
            [property: JsonPropertyName("topic")] string Topic,
            [property: JsonPropertyName("conversation_history")] List<string> ConversationHistory);

        private record ProcessTurnResponse(
            [property: JsonPropertyName("transcript")] string Transcript,
            [property: JsonPropertyName("ai_reply")] string AiReply,
            [property: JsonPropertyName("pronunciation_score")] double PronunciationScore,
            [property: JsonPropertyName("fluency_score")] double FluencyScore,
            [property: JsonPropertyName("vocabulary_score")] double VocabularyScore,
            [property: JsonPropertyName("feedback")] string Feedback,
            [property: JsonPropertyName("phoneme_focus")] string? PhonemeFocus,
            [property: JsonPropertyName("phoneme_tip")] string? PhonemeTip,
            [property: JsonPropertyName("native_audio_url")] string? NativeAudioUrl);
    }
}