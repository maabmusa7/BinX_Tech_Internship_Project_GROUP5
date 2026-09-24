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
                CefrLevel = "B1 High",
                CosmicXp = 45,
                CurrentStreak = 3,
                LastSessionDate = DateTime.UtcNow.Date.AddDays(-1)
            };

            var result = await userManager.CreateAsync(demoUser, password);
            if (!result.Succeeded)
                return;

            await userManager.AddToRoleAsync(demoUser, "User");

            var cafe = await db.Topics.FirstOrDefaultAsync(t => t.Name == "Ordering at a Café");
            var jobInterview = await db.Topics.FirstOrDefaultAsync(t => t.Name == "Job Interview & Career");
            if (cafe == null || jobInterview == null)
                return; // لازم TopicSeeder يشتغل قبلها

            // جلسة أولى مكتملة
            var session1 = new Session
            {
                UserId = demoUser.Id,
                TopicId = cafe.Id,
                Status = SessionStatus.Completed,
                StartedAt = DateTime.UtcNow.AddDays(-3),
                EndedAt = DateTime.UtcNow.AddDays(-3).AddMinutes(6),
                SummaryScore = 80,
                AvgPronunciation = 82,
                AvgFluency = 76,
                AvgVocabulary = 85,
                XpEarned = 15
            };
            db.Sessions.Add(session1);
            await db.SaveChangesAsync();

            db.Turns.AddRange(
                new Turn { SessionId = session1.Id, TurnNumber = 0, AiReplyText = "Hi! Welcome to Starlight Roast. What can I get started for you today?" },
                new Turn
                {
                    SessionId = session1.Id,
                    TurnNumber = 1,
                    AudioUrl = "https://storage.googleapis.com/demo/audio1.mp3",
                    TranscribedText = "I'd like an iced oat latte with an extra espresso shot, please.",
                    AiReplyText = "Great choice! What size would you like?",
                    PronunciationScore = 84,
                    FluencyScore = 78,
                    VocabularyScore = 85,
                    FeedbackText = "Good effort! Watch the 'th' in 'with'.",
                    PhonemeFocusSound = "/θ/",
                    PhonemeTip = "Place your tongue lightly between your teeth for a soft, unvoiced breath release.",
                    NativeAudioUrl = "https://storage.googleapis.com/demo/native-th.mp3"
                },
                new Turn
                {
                    SessionId = session1.Id,
                    TurnNumber = 2,
                    AudioUrl = "https://storage.googleapis.com/demo/audio2.mp3",
                    TranscribedText = "A large size please, and can I get the check after?",
                    AiReplyText = "Of course! Anything else before I get your check ready?",
                    PronunciationScore = 80,
                    FluencyScore = 74,
                    VocabularyScore = 85,
                    FeedbackText = "Watch the 'ch' sound in 'check'.",
                    PhonemeFocusSound = "/tʃ/",
                    PhonemeTip = "Start with your tongue behind your upper teeth, then release with a soft puff of air.",
                    NativeAudioUrl = "https://storage.googleapis.com/demo/native-ch.mp3"
                }
            );

            // جلسة ثانية مكتملة — موضوع مختلف
            var session2 = new Session
            {
                UserId = demoUser.Id,
                TopicId = jobInterview.Id,
                Status = SessionStatus.Completed,
                StartedAt = DateTime.UtcNow.AddDays(-1),
                EndedAt = DateTime.UtcNow.AddDays(-1).AddMinutes(8),
                SummaryScore = 85,
                AvgPronunciation = 85,
                AvgFluency = 83,
                AvgVocabulary = 87,
                XpEarned = 15
            };
            db.Sessions.Add(session2);
            await db.SaveChangesAsync();

            db.Turns.AddRange(
                new Turn { SessionId = session2.Id, TurnNumber = 0, AiReplyText = "Hi! Let's talk about your experience. Tell me about your background." },
                new Turn
                {
                    SessionId = session2.Id,
                    TurnNumber = 1,
                    AudioUrl = "https://storage.googleapis.com/demo/audio3.mp3",
                    TranscribedText = "I have three years of experience in software development.",
                    AiReplyText = "That's impressive! What are your key strengths?",
                    PronunciationScore = 85,
                    FluencyScore = 83,
                    VocabularyScore = 87,
                    FeedbackText = "Excellent pronunciation, very clear."
                }
            );

            // جلسة ثالثة لسه شغالة — لتجربة GetActiveSession / SendTurn / EndSession
            var session3 = new Session
            {
                UserId = demoUser.Id,
                TopicId = cafe.Id,
                Status = SessionStatus.InProgress,
                StartedAt = DateTime.UtcNow.AddMinutes(-5)
            };
            db.Sessions.Add(session3);
            await db.SaveChangesAsync();

            db.Turns.Add(new Turn
            {
                SessionId = session3.Id,
                TurnNumber = 0,
                AiReplyText = "Hi! Welcome to Starlight Roast. What can I get started for you today?"
            });

            await db.SaveChangesAsync();
        }
    }
}