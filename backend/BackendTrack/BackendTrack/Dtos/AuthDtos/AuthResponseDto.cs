namespace BackendTrack.Dtos.AuthDtos
{
    public class AuthResponseDto
    {
        public int UserId { get; set; }
        public string Token { get; set; } = string.Empty;
        public DateTime ExpiresAt { get; set; }
        public string RefreshToken { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string FullName { get; set; } = string.Empty;
        public string Role { get; set; } = string.Empty;
        public string? Level { get; set; }
        public int CurrentStreak { get; set; }
    }
}
