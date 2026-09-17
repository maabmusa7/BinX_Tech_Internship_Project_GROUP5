namespace BackendTrack.Dtos.ProgressDtos
{
    public class TopicProgressDto
    {
        public string TopicName { get; set; } = string.Empty;
        public int SessionsCount { get; set; }
        public double AverageScore { get; set; }
    }
}
