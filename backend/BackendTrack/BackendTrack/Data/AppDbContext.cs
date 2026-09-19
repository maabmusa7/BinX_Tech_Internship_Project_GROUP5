using Backend.Models;
using BackendTrack.Models;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;

namespace Backend.Data
{
    public class AppDbContext : IdentityDbContext<ApplicationUser, IdentityRole<int>, int>
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

        public DbSet<Topic> Topics { get; set; }
        public DbSet<Session> Sessions { get; set; }
        public DbSet<Turn> Turns { get; set; }
        public DbSet<QuizQuestion> QuizQuestions { get; set; }
        public DbSet<QuizOption> QuizOptions { get; set; }

        protected override void OnModelCreating(ModelBuilder builder)
        {
            base.OnModelCreating(builder);

            builder.Entity<Session>()
                .HasOne(s => s.User)
                .WithMany(u => u.Sessions)
                .HasForeignKey(s => s.UserId);

            builder.Entity<Session>()
                .HasOne(s => s.Topic)
                .WithMany(t => t.Sessions)
                .HasForeignKey(s => s.TopicId);

            builder.Entity<Turn>()
                .HasOne(t => t.Session)
                .WithMany(s => s.Turns)
                .HasForeignKey(t => t.SessionId);

            builder.Entity<QuizOption>()
                .HasOne(o => o.QuizQuestion)
                .WithMany(q => q.Options)
                .HasForeignKey(o => o.QuizQuestionId);

            builder.Entity<Session>()
                .HasIndex(s => new { s.UserId, s.StartedAt });
        }
    }
}