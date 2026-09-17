using System.ComponentModel.DataAnnotations;

namespace BackendTrack.Dtos.UserManagementDtos
{
    public class UpdateProfileDto
    {
        [Required, MaxLength(100)]
        public string FullName { get; set; } = string.Empty;
    }
}
