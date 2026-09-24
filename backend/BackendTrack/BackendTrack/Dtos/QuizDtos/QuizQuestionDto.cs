namespace BackendTrack.Dtos.QuizDtos
{
    public class QuizQuestionDto
    {
        public int Id { get; set; }
        public string Text { get; set; } = string.Empty;
        public string Category { get; set; } = string.Empty;
        public string Difficulty { get; set; } = string.Empty;
        public List<QuizOptionDto> Options { get; set; } = new();
    }
}
