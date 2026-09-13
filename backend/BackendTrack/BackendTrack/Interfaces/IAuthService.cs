
using BackendTrack.Dtos;

namespace Backend.Services
{
    public interface IAuthService
    {
        Task<ServiceResult<AuthResponseDto>> RegisterAsync(RegisterDto dto);
        Task<ServiceResult<AuthResponseDto>> LoginAsync(LoginDto dto);
        Task<ServiceResult<AuthResponseDto>> RefreshAsync(RefreshRequestDto dto);
        Task<ServiceResult> LogoutAsync(int userId);
    }
}