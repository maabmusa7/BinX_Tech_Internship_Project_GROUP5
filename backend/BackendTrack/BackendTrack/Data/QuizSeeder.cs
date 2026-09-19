using Backend.Models;
using BackendTrack.Models;
using Microsoft.EntityFrameworkCore;

namespace Backend.Data
{
    public static class QuizSeeder
    {
        public static async Task SeedQuizAsync(AppDbContext db)
        {
            if (await db.QuizQuestions.AnyAsync())
                return; 

            var questions = new List<QuizQuestion>
            {
                new()
                {
                    Text = "Choose the correct sentence:",
                    Options = new List<QuizOption>
                    {
                        new() { Text = "She go to school every day.", Points = 0 },
                        new() { Text = "She goes to school every day.", Points = 2 },
                        new() { Text = "She going to school every day.", Points = 0 }
                    }
                },
                new()
                {
                    Text = "What is the past tense of 'write'?",
                    Options = new List<QuizOption>
                    {
                        new() { Text = "Writed", Points = 0 },
                        new() { Text = "Wrote", Points = 2 },
                        new() { Text = "Written", Points = 1 }
                    }
                },
                new()
                {
                    Text = "Choose the synonym of 'happy':",
                    Options = new List<QuizOption>
                    {
                        new() { Text = "Sad", Points = 0 },
                        new() { Text = "Joyful", Points = 2 },
                        new() { Text = "Angry", Points = 0 }
                    }
                }
            };

            db.QuizQuestions.AddRange(questions);
            await db.SaveChangesAsync();
        }
    }
}