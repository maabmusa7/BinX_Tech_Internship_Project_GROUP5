using System.ComponentModel.DataAnnotations;

namespace BackendTrack.Dtos.QuizDtos
{
    public class QuizAnswerDto
    {
        [Required]
        public int QuestionId { get; set; }

        [Required]
        public int SelectedOptionId { get; set; }
    }
}
