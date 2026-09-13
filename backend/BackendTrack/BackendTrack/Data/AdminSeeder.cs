using Backend.Models;
using Microsoft.AspNetCore.Identity;

namespace Backend.Data
{
    public static class AdminSeeder
    {
        public static async Task SeedAdminAsync(IServiceProvider services, IConfiguration config)
        {
            var userManager = services.GetRequiredService<UserManager<ApplicationUser>>();

            var adminSection = config.GetSection("AdminSeed");
            var email = adminSection["Email"];
            var password = adminSection["Password"];
            var fullName = adminSection["FullName"] ?? "Admin";

            if (string.IsNullOrWhiteSpace(email) || string.IsNullOrWhiteSpace(password))
                return; 

            var existing = await userManager.FindByEmailAsync(email);
            if (existing != null)
                return; 

            var admin = new ApplicationUser
            {
                UserName = email,
                Email = email,
                FullName = fullName,
                EmailConfirmed = true
            };

            var result = await userManager.CreateAsync(admin, password);
            if (result.Succeeded)
                await userManager.AddToRoleAsync(admin, "Admin");
        }
    }
}