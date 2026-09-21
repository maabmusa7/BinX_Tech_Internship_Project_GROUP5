using System.ComponentModel.DataAnnotations;

namespace BackendTrack.Dtos.SessionDtos
{
    public class SendTurnDto
    {
        public string? AudioUrl { get; set; }
        public string? TextInput { get; set; }
    }
}
