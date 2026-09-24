using Backend.Data;
using Backend.Models;
using BackendTrack.Dtos.SessionDtos;
using BackendTrack.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Caching.Memory;

namespace Backend.Services
{
    public class SessionService : ISessionService
    {
        private readonly AppDbContext _db;
        private readonly IAiSpeechService _ai;
        private readonly IMemoryCache _cache;
        private readonly IConfiguration _config;

        public SessionService(AppDbContext db, IAiSpeechService ai, IMemoryCache cache, IConfiguration config)
        {
            _db = db;
            _ai = ai;
            _cache = cache;
            _config = config;
        }

        // UC-U5
        public async Task<ServiceResult<SessionDto>> StartSessionAsync(int userId, StartSessionDto dto)
        {
            var topic = await _db.Topics.FindAsync(dto.TopicId);
            if (topic == null || !topic.IsActive)
                return ServiceResult<SessionDto>.Fail(ServiceError.NotFound, "الموضوع غير موجود أو غير فعّال.");

            var session = new Session
            {
                UserId = userId,
                TopicId = topic.Id,
                Status = SessionStatus.InProgress,
                StartedAt = DateTime.UtcNow
            };
            _db.Sessions.Add(session);
            await _db.SaveChangesAsync();

            var openingLine = BuildOpeningLine(topic.Name);

            _db.Turns.Add(new Turn
            {
                SessionId = session.Id,
                TurnNumber = 0,
                AiReplyText = openingLine,
                TranscribedText = string.Empty,
                FeedbackText = string.Empty
            });
            await _db.SaveChangesAsync();

            return ServiceResult<SessionDto>.Ok(new SessionDto
            {
                Id = session.Id,
                TopicName = topic.Name,
                TopicCategory = topic.Category.ToString(),
                SessionMission = topic.SessionMission,
                Status = session.Status.ToString(),
                StartedAt = session.StartedAt,
                OpeningLine = openingLine,
                MaxTurns = topic.MaxTurns
            });
        }

        public async Task<ServiceResult<SessionDetailDto>> GetSessionAsync(int userId, int sessionId)
        {
            var session = await _db.Sessions
                .Include(s => s.Topic)
                .Include(s => s.Turns)
                .FirstOrDefaultAsync(s => s.Id == sessionId);

            if (session == null || session.UserId != userId)
                return ServiceResult<SessionDetailDto>.Fail(ServiceError.NotFound, "الجلسة غير موجودة.");

            return ServiceResult<SessionDetailDto>.Ok(MapDetail(session));
        }

        public async Task<ServiceResult<SessionDetailDto>> GetActiveSessionAsync(int userId)
        {
            var session = await _db.Sessions
                .Include(s => s.Topic)
                .Include(s => s.Turns)
                .Where(s => s.UserId == userId && s.Status == SessionStatus.InProgress)
                .OrderByDescending(s => s.StartedAt)
                .FirstOrDefaultAsync();

            if (session == null)
                return ServiceResult<SessionDetailDto>.Fail(ServiceError.NotFound, "ما في جلسة شغالة حاليًا.");

            return ServiceResult<SessionDetailDto>.Ok(MapDetail(session));
        }

        // UC-U6 + UC-U7 — بيقبل صوت أو نص (Text Hybrid)
        public async Task<ServiceResult<TurnResultDto>> SendTurnAsync(int userId, int sessionId, SendTurnDto dto)
        {
            if (string.IsNullOrWhiteSpace(dto.AudioUrl) && string.IsNullOrWhiteSpace(dto.TextInput))
                return ServiceResult<TurnResultDto>.Fail(ServiceError.BadRequest, "لازم صوت أو نص، واحد منهم على الأقل.");

            var session = await _db.Sessions
                .Include(s => s.Topic)
                .Include(s => s.Turns)
                .FirstOrDefaultAsync(s => s.Id == sessionId);

            if (session == null || session.UserId != userId)
                return ServiceResult<TurnResultDto>.Fail(ServiceError.NotFound, "الجلسة غير موجودة.");

            if (session.Status != SessionStatus.InProgress)
                return ServiceResult<TurnResultDto>.Fail(ServiceError.BadRequest, "الجلسة خلصت، ما تقدري تضيفي عليها.");

            var history = session.Turns.OrderBy(t => t.TurnNumber).Select(t => t.AiReplyText).ToList();
            var aiResult = await _ai.ProcessTurnAsync(dto.AudioUrl, dto.TextInput, session.Topic.Name, history);

            var nextTurnNumber = session.Turns.Max(t => t.TurnNumber) + 1;

            var turn = new Turn
            {
                SessionId = session.Id,
                TurnNumber = nextTurnNumber,
                AudioUrl = dto.AudioUrl,
                TextInput = dto.TextInput,
                TranscribedText = aiResult.TranscribedText,
                AiReplyText = aiResult.AiReplyText,
                PronunciationScore = aiResult.PronunciationScore,
                FluencyScore = aiResult.FluencyScore,
                VocabularyScore = aiResult.VocabularyScore,
                FeedbackText = aiResult.FeedbackText,
                PhonemeFocusSound = aiResult.PhonemeFocusSound,
                PhonemeTip = aiResult.PhonemeTip,
                NativeAudioUrl = aiResult.NativeAudioUrl
            };
            _db.Turns.Add(turn);
            await _db.SaveChangesAsync();

            return ServiceResult<TurnResultDto>.Ok(MapTurn(turn));
        }

