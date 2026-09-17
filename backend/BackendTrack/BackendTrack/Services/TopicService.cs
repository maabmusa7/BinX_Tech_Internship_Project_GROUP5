using Backend.Data;
using Backend.Models;
using BackendTrack.Dtos.TopicDtos;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Caching.Memory;

namespace Backend.Services
{
    public class TopicService : ITopicService
    {
        private const string CacheKey = "active_topics";

        private readonly AppDbContext _db;
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly IMemoryCache _cache;

        public TopicService(AppDbContext db, UserManager<ApplicationUser> userManager, IMemoryCache cache)
        {
            _db = db;
            _userManager = userManager;
            _cache = cache;
        }

        public async Task<List<TopicDto>> GetActiveTopicsForUserAsync(int userId)
        {
            var allTopics = await _cache.GetOrCreateAsync(CacheKey, async entry =>
            {
                entry.AbsoluteExpirationRelativeToNow = TimeSpan.FromMinutes(10);

                return await _db.Topics
                    .Where(t => t.IsActive)
                    .Select(t => new TopicDto
                    {
                        Id = t.Id,
                        Name = t.Name,
                        Description = t.Description,
                        Difficulty = t.Difficulty.ToString()
                    })
                    .ToListAsync();
            }) ?? new List<TopicDto>();

            var user = await _userManager.FindByIdAsync(userId.ToString());
            if (user?.Level == null)
                return allTopics;

            return allTopics
                .OrderBy(t => t.Difficulty == user.Level.ToString() ? 0 : 1)
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
                    Difficulty = t.Difficulty.ToString()
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
                Difficulty = topic.Difficulty.ToString()
            };
        }

        public async Task<ServiceResult> UpdateAsync(int id, UpdateTopicDto dto)
        {
            var topic = await _db.Topics.FindAsync(id);
            if (topic == null)
                return ServiceResult.Fail(ServiceError.NotFound, "Topic Not Found.");

            topic.Name = dto.Name;
            topic.Description = dto.Description;
            topic.Difficulty = dto.Difficulty;
            topic.IsActive = dto.IsActive;

            await _db.SaveChangesAsync();
            _cache.Remove(CacheKey);

            return ServiceResult.Ok();
        }

        public async Task<ServiceResult> DeactivateAsync(int id)
        {
            var topic = await _db.Topics.FindAsync(id);
            if (topic == null)
                return ServiceResult.Fail(ServiceError.NotFound, "Topic Not Found.");

            topic.IsActive = false;
            await _db.SaveChangesAsync();
            _cache.Remove(CacheKey);

            return ServiceResult.Ok();
        }
    }
}