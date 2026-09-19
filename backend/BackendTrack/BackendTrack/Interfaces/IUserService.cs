
using BackendTrack.Dtos.ProgressDtos;
using BackendTrack.Dtos.UserManagementDtos;

namespace Backend.Services
{
    public interface IUserService
    {
        Task<ServiceResult<AdminUserDto>> GetMeAsync(int userId);
        Task<ServiceResult<PagedResultDto<SessionHistoryItemDto>>> GetSessionHistoryAsync(int targetUserId, int page, int pageSize);
        Task<ServiceResult<ProgressDto>> GetProgressAsync(int targetUserId);
        Task<ServiceResult> UpdateProfileAsync(int userId, UpdateProfileDto dto);
        Task<ServiceResult> ChangePasswordAsync(int userId, ChangePasswordDto dto);
    }
}