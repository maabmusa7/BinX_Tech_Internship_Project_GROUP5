namespace BackendTrack.Dtos.SessionDtos
{
    public class SessionSummaryDto
    {
        public int SessionId { get; set; }
        public double? SummaryScore { get; set; }
        public int CurrentStreak { get; set; }
    }
}
