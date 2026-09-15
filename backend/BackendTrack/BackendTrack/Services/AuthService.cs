using Backend.Models;
using BackendTrack.Dtos.AuthDtos;
using BackendTrack.Interfaces;
using Microsoft.AspNetCore.Identity;
using System.Security.Claims;

namespace Backend.Services
{
    public class AuthService : IAuthService
    {
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly SignInManager<ApplicationUser> _signInManager;
        private readonly ITokenService _tokenService;
        private readonly IConfiguration _config;

        public AuthService(
            UserManager<ApplicationUser> userManager,
            SignInManager<ApplicationUser> signInManager,
            ITokenService tokenService,
            IConfiguration config)
        {
            _userManager = userManager;
            _signInManager = signInManager;
            _tokenService = tokenService;
            _config = config;
        }

        public async Task<ServiceResult<AuthResponseDto>> RegisterAsync(RegisterDto dto)
        {
            var existing = await _userManager.FindByEmailAsync(dto.Email);
            if (existing != null)
                return ServiceResult<AuthResponseDto>.Fail(ServiceError.Conflict, "البريد الإلكتروني مستخدم مسبقًا.");

            var user = new ApplicationUser
            {
                UserName = dto.Email,
                Email = dto.Email,
                FullName = dto.FullName
            };

            var result = await _userManager.CreateAsync(user, dto.Password);
            if (!result.Succeeded)
                return ServiceResult<AuthResponseDto>.Fail(ServiceError.BadRequest, result.Errors.Select(e => e.Description).ToList());

            await _userManager.AddToRoleAsync(user, "User");

            return ServiceResult<AuthResponseDto>.Ok(await BuildAuthResponseAsync(user));
        }

        public async Task<ServiceResult<AuthResponseDto>> LoginAsync(LoginDto dto)
        {
            var user = await _userManager.FindByEmailAsync(dto.Email);
            if (user == null || !user.IsActive)
                return ServiceResult<AuthResponseDto>.Fail(ServiceError.Unauthorized, "بيانات الدخول غير صحيحة أو الحساب معطّل.");

            var signInResult = await _signInManager.CheckPasswordSignInAsync(user, dto.Password, lockoutOnFailure: true);
            if (!signInResult.Succeeded)
                return ServiceResult<AuthResponseDto>.Fail(ServiceError.Unauthorized, "بيانات الدخول غير صحيحة.");

            return ServiceResult<AuthResponseDto>.Ok(await BuildAuthResponseAsync(user));
        }

        public async Task<ServiceResult<AuthResponseDto>> RefreshAsync(RefreshRequestDto dto)
        {
            var principal = _tokenService.GetPrincipalFromExpiredToken(dto.Token);
            var userId = principal?.FindFirstValue(ClaimTypes.NameIdentifier);
            if (userId == null)
                return ServiceResult<AuthResponseDto>.Fail(ServiceError.Unauthorized, "توكن غير صالح.");

            var user = await _userManager.FindByIdAsync(userId);
            if (user == null || !user.IsActive ||
                user.RefreshToken != dto.RefreshToken ||
                user.RefreshTokenExpiryTime <= DateTime.UtcNow)
            {
                return ServiceResult<AuthResponseDto>.Fail(ServiceError.Unauthorized, "Refresh Token غير صالح أو منتهي، لازم تسجّلي دخول من جديد.");
            }

            return ServiceResult<AuthResponseDto>.Ok(await BuildAuthResponseAsync(user));
        }

        public async Task<ServiceResult> LogoutAsync(int userId)
        {
            var user = await _userManager.FindByIdAsync(userId.ToString());
            if (user == null)
                return ServiceResult.Fail(ServiceError.NotFound, "المستخدم غير موجود.");

            user.RefreshToken = null;
            user.RefreshTokenExpiryTime = null;
            await _userManager.UpdateAsync(user);

            return ServiceResult.Ok();
        }

        private async Task<AuthResponseDto> BuildAuthResponseAsync(ApplicationUser user)
        {
            var roles = await _userManager.GetRolesAsync(user);
            var (accessToken, expiresAt) = await _tokenService.GenerateTokenAsync(user);
            var refreshToken = _tokenService.GenerateRefreshToken();

            user.RefreshToken = refreshToken;
            user.RefreshTokenExpiryTime = DateTime.UtcNow.AddDays(_config.GetValue<int>("Jwt:RefreshTokenExpiryDays"));
            await _userManager.UpdateAsync(user);

            return new AuthResponseDto
            {
                UserId = user.Id,
                Token = accessToken,
                ExpiresAt = expiresAt,
                RefreshToken = refreshToken,
                Email = user.Email!,
                FullName = user.FullName,
                Role = roles.FirstOrDefault() ?? "User",
                Level = user.Level?.ToString(),
                CurrentStreak = user.CurrentStreak
            };
        }
    }
}