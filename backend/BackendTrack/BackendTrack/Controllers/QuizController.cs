using Backend.Services;
using BackendTrack.Dtos.QuizDtos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace Backend.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Authorize]
    public class QuizController : ApiControllerBase
    {
        private readonly IQuizService _quizService;

        public QuizController(IQuizService quizService)
        {
            _quizService = quizService;
        }

        [HttpGet]
        public async Task<ActionResult<List<QuizQuestionDto>>> GetQuiz() =>
            Ok(await _quizService.GetQuizAsync());

        [HttpPost("submit")]
        public async Task<ActionResult<QuizResultDto>> SubmitQuiz(QuizSubmitDto dto)
        {
            var userId = int.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);
            return FromResult(await _quizService.SubmitQuizAsync(userId, dto));
        }
    }
}