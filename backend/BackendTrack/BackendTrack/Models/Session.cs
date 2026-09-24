using BackendTrack.Models;

namespace Backend.Models
{
  
    public class Session
    {
        public int Id { get; set; }

        public int UserId { get; set; }
        public ApplicationUser User { get; set; } = null!;

        public int TopicId { get; set; }
        public Topic Topic { get; set; } = null!;

        public SessionStatus Status { get; set; } = SessionStatus.InProgress;

        public DateTime StartedAt { get; set; } = DateTime.UtcNow;
        public DateTime? EndedAt { get; set; }

        public double? SummaryScore { get; set; }         
        public double? AvgPronunciation { get; set; }
        public double? AvgFluency { get; set; }
        public double? AvgVocabulary { get; set; }
        public int XpEarned { get; set; }

        public ICollection<Turn> Turns { get; set; } = new List<Turn>();
    }
}