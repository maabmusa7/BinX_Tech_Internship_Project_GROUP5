using Backend.Services;
using BackendTrack.Dtos.TopicDtos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Backend.Controllers
{
    [ApiController]
    [Route("api/admin/[controller]")]
    [Authorize(Roles = "Admin")]
    public class TopicsAdminController : ApiControllerBase
    {
        private readonly ITopicService _topicService;

        public TopicsAdminController(ITopicService topicService)
        {
            _topicService = topicService;
        }

        [HttpGet]
        public async Task<ActionResult<List<TopicDto>>> GetAll() =>
            Ok(await _topicService.GetAllTopicsAsync());

        [HttpPost]
        public async Task<ActionResult<TopicDto>> Create(CreateTopicDto dto) =>
            Ok(await _topicService.CreateAsync(dto));

        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, UpdateTopicDto dto) =>
            FromResult(await _topicService.UpdateAsync(id, dto));

        [HttpDelete("{id}")]
        public async Task<IActionResult> Deactivate(int id) =>
            FromResult(await _topicService.DeactivateAsync(id));
    }
}