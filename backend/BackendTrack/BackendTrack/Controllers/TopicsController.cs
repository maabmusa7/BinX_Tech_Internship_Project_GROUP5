using Backend.Models;
using Backend.Services;
using BackendTrack.Dtos.TopicDtos;
using BackendTrack.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace Backend.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Authorize]
    public class TopicsController : ApiControllerBase
    {
        private readonly ITopicService _topicService;

        public TopicsController(ITopicService topicService)
        {
            _topicService = topicService;
        }

        // UC-U4 + بحث وفلترة حسب الفئة (شاشة "Choose Your Topic")
        [HttpGet]
        public async Task<ActionResult<List<TopicDto>>> GetTopics(
            [FromQuery] TopicCategory? category, [FromQuery] string? search)
        {
            var userId = int.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);
            return Ok(await _topicService.GetActiveTopicsForUserAsync(userId, category, search));
        }
    }
}