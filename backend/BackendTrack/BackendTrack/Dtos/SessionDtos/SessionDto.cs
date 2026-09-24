namespace BackendTrack.Dtos.SessionDtos
{
    public class SessionDto
    {
        public int Id { get; set; }
        public string TopicName { get; set; } = string.Empty;
        public string TopicCategory { get; set; } = string.Empty;
        public string SessionMission { get; set; } = string.Empty;
        public string Status { get; set; } = string.Empty;
        public DateTime StartedAt { get; set; }
        public string OpeningLine { get; set; } = string.Empty;
        public int MaxTurns { get; set; }
    }
}
