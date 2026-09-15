using Backend.Models;
using System.ComponentModel.DataAnnotations;

namespace BackendTrack.Dtos.TopicDtos
{
    public class CreateTopicDto
    {
        [Required, MaxLength(100)]
        public string Name { get; set; } = string.Empty;

        [Required]
        public string Description { get; set; } = string.Empty;

        [Required]
        public LevelEnum Difficulty { get; set; }
    }
}
