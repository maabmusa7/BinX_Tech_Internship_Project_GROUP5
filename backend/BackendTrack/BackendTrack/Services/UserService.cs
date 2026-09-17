using Backend.Data;
using Backend.Models;
using BackendTrack.Dtos.ProgressDtos;
using BackendTrack.Dtos.UserManagementDtos;
using BackendTrack.Models;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Caching.Memory;

namespace Backend.Services
{
    public class UserService : IUserService
    {
        private readonly AppDbContext _db;
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly IMemoryCache _cache;

        public UserService(AppDbContext db, UserManager<ApplicationUser> userManager, IMemoryCache cache)
        {
            _db = db;
            _userManager = userManager;
            _cache = cache;
        }

        public async Task<ServiceResult<AdminUserDto>> GetMeAsync(int userId)
        {
            var user = await _userManager.FindByIdAsync(userId.ToString());
            if (user == null)
                return ServiceResult<AdminUserDto>.Fail(ServiceError.NotFound, "User Not Found.");

            var roles = await _userManager.GetRolesAsync(user);

            return ServiceResult<AdminUserDto>.Ok(new AdminUserDto
            {
                Id = user.Id,
                Email = user.Email!,
                FullName = user.FullName,
                Role = roles.FirstOrDefault() ?? "User",
                IsActive = user.IsActive,
                Level = user.Level?.ToString()
            });
        }

        public async Task<ServiceResult<PagedResultDto<SessionHistoryItemDto>>> GetSessionHistoryAsync(
            int targetUserId, int page, int pageSize)
        {
            page = Math.Max(page, 1);
            pageSize = Math.Clamp(pageSize, 1, 50);

            var query = _db.Sessions
                .Where(s => s.UserId == targetUserId)
                .OrderByDescending(s => s.StartedAt);

            var totalCount = await query.CountAsync();

            var items = await query
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .Select(s => new SessionHistoryItemDto
                {
                    Id = s.Id,
                    TopicName = s.Topic.Name,
                    Status = s.Status.ToString(),
                    StartedAt = s.StartedAt,
                    EndedAt = s.EndedAt,
                    SummaryScore = s.SummaryScore
                })
                .ToListAsync();

            return ServiceResult<PagedResultDto<SessionHistoryItemDto>>.Ok(new PagedResultDto<SessionHistoryItemDto>
            {
                Items = items,
                TotalCount = totalCount,
                Page = page,
                PageSize = pageSize
            });
        }


        public async Task<ServiceResult<ProgressDto>> GetProgressAsync(int targetUserId)
        {
            var cacheKey = $"progress:{targetUserId}";

            var cached = await _cache.GetOrCreateAsync(cacheKey, async entry =>
            {
                entry.AbsoluteExpirationRelativeToNow = TimeSpan.FromMinutes(2);

                var user = await _userManager.FindByIdAsync(targetUserId.ToString());
                if (user == null) return null;

                var completedSessions = _db.Sessions
                    .Where(s => s.UserId == targetUserId && s.Status == SessionStatus.Completed && s.SummaryScore != null);

                var totalCompleted = await completedSessions.CountAsync();
                var overallAverage = totalCompleted > 0 ? await completedSessions.AverageAsync(s => s.SummaryScore) : null;

                var byTopic = await completedSessions
                    .GroupBy(s => s.Topic.Name)
                    .Select(g => new TopicProgressDto
                    {
                        TopicName = g.Key,
                        SessionsCount = g.Count(),
                        AverageScore = g.Average(s => s.SummaryScore!.Value)
                    })
                    .ToListAsync();

                return new ProgressDto
                {
                    CurrentStreak = user.CurrentStreak,
                    TotalCompletedSessions = totalCompleted,
                    OverallAverageScore = overallAverage,
                    TopicsPracticed = byTopic
                };
            });

            if (cached == null)
                return ServiceResult<ProgressDto>.Fail(ServiceError.NotFound, "User Not Found.");

            return ServiceResult<ProgressDto>.Ok(cached);
        }

        public async Task<ServiceResult> UpdateProfileAsync(int userId, UpdateProfileDto dto)
        {
            var user = await _userManager.FindByIdAsync(userId.ToString());
            if (user == null)
                return ServiceResult.Fail(ServiceError.NotFound, "User Not Found.");

            user.FullName = dto.FullName;
            await _userManager.UpdateAsync(user);

            return ServiceResult.Ok();
        }

        // UC-U12
        public async Task<ServiceResult> ChangePasswordAsync(int userId, ChangePasswordDto dto)
        {
            var user = await _userManager.FindByIdAsync(userId.ToString());
            if (user == null)
                return ServiceResult.Fail(ServiceError.NotFound, "User Not Found.");

            var result = await _userManager.ChangePasswordAsync(user, dto.CurrentPassword, dto.NewPassword);
            if (!result.Succeeded)
                return ServiceResult.Fail(ServiceError.BadRequest, result.Errors.Select(e => e.Description).ToList());

            return ServiceResult.Ok();
        }
    }
}