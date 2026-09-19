using Backend.Models;
using BackendTrack.Models;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;

namespace Backend.Data
{
    public static class DemoDataSeeder
    {
        public static async Task SeedDemoUserAsync(IServiceProvider services, IConfiguration config, AppDbContext db)
        {
            var userManager = services.GetRequiredService<UserManager<ApplicationUser>>();

            var section = config.GetSection("DemoUser");
            var email = section["Email"];
            var password = section["Password"];
            var fullName = section["FullName"] ?? "Demo User";

            if (string.IsNullOrWhiteSpace(email) || string.IsNullOrWhiteSpace(password))
                return;

            var existing = await userManager.FindByEmailAsync(email);
            if (existing != null)
                return; 

            var demoUser = new ApplicationUser
            {
                UserName = email,
                Email = email,
                FullName = fullName,
                EmailConfirmed = true,
                Level = LevelEnum.Intermediate,
                CurrentStreak = 3,
                LastSessionDate = DateTime.UtcNow.Date.AddDays(-1) 
            };

            var result = await userManager.CreateAsync(demoUser, password);
            if (!result.Succeeded)
                return;

            await userManager.AddToRoleAsync(demoUser, "User");

            var orderingFood = await db.Topics.FirstOrDefaultAsync(t => t.Name == "Ordering Food");
            var jobInterview = await db.Topics.FirstOrDefaultAsync(t => t.Name == "Job Interview");
            if (orderingFood == null || jobInterview == null)
                return; 

            var session1 = new Session
            {
                UserId = demoUser.Id,
                TopicId = orderingFood.Id,
                Status = SessionStatus.Completed,
                StartedAt = DateTime.UtcNow.AddDays(-3),
                EndedAt = DateTime.UtcNow.AddDays(-3).AddMinutes(6),
                SummaryScore = 78.5
            };
            db.Sessions.Add(session1);
            await db.SaveChangesAsync();

            db.Turns.AddRange(
                new Turn { SessionId = session1.Id, TurnNumber = 0, AiReplyText = "Hi! Let's talk about Ordering Food. Tell me a bit about it — how would you start?" },
                new Turn
                {
                    SessionId = session1.Id,
                    TurnNumber = 1,
                    AudioUrl = "https://storage.googleapis.com/demo/audio1.mp3",
                    TranscribedText = "I would like to order a pizza please.",
                    AiReplyText = "Great choice! What size would you like?",
                    PronunciationScore = 80,
                    FeedbackText = "Good job! Watch the 'r' sound in 'order'."
                },
                new Turn
                {
                    SessionId = session1.Id,
                    TurnNumber = 2,
                    AudioUrl = "https://storage.googleapis.com/demo/audio2.mp3",
                    TranscribedText = "A large pizza with cheese.",
                    AiReplyText = "Perfect, anything to drink?",
                    PronunciationScore = 77,
                    FeedbackText = "Watch the 'ch' sound in 'cheese'."
                }
            );


            var session2 = new Session
            {
                UserId = demoUser.Id,
                TopicId = jobInterview.Id,
                Status = SessionStatus.Completed,
                StartedAt = DateTime.UtcNow.AddDays(-1),
                EndedAt = DateTime.UtcNow.AddDays(-1).AddMinutes(8),
                SummaryScore = 85.0
            };
            db.Sessions.Add(session2);
            await db.SaveChangesAsync();

            db.Turns.AddRange(
                new Turn { SessionId = session2.Id, TurnNumber = 0, AiReplyText = "Hi! Let's talk about Job Interview. Tell me a bit about it — how would you start?" },
                new Turn
                {
                    SessionId = session2.Id,
                    TurnNumber = 1,
                    AudioUrl = "https://storage.googleapis.com/demo/audio3.mp3",
                    TranscribedText = "I have three years of experience in software development.",
                    AiReplyText = "That's impressive! What are your key strengths?",
                    PronunciationScore = 85,
                    FeedbackText = "Excellent pronunciation, very clear."
                }
            );


            var session3 = new Session
            {
                UserId = demoUser.Id,
                TopicId = orderingFood.Id,
                Status = SessionStatus.InProgress,
                StartedAt = DateTime.UtcNow.AddMinutes(-5)
            };
            db.Sessions.Add(session3);
            await db.SaveChangesAsync();

            db.Turns.Add(new Turn
            {
                SessionId = session3.Id,
                TurnNumber = 0,
                AiReplyText = "Hi! Let's talk about Ordering Food. Tell me a bit about it — how would you start?"
            });

            await db.SaveChangesAsync();
        }
    }
}