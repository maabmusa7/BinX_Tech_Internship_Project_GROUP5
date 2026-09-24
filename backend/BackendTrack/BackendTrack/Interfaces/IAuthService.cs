using BackendTrack.Dtos.AuthDtos;

namespace Backend.Services
{
    public interface IAuthService
    {
        Task<ServiceResult<AuthResponseDto>> RegisterAsync(RegisterDto dto);
        Task<ServiceResult<AuthResponseDto>> LoginAsync(LoginDto dto);
        Task<ServiceResult<AuthResponseDto>> RefreshAsync(RefreshRequestDto dto);
        Task<ServiceResult> LogoutAsync(int userId);
        Task<ServiceResult<string>> ForgotPasswordAsync(ForgotPasswordDto dto);
        Task<ServiceResult> ResetPasswordAsync(ResetPasswordDto dto);
    }
}