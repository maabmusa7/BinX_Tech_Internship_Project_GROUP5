namespace BackendTrack.Dtos.QuizDtos
{
    public class QuizResultDto
    {
        public int TotalScore { get; set; }
        public int CorrectCount { get; set; }
        public int TotalQuestions { get; set; }
        public string Level { get; set; } = string.Empty;     
        public string CefrLevel { get; set; } = string.Empty; 
        public int? TimeTakenSeconds { get; set; }
    }
}
