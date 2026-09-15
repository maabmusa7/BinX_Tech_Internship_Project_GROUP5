using Backend.Models;
using System.ComponentModel.DataAnnotations;

public class UpdateTopicDto
{
    [Required, MaxLength(100)]
    public string Name { get; set; } = string.Empty;

    [Required]
    public string Description { get; set; } = string.Empty;

    [Required]
    public LevelEnum Difficulty { get; set; }

    public bool IsActive { get; set; } = true;
}