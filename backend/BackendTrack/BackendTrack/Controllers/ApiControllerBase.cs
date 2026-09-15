using Microsoft.AspNetCore.Mvc;

namespace Backend.Controllers
{
    public abstract class ApiControllerBase : ControllerBase
    {
        protected ActionResult<T> FromResult<T>(Services.ServiceResult<T> result)
        {
            if (result.Success)
                return Ok(result.Data);

            return result.Error switch
            {
                Services.ServiceError.NotFound => NotFound(result.Message),
                Services.ServiceError.Conflict => Conflict(result.Message),
                Services.ServiceError.Unauthorized => Unauthorized(result.Message),
                Services.ServiceError.Forbidden => Forbid(),
                Services.ServiceError.BadRequest => BadRequest((object?)result.Errors ?? result.Message),
                _ => BadRequest(result.Message)
            };
        }

        protected IActionResult FromResult(Services.ServiceResult result)
        {
            if (result.Success)
                return NoContent();

            return result.Error switch
            {
                Services.ServiceError.NotFound => NotFound(result.Message),
                Services.ServiceError.Conflict => Conflict(result.Message),
                Services.ServiceError.Unauthorized => Unauthorized(result.Message),
                Services.ServiceError.Forbidden => Forbid(),
                Services.ServiceError.BadRequest => BadRequest((object?)result.Errors ?? result.Message),
                _ => BadRequest(result.Message)
            };
        }
    }
}