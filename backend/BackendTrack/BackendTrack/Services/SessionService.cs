using Backend.Data;
using Backend.Models;
using BackendTrack.Dtos.SessionDtos;
using BackendTrack.Interfaces;
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

        public SessionService(AppDbContext db, IAiSpeechService ai, IMemoryCache cache)
        {
            _db = db;
            _ai = ai;
            _cache = cache;
        }

        // UC-U5
        public async Task<ServiceResult<SessionDto>> StartSessionAsync(int userId, StartSessionDto dto)
        {
            var topic = await _db.Topics.FindAsync(dto.TopicId);
            if (topic == null || !topic.IsActive)
                return ServiceResult<SessionDto>.Fail(ServiceError.NotFound, "Topic Not Found.");

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
                AudioUrl = string.Empty,
                TranscribedText = string.Empty,
                AiReplyText = openingLine,
                PronunciationScore = 0,
                FeedbackText = string.Empty
            });
            await _db.SaveChangesAsync();

            return ServiceResult<SessionDto>.Ok(new SessionDto
            {
                Id = session.Id,
                TopicName = topic.Name,
                Status = session.Status.ToString(),
                StartedAt = session.StartedAt,
                OpeningLine = openingLine
            });
        }

        public async Task<ServiceResult<SessionDetailDto>> GetSessionAsync(int userId, int sessionId)
        {
            var session = await _db.Sessions
                .Include(s => s.Topic)
                .Include(s => s.Turns)
                .FirstOrDefaultAsync(s => s.Id == sessionId);

            if (session == null || session.UserId != userId)
                return ServiceResult<SessionDetailDto>.Fail(ServiceError.NotFound, "Session Not Found.");

            return ServiceResult<SessionDetailDto>.Ok(new SessionDetailDto
            {
                Id = session.Id,
                TopicName = session.Topic.Name,
                Status = session.Status.ToString(),
                StartedAt = session.StartedAt,
                SummaryScore = session.SummaryScore,
                Turns = session.Turns.OrderBy(t => t.TurnNumber).Select(t => new TurnResultDto
                {
                    TurnNumber = t.TurnNumber,
                    TranscribedText = t.TranscribedText,
                    AiReplyText = t.AiReplyText,
                    PronunciationScore = t.PronunciationScore,
                    FeedbackText = t.FeedbackText
                }).ToList()
            });
        }

        // UC-U6 + UC-U7
        public async Task<ServiceResult<TurnResultDto>> SendTurnAsync(int userId, int sessionId, SendTurnDto dto)
        {
            var session = await _db.Sessions
                .Include(s => s.Topic)
                .Include(s => s.Turns)
                .FirstOrDefaultAsync(s => s.Id == sessionId);

            if (session == null || session.UserId != userId)
                return ServiceResult<TurnResultDto>.Fail(ServiceError.NotFound, "Session Not Found.");

            if (session.Status != SessionStatus.InProgress)
                return ServiceResult<TurnResultDto>.Fail(ServiceError.BadRequest, "Session Finished , You Can’t Add At This Session.");

            var history = session.Turns.OrderBy(t => t.TurnNumber).Select(t => t.AiReplyText).ToList();
            var aiResult = await _ai.ProcessTurnAsync(dto.AudioUrl, session.Topic.Name, history);

            var nextTurnNumber = session.Turns.Max(t => t.TurnNumber) + 1;

            var turn = new Turn
            {
                SessionId = session.Id,
                TurnNumber = nextTurnNumber,
                AudioUrl = dto.AudioUrl,
                TranscribedText = aiResult.TranscribedText,
                AiReplyText = aiResult.AiReplyText,
                PronunciationScore = aiResult.PronunciationScore,
                FeedbackText = aiResult.FeedbackText
            };
            _db.Turns.Add(turn);
            await _db.SaveChangesAsync();

            return ServiceResult<TurnResultDto>.Ok(new TurnResultDto
            {
                TurnNumber = turn.TurnNumber,
                TranscribedText = turn.TranscribedText,
                AiReplyText = turn.AiReplyText,
                PronunciationScore = turn.PronunciationScore,
                FeedbackText = turn.FeedbackText
            });
        }

        // UC-U8
        public async Task<ServiceResult<SessionSummaryDto>> EndSessionAsync(int userId, int sessionId)
        {
            var session = await _db.Sessions
                .Include(s => s.Turns)
                .Include(s => s.User)
                .FirstOrDefaultAsync(s => s.Id == sessionId);

            if (session == null || session.UserId != userId)
                return ServiceResult<SessionSummaryDto>.Fail(ServiceError.NotFound, "Session Not Found.");

            if (session.Status == SessionStatus.Completed)
                return ServiceResult<SessionSummaryDto>.Fail(ServiceError.BadRequest, "Session Finished.");

            var scoredTurns = session.Turns.Where(t => t.TurnNumber > 0).ToList();
            session.SummaryScore = scoredTurns.Count > 0 ? scoredTurns.Average(t => t.PronunciationScore) : null;
            session.Status = SessionStatus.Completed;
            session.EndedAt = DateTime.UtcNow;

            UpdateStreak(session.User);

            await _db.SaveChangesAsync();
            _cache.Remove($"progress:{session.UserId}");

            return ServiceResult<SessionSummaryDto>.Ok(new SessionSummaryDto
            {
                SessionId = session.Id,
                SummaryScore = session.SummaryScore,
                CurrentStreak = session.User.CurrentStreak
            });
        }

        private static string BuildOpeningLine(string topicName) =>
            $"Hi! Let's talk about {topicName}. Tell me a bit about it — how would you start?";

        private static void UpdateStreak(ApplicationUser user)
        {
            var today = DateTime.UtcNow.Date;
            var lastDate = user.LastSessionDate?.Date;

            if (lastDate == today)
            {
            }
            else if (lastDate == today.AddDays(-1))
            {
                user.CurrentStreak += 1;
            }
            else
            {
                user.CurrentStreak = 1;
            }

            user.LastSessionDate = today;
        }
    }
}