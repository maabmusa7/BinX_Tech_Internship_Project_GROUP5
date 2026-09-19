using System.ComponentModel.DataAnnotations;

namespace BackendTrack.Dtos.SessionDtos
{
    public class SendTurnDto
    {
        [Required]
        public string AudioUrl { get; set; } = string.Empty; 
    }
}
