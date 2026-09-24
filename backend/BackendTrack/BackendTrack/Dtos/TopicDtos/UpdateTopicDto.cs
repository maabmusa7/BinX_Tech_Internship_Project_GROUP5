using Backend.Models;
using BackendTrack.Models;
using System.ComponentModel.DataAnnotations;

public class UpdateTopicDto
{
    [Required, MaxLength(100)]
    public string Name { get; set; } = string.Empty;

    [Required]
    public string Description { get; set; } = string.Empty;

    [Required]
    public LevelEnum Difficulty { get; set; }

    [Required]
    public TopicCategory Category { get; set; }

    public int EstimatedMinutes { get; set; } = 5;

    [Required]
    public string SessionMission { get; set; } = string.Empty;

    public int MaxTurns { get; set; } = 6;

    public bool IsActive { get; set; } = true;
}