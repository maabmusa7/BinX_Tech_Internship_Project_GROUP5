namespace BackendTrack.Dtos.UserManagementDtos
{
    public class AdminUserDto
    {
        public int Id { get; set; }
        public string Email { get; set; } = string.Empty;
        public string FullName { get; set; } = string.Empty;
        public string Role { get; set; } = string.Empty;
        public bool IsActive { get; set; }
        public string? Level { get; set; }
    }
}
