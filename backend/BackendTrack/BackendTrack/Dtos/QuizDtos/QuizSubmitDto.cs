using System.ComponentModel.DataAnnotations;

namespace BackendTrack.Dtos.QuizDtos
{
    public class QuizSubmitDto
    {
        [Required]
        public List<QuizAnswerDto> Answers { get; set; } = new();
    }
}
