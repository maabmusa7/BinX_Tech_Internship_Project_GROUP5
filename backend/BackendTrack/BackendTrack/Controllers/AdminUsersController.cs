using Backend.Services;
using BackendTrack.Dtos.ProgressDtos;
using BackendTrack.Dtos.UserManagementDtos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Backend.Controllers
{
    [ApiController]
    [Route("api/admin/users")]
    [Authorize(Roles = "Admin")]
    public class AdminUsersController : ApiControllerBase
    {
        private readonly IAdminUserService _adminUserService;

        public AdminUsersController(IAdminUserService adminUserService)
        {
            _adminUserService = adminUserService;
        }

        [HttpGet]
        public async Task<ActionResult<PagedResultDto<AdminUserDto>>> GetUsers(
            [FromQuery] int page = 1, [FromQuery] int pageSize = 20) =>
            Ok(await _adminUserService.GetUsersAsync(page, pageSize));

        [HttpPatch("{id}/status")]
        public async Task<IActionResult> UpdateStatus(int id, UpdateUserStatusDto dto) =>
            FromResult(await _adminUserService.UpdateStatusAsync(id, dto));
    }
}