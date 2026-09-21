namespace BackendTrack.Dtos.TopicDtos
{
    public class TopicDto
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
        public string Difficulty { get; set; } = string.Empty;
        public string Category { get; set; } = string.Empty;
        public int EstimatedMinutes { get; set; }
        public string SessionMission { get; set; } = string.Empty;
        public int MaxTurns { get; set; }

        // إحصائيات المستخدم الحالي لهاد الموضوع تحديدًا — شاشة "Choose Your Topic"
        public int CompletedSessionsCount { get; set; }
        public double? MasteryPercent { get; set; }
        public string ProgressStatus { get; set; } = "NotStarted"; // NotStarted | InProgress | Mastered
    }
}
