using Backend.Data;
using Backend.Models;
using BackendTrack.Dtos.TopicDtos;
using BackendTrack.Models;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Caching.Memory;

namespace Backend.Services
{
    public class TopicService : ITopicService
    {
        private const string CacheKey = "active_topics_base";

        private readonly AppDbContext _db;
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly IMemoryCache _cache;

        public TopicService(AppDbContext db, UserManager<ApplicationUser> userManager, IMemoryCache cache)
        {
            _db = db;
            _userManager = userManager;
            _cache = cache;
        }

        public async Task<List<TopicDto>> GetActiveTopicsForUserAsync(int userId, TopicCategory? category, string? search)
        {
            var baseTopics = await _cache.GetOrCreateAsync(CacheKey, async entry =>
            {
                entry.AbsoluteExpirationRelativeToNow = TimeSpan.FromMinutes(10);
                return await _db.Topics.Where(t => t.IsActive).ToListAsync();
            }) ?? new List<Topic>();

            var filtered = baseTopics.AsEnumerable();

            if (category.HasValue)
                filtered = filtered.Where(t => t.Category == category.Value);

            if (!string.IsNullOrWhiteSpace(search))
            {
                var s = search.Trim();
                filtered = filtered.Where(t =>
                    t.Name.Contains(s, StringComparison.OrdinalIgnoreCase) ||
                    t.Description.Contains(s, StringComparison.OrdinalIgnoreCase));
            }

            var filteredList = filtered.ToList();
            var topicIds = filteredList.Select(t => t.Id).ToList();

            // إحصائيات المستخدم لكل موضوع بـ query واحد (لا N+1)
            var userStats = await _db.Sessions
                .Where(s => s.UserId == userId && topicIds.Contains(s.TopicId) && s.Status == SessionStatus.Completed && s.SummaryScore != null)
                .GroupBy(s => s.TopicId)
                .Select(g => new { TopicId = g.Key, Count = g.Count(), Avg = g.Average(s => s.SummaryScore!.Value) })
                .ToListAsync();

            var user = await _userManager.FindByIdAsync(userId.ToString());
            var userLevelStr = user?.Level?.ToString();

            var result = filteredList.Select(t =>
            {
                var stats = userStats.FirstOrDefault(x => x.TopicId == t.Id);
                var status = stats == null ? "NotStarted" : stats.Count >= 3 ? "Mastered" : "InProgress";

                return new TopicDto
                {
                    Id = t.Id,
                    Name = t.Name,
                    Description = t.Description,
                    Difficulty = t.Difficulty.ToString(),
                    Category = t.Category.ToString(),
                    EstimatedMinutes = t.EstimatedMinutes,
                    SessionMission = t.SessionMission,
                    MaxTurns = t.MaxTurns,
                    CompletedSessionsCount = stats?.Count ?? 0,
                    MasteryPercent = stats?.Avg,
                    ProgressStatus = status
                };
            });

            // مواضيع مستوى المستخدم أول، والباقي بعدها
            return result
                .OrderBy(t => t.Difficulty == userLevelStr ? 0 : 1)
                .ToList();
        }

        public async Task<List<TopicDto>> GetAllTopicsAsync()
        {
            return await _db.Topics
                .Select(t => new TopicDto
                {
                    Id = t.Id,
                    Name = t.Name,
                    Description = t.Description,
                    Difficulty = t.Difficulty.ToString(),
                    Category = t.Category.ToString(),
                    EstimatedMinutes = t.EstimatedMinutes,
                    SessionMission = t.SessionMission,
                    MaxTurns = t.MaxTurns
                })
                .ToListAsync();
        }

        public async Task<TopicDto> CreateAsync(CreateTopicDto dto)
        {
            var topic = new Topic
            {
                Name = dto.Name,
                Description = dto.Description,
                Difficulty = dto.Difficulty,
                Category = dto.Category,
                EstimatedMinutes = dto.EstimatedMinutes,
                SessionMission = dto.SessionMission,
                MaxTurns = dto.MaxTurns,
                IsActive = true
            };

            _db.Topics.Add(topic);
            await _db.SaveChangesAsync();
            _cache.Remove(CacheKey);

            return new TopicDto
            {
                Id = topic.Id,
                Name = topic.Name,
                Description = topic.Description,
                Difficulty = topic.Difficulty.ToString(),
                Category = topic.Category.ToString(),
                EstimatedMinutes = topic.EstimatedMinutes,
                SessionMission = topic.SessionMission,
                MaxTurns = topic.MaxTurns
            };
        }

        public async Task<ServiceResult> UpdateAsync(int id, UpdateTopicDto dto)
        {
            var topic = await _db.Topics.FindAsync(id);
            if (topic == null)
                return ServiceResult.Fail(ServiceError.NotFound, "الموضوع غير موجود.");

            topic.Name = dto.Name;
            topic.Description = dto.Description;
            topic.Difficulty = dto.Difficulty;
            topic.Category = dto.Category;
            topic.EstimatedMinutes = dto.EstimatedMinutes;
            topic.SessionMission = dto.SessionMission;
            topic.MaxTurns = dto.MaxTurns;
            topic.IsActive = dto.IsActive;

            await _db.SaveChangesAsync();
            _cache.Remove(CacheKey);

            return ServiceResult.Ok();
        }

        public async Task<ServiceResult> DeactivateAsync(int id)
        {
            var topic = await _db.Topics.FindAsync(id);
            if (topic == null)
                return ServiceResult.Fail(ServiceError.NotFound, "الموضوع غير موجود.");

            topic.IsActive = false;
            await _db.SaveChangesAsync();
            _cache.Remove(CacheKey);

            return ServiceResult.Ok();
        }

        
    }
}