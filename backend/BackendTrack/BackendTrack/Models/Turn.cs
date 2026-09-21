using BackendTrack.Models;

namespace Backend.Models
{
    public class Turn
    {
        public int Id { get; set; }

        public int SessionId { get; set; }
        public Session Session { get; set; } = null!;

        public int TurnNumber { get; set; }

        public string? AudioUrl { get; set; }
        public string? TextInput { get; set; } 

        public string TranscribedText { get; set; } = string.Empty;
        public string AiReplyText { get; set; } = string.Empty;

        public double PronunciationScore { get; set; }
        public double FluencyScore { get; set; }
        public double VocabularyScore { get; set; }

        public string FeedbackText { get; set; } = string.Empty;

        public string? PhonemeFocusSound { get; set; }   
        public string? PhonemeTip { get; set; }
        public string? NativeAudioUrl { get; set; }      

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    }
}