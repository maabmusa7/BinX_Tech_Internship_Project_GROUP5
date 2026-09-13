using System.ComponentModel.DataAnnotations;

namespace BackendTrack.Dtos
{
    public class RefreshRequestDto
    {
        [Required]
        public string Token { get; set; } = string.Empty;

        [Required]
        public string RefreshToken { get; set; } = string.Empty;
    }
}
