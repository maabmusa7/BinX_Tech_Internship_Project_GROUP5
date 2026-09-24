namespace BackendTrack.Dtos.ProgressDtos
{
    public class ProgressDto
    {
        public int CurrentStreak { get; set; }
        public int TotalCompletedSessions { get; set; }
        public double? OverallAverageScore { get; set; }
        public int TotalXp { get; set; }
        public int TotalMinutesSpoken { get; set; }
        public string? CefrLevel { get; set; }
        public List<TopicProgressDto> TopicsPracticed { get; set; } = new();
        public List<SessionScorePointDto> RecentSessionScores { get; set; } = new(); 
    }
    public class SessionScorePointDto
    {
        public DateTime Date { get; set; }
        public double Score { get; set; }
    }

}
