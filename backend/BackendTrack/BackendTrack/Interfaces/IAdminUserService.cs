
using BackendTrack.Dtos.ProgressDtos;
using BackendTrack.Dtos.UserManagementDtos;

namespace Backend.Services
{
    public interface IAdminUserService
    {
        Task<PagedResultDto<AdminUserDto>> GetUsersAsync(int page, int pageSize);
        Task<ServiceResult> UpdateStatusAsync(int id, UpdateUserStatusDto dto);
    }
}