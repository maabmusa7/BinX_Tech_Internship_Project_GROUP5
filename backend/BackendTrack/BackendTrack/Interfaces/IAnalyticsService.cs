using BackendTrack.Dtos.UserManagementDtos;

namespace Backend.Services
{
    public interface IAnalyticsService
    {
        Task<AnalyticsDto> GetAnalyticsAsync();
    }
}