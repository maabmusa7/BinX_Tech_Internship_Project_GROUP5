
using Backend.Services;
using BackendTrack.Dtos.ProgressDtos;
using BackendTrack.Dtos.UserManagementDtos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace Backend.Controllers
{
    [ApiController]
    [Route("api/users")]
    [Authorize]
    public class UsersController : ApiControllerBase
    {
        private readonly IUserService _userService;

        public UsersController(IUserService userService)
        {
            _userService = userService;
        }

        private int CurrentUserId => int.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);
        private bool CanAccess(int targetUserId) => targetUserId == CurrentUserId || User.IsInRole("Admin");

        [HttpGet("me")]
        public async Task<ActionResult<AdminUserDto>> GetMe() =>
            FromResult(await _userService.GetMeAsync(CurrentUserId));

        [HttpGet("{id}/sessions")]
        public async Task<ActionResult<PagedResultDto<SessionHistoryItemDto>>> GetSessionHistory(
            int id, [FromQuery] int page = 1, [FromQuery] int pageSize = 10)
        {
            if (!CanAccess(id))
                return Forbid();

            return FromResult(await _userService.GetSessionHistoryAsync(id, page, pageSize));
        }

        [HttpGet("{id}/progress")]
        public async Task<ActionResult<ProgressDto>> GetProgress(int id)
        {
            if (!CanAccess(id))
                return Forbid();

            return FromResult(await _userService.GetProgressAsync(id));
        }

        [HttpPatch("{id}")]
        public async Task<IActionResult> UpdateProfile(int id, UpdateProfileDto dto)
        {
            if (id != CurrentUserId)
                return Forbid();

            return FromResult(await _userService.UpdateProfileAsync(id, dto));
        }

        [HttpPost("{id}/change-password")]
        public async Task<IActionResult> ChangePassword(int id, ChangePasswordDto dto)
        {
            if (id != CurrentUserId)
                return Forbid();

            return FromResult(await _userService.ChangePasswordAsync(id, dto));
        }
    }
}