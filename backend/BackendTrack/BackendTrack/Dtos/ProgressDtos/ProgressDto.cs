namespace BackendTrack.Dtos.ProgressDtos
{
    public class ProgressDto
    {
        public int CurrentStreak { get; set; }
        public int TotalCompletedSessions { get; set; }
        public double? OverallAverageScore { get; set; }
        public List<TopicProgressDto> TopicsPracticed { get; set; } = new();
    }
}
