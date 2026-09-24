
using BackendTrack.Dtos.TopicDtos;
using BackendTrack.Models;

namespace Backend.Services
{
    public interface ITopicService
    {
        Task<List<TopicDto>> GetActiveTopicsForUserAsync(int userId, TopicCategory? category, string? search);
        Task<List<TopicDto>> GetAllTopicsAsync(); 
        Task<TopicDto> CreateAsync(CreateTopicDto dto);
        Task<ServiceResult> UpdateAsync(int id, UpdateTopicDto dto);
        Task<ServiceResult> DeactivateAsync(int id);
    }
}