using Backend.Models;
using System.Security.Claims;

namespace BackendTrack.Interfaces
{
    public interface ITokenService
    {
        Task<(string token, DateTime expiresAt)> GenerateTokenAsync(ApplicationUser user);
        string GenerateRefreshToken();
        ClaimsPrincipal? GetPrincipalFromExpiredToken(string token);
    }
}
