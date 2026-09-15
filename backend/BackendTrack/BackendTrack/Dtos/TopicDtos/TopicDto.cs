namespace BackendTrack.Dtos.TopicDtos
{
    public class TopicDto
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
        public string Difficulty { get; set; } = string.Empty;
    }
}
