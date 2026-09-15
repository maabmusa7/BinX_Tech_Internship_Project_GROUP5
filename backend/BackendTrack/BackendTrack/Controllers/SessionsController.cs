using Backend.Services;
using BackendTrack.Dtos.SessionDtos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.RateLimiting;
using System.Security.Claims;

namespace Backend.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Authorize]
    public class SessionsController : ApiControllerBase
    {
        private readonly ISessionService _sessionService;

        public SessionsController(ISessionService sessionService)
        {
            _sessionService = sessionService;
        }

        private int CurrentUserId => int.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);

        [HttpPost]
        [EnableRateLimiting("ai-heavy")]
        public async Task<ActionResult<SessionDto>> StartSession(StartSessionDto dto) =>
            FromResult(await _sessionService.StartSessionAsync(CurrentUserId, dto));

        [HttpGet("{id}")]
        public async Task<ActionResult<SessionDetailDto>> GetSession(int id) =>
            FromResult(await _sessionService.GetSessionAsync(CurrentUserId, id));

        [HttpPost("{id}/turns")]
        [EnableRateLimiting("ai-heavy")]
        public async Task<ActionResult<TurnResultDto>> SendTurn(int id, SendTurnDto dto) =>
            FromResult(await _sessionService.SendTurnAsync(CurrentUserId, id, dto));

        [HttpPatch("{id}/end")]
        public async Task<ActionResult<SessionSummaryDto>> EndSession(int id) =>
            FromResult(await _sessionService.EndSessionAsync(CurrentUserId, id));
    }
}