namespace BackendTrack.Dtos.SessionDtos
{
    public class SessionDetailDto
    {
        public int Id { get; set; }
        public string TopicName { get; set; } = string.Empty;
        public string Status { get; set; } = string.Empty;
        public DateTime StartedAt { get; set; }
        public double? SummaryScore { get; set; }
        public List<TurnResultDto> Turns { get; set; } = new();
    }
}
