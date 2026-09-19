using BackendTrack.Models;

namespace Backend.Models
{
    // UC-U6, UC-U7: دور واحد = كلام المستخدم + رد الـ AI + درجة النطق
    public class Turn
    {
        public int Id { get; set; }

        public int SessionId { get; set; }
        public Session Session { get; set; } = null!;

        public int TurnNumber { get; set; }

        public string AudioUrl { get; set; } = string.Empty;

        public string TranscribedText { get; set; } = string.Empty;
        public string AiReplyText { get; set; } = string.Empty;

        public double PronunciationScore { get; set; }
        public string FeedbackText { get; set; } = string.Empty;

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    }
}