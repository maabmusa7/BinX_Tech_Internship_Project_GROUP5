using BackendTrack.Models;

namespace Backend.Models
{
    public class Topic
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
        public LevelEnum Difficulty { get; set; }
        public TopicCategory Category { get; set; }

        public int EstimatedMinutes { get; set; } = 5;
        public string SessionMission { get; set; } = string.Empty;
        public int MaxTurns { get; set; } = 6; 

        public bool IsActive { get; set; } = true;

        public ICollection<Session> Sessions { get; set; } = new List<Session>();
    }
}