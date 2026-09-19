using System.ComponentModel.DataAnnotations;

namespace BackendTrack.Dtos.SessionDtos
{
    public class StartSessionDto
    {
        [Required]
        public int TopicId { get; set; }
    }
}
