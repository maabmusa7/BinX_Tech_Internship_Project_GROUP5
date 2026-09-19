using BackendTrack.Models;
using Microsoft.AspNetCore.Identity;

namespace Backend.Models
{

    public class ApplicationUser : IdentityUser<int>
    {
        public string FullName { get; set; } = string.Empty;


        public LevelEnum? Level { get; set; }


        public int CurrentStreak { get; set; } = 0;
        public DateTime? LastSessionDate { get; set; }


        public bool IsActive { get; set; } = true;


        public string? RefreshToken { get; set; }
        public DateTime? RefreshTokenExpiryTime { get; set; }

        public ICollection<Session> Sessions { get; set; } = new List<Session>();
    }
}