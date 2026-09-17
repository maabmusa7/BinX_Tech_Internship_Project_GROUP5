using System.ComponentModel.DataAnnotations;

namespace BackendTrack.Dtos.UserManagementDtos
{
    public class ChangePasswordDto
    {
        [Required]
        public string CurrentPassword { get; set; } = string.Empty;

        [Required, MinLength(8)]
        public string NewPassword { get; set; } = string.Empty;
    }
}
