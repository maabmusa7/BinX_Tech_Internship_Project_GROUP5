using System.ComponentModel.DataAnnotations;

namespace BackendTrack.Dtos.UserManagementDtos
{
    public class UpdateUserStatusDto
    {
        [Required]
        public bool IsActive { get; set; }
    }
}
