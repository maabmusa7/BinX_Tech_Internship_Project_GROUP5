namespace BackendTrack.Dtos.SessionDtos
{
    public class TurnResultDto
    {
        public int TurnNumber { get; set; }
        public string TranscribedText { get; set; } = string.Empty;
        public string AiReplyText { get; set; } = string.Empty;
        public double PronunciationScore { get; set; }
        public double FluencyScore { get; set; }
        public string FeedbackText { get; set; } = string.Empty;
        public string? PhonemeFocusSound { get; set; }
        public string? PhonemeTip { get; set; }
        public string? NativeAudioUrl { get; set; }
    }
}
