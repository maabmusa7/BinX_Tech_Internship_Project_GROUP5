
using BackendTrack.Dtos.TopicDtos;

namespace Backend.Services
{
    public interface ITopicService
    {
        Task<List<TopicDto>> GetActiveTopicsForUserAsync(int userId);
        Task<List<TopicDto>> GetAllTopicsAsync(); 
        Task<TopicDto> CreateAsync(CreateTopicDto dto);
        Task<ServiceResult> UpdateAsync(int id, UpdateTopicDto dto);
        Task<ServiceResult> DeactivateAsync(int id);
    }
}