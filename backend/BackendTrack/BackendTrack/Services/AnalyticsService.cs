using Backend.Data;
using BackendTrack.Dtos.UserManagementDtos;
using BackendTrack.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Caching.Memory;

namespace Backend.Services
{
    public class AnalyticsService : IAnalyticsService
    {
        private const string CacheKey = "platform_analytics";

        private readonly AppDbContext _db;
        private readonly IMemoryCache _cache;

        public AnalyticsService(AppDbContext db, IMemoryCache cache)
        {
            _db = db;
            _cache = cache;
        }

        public async Task<AnalyticsDto> GetAnalyticsAsync()
        {
            return await _cache.GetOrCreateAsync(CacheKey, async entry =>
            {
                entry.AbsoluteExpirationRelativeToNow = TimeSpan.FromMinutes(5);

                var totalUsers = await _db.Users.CountAsync();
                var totalSessions = await _db.Sessions.CountAsync();

                var completedQuery = _db.Sessions.Where(s => s.Status == SessionStatus.Completed && s.SummaryScore != null);
                var totalCompleted = await completedQuery.CountAsync();
                var overallAverage = totalCompleted > 0 ? await completedQuery.AverageAsync(s => s.SummaryScore) : null;

                var topTopics = await _db.Sessions
                    .GroupBy(s => s.Topic.Name)
                    .Select(g => new TopicUsageDto { TopicName = g.Key, SessionsCount = g.Count() })
                    .OrderByDescending(t => t.SessionsCount)
                    .Take(5)
                    .ToListAsync();

                return new AnalyticsDto
                {
                    TotalUsers = totalUsers,
                    TotalSessions = totalSessions,
                    TotalCompletedSessions = totalCompleted,
                    OverallAverageScore = overallAverage,
                    MostPracticedTopics = topTopics
                };
            }) ?? new AnalyticsDto();
        }
    }
}