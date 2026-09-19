using BackendTrack.Models;

namespace Backend.Models
{
    public class Topic
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
        public LevelEnum Difficulty { get; set; }

        public bool IsActive { get; set; } = true;

        public ICollection<Session> Sessions { get; set; } = new List<Session>();
    }
}