        public async Task<ServiceResult<SessionSummaryDto>> EndSessionAsync(int userId, int sessionId)
        {
            var session = await _db.Sessions
                .Include(s => s.Turns)
                .Include(s => s.User)
                .FirstOrDefaultAsync(s => s.Id == sessionId);

            if (session == null || session.UserId != userId)
                return ServiceResult<SessionSummaryDto>.Fail(ServiceError.NotFound, "الجلسة غير موجودة.");

            if (session.Status == SessionStatus.Completed)
                return ServiceResult<SessionSummaryDto>.Fail(ServiceError.BadRequest, "الجلسة منتهية مسبقًا.");

            var scoredTurns = session.Turns.Where(t => t.TurnNumber > 0).ToList();

            double? avgPron = null, avgFluency = null, avgVocab = null, overall = null;
            if (scoredTurns.Count > 0)
            {
                avgPron = scoredTurns.Average(t => t.PronunciationScore);
                avgFluency = scoredTurns.Average(t => t.FluencyScore);
                avgVocab = scoredTurns.Average(t => t.VocabularyScore);
                overall = (avgPron.Value + avgFluency.Value + avgVocab.Value) / 3;
            }

            session.AvgPronunciation = avgPron;
            session.AvgFluency = avgFluency;
            session.AvgVocabulary = avgVocab;
            session.SummaryScore = overall;
            session.Status = SessionStatus.Completed;
            session.EndedAt = DateTime.UtcNow;

            var xpPerSession = _config.GetValue<int>("Gamification:XpPerCompletedSession");
            session.XpEarned = xpPerSession;
            session.User.CosmicXp += xpPerSession;

            UpdateStreak(session.User);

            // Recalibration — بس لو فيه درجات فعلية (مش جلسة فاضية)
            if (overall.HasValue)
            {
                var (level, cefr) = CefrCalculator.Recalibrate(session.User.CefrLevel, overall.Value);
                session.User.Level = level;
                session.User.CefrLevel = cefr;
            }

            await _db.SaveChangesAsync();
            _cache.Remove($"progress:{session.UserId}");

            return ServiceResult<SessionSummaryDto>.Ok(new SessionSummaryDto
            {
                SessionId = session.Id,
                SummaryScore = session.SummaryScore,
                AvgPronunciation = session.AvgPronunciation,
                AvgFluency = session.AvgFluency,
                AvgVocabulary = session.AvgVocabulary,
                XpEarned = session.XpEarned,
                TotalXp = session.User.CosmicXp,
                CurrentStreak = session.User.CurrentStreak,
                CefrLevel = session.User.CefrLevel
            });
        }

        private static string BuildOpeningLine(string topicName) =>
            $"Hi! Let's talk about {topicName}. Tell me a bit about it — how would you start?";

        private static void UpdateStreak(ApplicationUser user)
        {
            var today = DateTime.UtcNow.Date;
            var lastDate = user.LastSessionDate?.Date;

            if (lastDate == today) { /* جلسة تانية نفس اليوم — ما بيتكرر */ }
            else if (lastDate == today.AddDays(-1)) user.CurrentStreak += 1;
            else user.CurrentStreak = 1;

            user.LastSessionDate = today;
        }

        private static SessionDetailDto MapDetail(Session session) => new()
        {
            Id = session.Id,
            TopicName = session.Topic.Name,
            Status = session.Status.ToString(),
            StartedAt = session.StartedAt,
            SummaryScore = session.SummaryScore,
            MaxTurns = session.Topic.MaxTurns,
            Turns = session.Turns.OrderBy(t => t.TurnNumber).Select(MapTurn).ToList()
        };

        private static TurnResultDto MapTurn(Turn t) => new()
        {
            TurnNumber = t.TurnNumber,
            TranscribedText = t.TranscribedText,
            AiReplyText = t.AiReplyText,
            PronunciationScore = t.PronunciationScore,
            FluencyScore = t.FluencyScore,
            FeedbackText = t.FeedbackText,
            PhonemeFocusSound = t.PhonemeFocusSound,
            PhonemeTip = t.PhonemeTip,
            NativeAudioUrl = t.NativeAudioUrl
        };
    }
}