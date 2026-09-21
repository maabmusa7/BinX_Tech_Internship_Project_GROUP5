namespace BackendTrack.Dtos.SessionDtos
{
    public class SessionSummaryDto
    {
        public int SessionId { get; set; }
        public double? SummaryScore { get; set; }
        public double? AvgPronunciation { get; set; }
        public double? AvgFluency { get; set; }
        public double? AvgVocabulary { get; set; }
        public int XpEarned { get; set; }
        public int TotalXp { get; set; }
        public int CurrentStreak { get; set; }
        public string? CefrLevel { get; set; }
    }
}
