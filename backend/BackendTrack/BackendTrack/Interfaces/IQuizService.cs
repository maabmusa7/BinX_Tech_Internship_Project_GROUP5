
using BackendTrack.Dtos.QuizDtos;

namespace Backend.Services
{
    public interface IQuizService
    {
        Task<List<QuizQuestionDto>> GetQuizAsync();
        Task<ServiceResult<QuizResultDto>> SubmitQuizAsync(int userId, QuizSubmitDto dto);
    }
}