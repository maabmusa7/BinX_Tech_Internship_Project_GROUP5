using Backend.Models;
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
                    Name = "Ordering Food",
                    Description = "Practice ordering food at a restaurant — greetings, asking about the menu, and making requests.",
                    Difficulty = LevelEnum.Beginner,
                    IsActive = true
                },
                new()
                {
                    Name = "Introducing Yourself",
                    Description = "Talk about your name, where you're from, and your hobbies — great for absolute beginners.",
                    Difficulty = LevelEnum.Beginner,
                    IsActive = true
                },
                new()
                {
                    Name = "Job Interview",
                    Description = "Practice answering common interview questions about your experience and strengths.",
                    Difficulty = LevelEnum.Intermediate,
                    IsActive = true
                },
                new()
                {
                    Name = "Making Weekend Plans",
                    Description = "Discuss plans with a friend — suggesting activities, agreeing, and negotiating times.",
                    Difficulty = LevelEnum.Intermediate,
                    IsActive = true
                },
                new()
                {
                    Name = "Debating a Social Issue",
                    Description = "Share and defend an opinion on a current topic, respond to counterarguments.",
                    Difficulty = LevelEnum.Advanced,
                    IsActive = true
                }
            };

            db.Topics.AddRange(topics);
            await db.SaveChangesAsync();
        }
    }
}