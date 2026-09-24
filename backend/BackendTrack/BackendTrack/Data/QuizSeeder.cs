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
                    Category = "Grammar & Context",
                    Difficulty = LevelEnum.Beginner,
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
                    Category = "Grammar & Context",
                    Difficulty = LevelEnum.Beginner,
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
                    Category = "Vocabulary",
                    Difficulty = LevelEnum.Beginner,
                    Options = new List<QuizOption>
                    {
                        new() { Text = "Sad", Points = 0 },
                        new() { Text = "Joyful", Points = 2 },
                        new() { Text = "Angry", Points = 0 }
                    }
                },
                new()
                {
                    Text = "\"If I ___ about the heavy traffic this morning, I would have taken the metro.\"",
                    Category = "Grammar & Context",
                    Difficulty = LevelEnum.Intermediate,
                    Options = new List<QuizOption>
                    {
                        new() { Text = "had known", Points = 2 },
                        new() { Text = "have known", Points = 0 },
                        new() { Text = "knew", Points = 1 },
                        new() { Text = "would know", Points = 0 }
                    }
                },
                new()
                {
                    Text = "Choose the word that best fits: \"The manager asked us to ___ the report before Friday.\"",
                    Category = "Vocabulary",
                    Difficulty = LevelEnum.Intermediate,
                    Options = new List<QuizOption>
                    {
                        new() { Text = "finish", Points = 2 },
                        new() { Text = "finishing", Points = 0 },
                        new() { Text = "finished", Points = 1 },
                        new() { Text = "finishes", Points = 0 }
                    }
                },
                new()
                {
                    Text = "Which sentence uses the passive voice correctly?",
                    Category = "Grammar & Context",
                    Difficulty = LevelEnum.Intermediate,
                    Options = new List<QuizOption>
                    {
                        new() { Text = "The cake was baked by my sister.", Points = 2 },
                        new() { Text = "The cake baked by my sister.", Points = 0 },
                        new() { Text = "My sister was baked the cake.", Points = 0 },
                        new() { Text = "The cake is baking my sister.", Points = 0 }
                    }
                },
                new()
                {
                    Text = "Choose the most natural way to disagree politely in a discussion:",
                    Category = "Conversation",
                    Difficulty = LevelEnum.Intermediate,
                    Options = new List<QuizOption>
                    {
                        new() { Text = "You're wrong.", Points = 0 },
                        new() { Text = "I see your point, but I think differently.", Points = 2 },
                        new() { Text = "No.", Points = 0 },
                        new() { Text = "That's not true at all.", Points = 1 }
                    }
                },
                new()
                {
                    Text = "\"Despite ___ tired, she finished the marathon.\"",
                    Category = "Grammar & Context",
                    Difficulty = LevelEnum.Advanced,
                    Options = new List<QuizOption>
                    {
                        new() { Text = "being", Points = 2 },
                        new() { Text = "be", Points = 0 },
                        new() { Text = "to be", Points = 0 },
                        new() { Text = "been", Points = 1 }
                    }
                },
                new()
                {
                    Text = "Choose the sentence with the most precise/formal vocabulary:",
                    Category = "Vocabulary",
                    Difficulty = LevelEnum.Advanced,
                    Options = new List<QuizOption>
                    {
                        new() { Text = "The company got a lot of money last year.", Points = 0 },
                        new() { Text = "The company generated substantial revenue last year.", Points = 2 },
                        new() { Text = "The company made big money last year.", Points = 1 },
                        new() { Text = "The company had lots of profit.", Points = 0 }
                    }
                },
                new()
                {
                    Text = "Which phrase best expresses a nuanced counterargument?",
                    Category = "Conversation",
                    Difficulty = LevelEnum.Advanced,
                    Options = new List<QuizOption>
                    {
                        new() { Text = "That's wrong because you don't understand.", Points = 0 },
                        new() { Text = "While that's a fair point, it overlooks a key factor.", Points = 2 },
                        new() { Text = "I disagree completely.", Points = 1 },
                        new() { Text = "No way, that's silly.", Points = 0 }
                    }
                }
            };

            db.QuizQuestions.AddRange(questions);
            await db.SaveChangesAsync();
        }
    }
}