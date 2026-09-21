using Backend.Models;
using BackendTrack.Models;
using Microsoft.EntityFrameworkCore;

namespace Backend.Data
{
    public static class TopicSeeder
    {
        public static async Task SeedTopicsAsync(AppDbContext db)
        {
            if (await db.Topics.AnyAsync())
                return;

            var topics = new List<Topic>
            {
                new()
                {
                    Name = "Ordering at a Café",
                    Description = "Master ordering specialty drinks, requesting customized ingredients, and casual small talk with the barista.",
                    Difficulty = LevelEnum.Beginner,
                    Category = TopicCategory.DailyLife,
                    EstimatedMinutes = 6,
                    SessionMission = "Order your favorite espresso, choose oat milk & cup size, and ask for the check smoothly.",
                    MaxTurns = 6,
                    IsActive = true
                },
                new()
                {
                    Name = "Casual Small Talk",
                    Description = "Practice greetings, weather chat, and light social conversation with a stranger.",
                    Difficulty = LevelEnum.Beginner,
                    Category = TopicCategory.Social,
                    EstimatedMinutes = 5,
                    SessionMission = "Greet someone new, ask how they're doing, and keep the small talk flowing naturally.",
                    MaxTurns = 5,
                    IsActive = true
                },
                new()
                {
                    Name = "Checking into a Hotel",
                    Description = "Practice check-in conversations — confirming reservations, asking about amenities, and requesting a room change.",
                    Difficulty = LevelEnum.Intermediate,
                    Category = TopicCategory.Travel,
                    EstimatedMinutes = 6,
                    SessionMission = "Check in with your reservation, ask about breakfast hours, and request a quieter room.",
                    MaxTurns = 6,
                    IsActive = true
                },
                new()
                {
                    Name = "Job Interview & Career",
                    Description = "Articulate previous work experience, handle unexpected behavioral questions, and negotiate project deadlines.",
                    Difficulty = LevelEnum.Intermediate,
                    Category = TopicCategory.Career,
                    EstimatedMinutes = 8,
                    SessionMission = "Introduce your experience, answer a behavioral question, and negotiate a project deadline.",
                    MaxTurns = 6,
                    IsActive = true
                },
                new()
                {
                    Name = "Negotiating Project Deadlines",
                    Description = "Discuss and negotiate a tight deadline with a manager — pushing back respectfully and proposing alternatives.",
                    Difficulty = LevelEnum.Advanced,
                    Category = TopicCategory.Career,
                    EstimatedMinutes = 8,
                    SessionMission = "Explain why the deadline is unrealistic and propose two alternative timelines.",
                    MaxTurns = 6,
                    IsActive = true
                }
            };

            db.Topics.AddRange(topics);
            await db.SaveChangesAsync();
        }
    }
}