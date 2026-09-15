using BackendTrack.Models;

namespace Backend.Models
{
    public class QuizQuestion
    {
        public int Id { get; set; }
        public string Text { get; set; } = string.Empty;

        public ICollection<QuizOption> Options { get; set; } = new List<QuizOption>();
    }

    
}