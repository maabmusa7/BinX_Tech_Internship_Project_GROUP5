using Backend.Data;
using Backend.Models;
using BackendTrack.Dtos.ProgressDtos;
using BackendTrack.Dtos.UserManagementDtos;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;

namespace Backend.Services
{
    public class AdminUserService : IAdminUserService
    {
        private readonly AppDbContext _db;
        private readonly UserManager<ApplicationUser> _userManager;

        public AdminUserService(AppDbContext db, UserManager<ApplicationUser> userManager)
        {
            _db = db;
            _userManager = userManager;
        }

        // UC-A3
        public async Task<PagedResultDto<AdminUserDto>> GetUsersAsync(int page, int pageSize)
        {
            page = Math.Max(page, 1);
            pageSize = Math.Clamp(pageSize, 1, 100);

            var query = _db.Users.OrderBy(u => u.Email);
            var totalCount = await query.CountAsync();

            var users = await query
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToListAsync();

            var result = new List<AdminUserDto>();
            foreach (var user in users)
            {
                var roles = await _userManager.GetRolesAsync(user);
                result.Add(new AdminUserDto
                {
                    Id = user.Id,
                    Email = user.Email!,
                    FullName = user.FullName,
                    Role = roles.FirstOrDefault() ?? "User",
                    IsActive = user.IsActive,
                    Level = user.Level?.ToString()
                });
            }

            return new PagedResultDto<AdminUserDto>
            {
                Items = result,
                TotalCount = totalCount,
                Page = page,
                PageSize = pageSize
            };
        }

        public async Task<ServiceResult> UpdateStatusAsync(int id, UpdateUserStatusDto dto)
        {
            var user = await _userManager.FindByIdAsync(id.ToString());
            if (user == null)
                return ServiceResult.Fail(ServiceError.NotFound, "User Not Found.");

            user.IsActive = dto.IsActive;
            await _userManager.UpdateAsync(user);

            return ServiceResult.Ok();
        }
    }
}