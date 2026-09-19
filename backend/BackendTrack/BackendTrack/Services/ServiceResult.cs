namespace Backend.Services
{
    public enum ServiceError
    {
        None,
        NotFound,
        Conflict,
        Unauthorized,
        Forbidden,
        BadRequest
    }

    public class ServiceResult<T>
    {
        public bool Success => Error == ServiceError.None;
        public ServiceError Error { get; private set; }
        public string? Message { get; private set; }
        public List<string>? Errors { get; private set; }
        public T? Data { get; private set; }

        public static ServiceResult<T> Ok(T data) => new() { Data = data, Error = ServiceError.None };

        public static ServiceResult<T> Fail(ServiceError error, string message) =>
            new() { Error = error, Message = message };

        public static ServiceResult<T> Fail(ServiceError error, List<string> errors) =>
            new() { Error = error, Errors = errors, Message = errors.FirstOrDefault() };
    }

    public class ServiceResult
    {
        public bool Success => Error == ServiceError.None;
        public ServiceError Error { get; private set; }
        public string? Message { get; private set; }
        public List<string>? Errors { get; private set; }

        public static ServiceResult Ok() => new() { Error = ServiceError.None };

        public static ServiceResult Fail(ServiceError error, string message) =>
            new() { Error = error, Message = message };

        public static ServiceResult Fail(ServiceError error, List<string> errors) =>
            new() { Error = error, Errors = errors, Message = errors.FirstOrDefault() };
    }
}