namespace BackendTrack.Dtos.ProgressDtos
{
    public class SessionHistoryItemDto
    {
        public int Id { get; set; }
        public string TopicName { get; set; } = string.Empty;
        public string Status { get; set; } = string.Empty;
        public DateTime StartedAt { get; set; }
        public DateTime? EndedAt { get; set; }
        public double? SummaryScore { get; set; }
    }
}
