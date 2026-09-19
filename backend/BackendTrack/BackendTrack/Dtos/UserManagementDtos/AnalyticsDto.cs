namespace BackendTrack.Dtos.UserManagementDtos
{
    public class AnalyticsDto
    {
        public int TotalUsers { get; set; }
        public int TotalSessions { get; set; }
        public int TotalCompletedSessions { get; set; }
        public double? OverallAverageScore { get; set; }
        public List<TopicUsageDto> MostPracticedTopics { get; set; } = new();
    }
}
