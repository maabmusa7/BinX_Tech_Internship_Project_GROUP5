using BackendTrack.Dtos.SessionDtos;

namespace Backend.Services
{
    public interface ISessionService
    {
        Task<ServiceResult<SessionDto>> StartSessionAsync(int userId, StartSessionDto dto);
        Task<ServiceResult<SessionDetailDto>> GetSessionAsync(int userId, int sessionId);
        Task<ServiceResult<TurnResultDto>> SendTurnAsync(int userId, int sessionId, SendTurnDto dto);
        Task<ServiceResult<SessionSummaryDto>> EndSessionAsync(int userId, int sessionId);
        Task<ServiceResult<SessionDetailDto>> GetActiveSessionAsync(int userId);
    }
}