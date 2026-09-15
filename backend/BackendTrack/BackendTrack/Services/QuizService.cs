using Backend.Data;
using Backend.Models;
using BackendTrack.Dtos.QuizDtos;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;

namespace Backend.Services
{
    public class QuizService : IQuizService
    {
        private readonly AppDbContext _db;
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly IConfiguration _config;

        public QuizService(AppDbContext db, UserManager<ApplicationUser> userManager, IConfiguration config)
        {
            _db = db;
            _userManager = userManager;
            _config = config;
        }

        public async Task<List<QuizQuestionDto>> GetQuizAsync()
        {
            return await _db.QuizQuestions
                .Include(q => q.Options)
                .Select(q => new QuizQuestionDto
                {
                    Id = q.Id,
                    Text = q.Text,
                    Options = q.Options.Select(o => new QuizOptionDto { Id = o.Id, Text = o.Text }).ToList()
                })
                .ToListAsync();
        }

        public async Task<ServiceResult<QuizResultDto>> SubmitQuizAsync(int userId, QuizSubmitDto dto)
        {
            var user = await _userManager.FindByIdAsync(userId.ToString());
            if (user == null)
                return ServiceResult<QuizResultDto>.Fail(ServiceError.Unauthorized, "مستخدم غير موجود.");

            var questionIds = dto.Answers.Select(a => a.QuestionId).ToList();
            var validOptions = await _db.QuizOptions
                .Where(o => questionIds.Contains(o.QuizQuestionId))
                .ToListAsync();

            int totalScore = 0;
            foreach (var answer in dto.Answers)
            {
                var option = validOptions.FirstOrDefault(o =>
                    o.Id == answer.SelectedOptionId && o.QuizQuestionId == answer.QuestionId);

                if (option != null)
                    totalScore += option.Points;
            }

            var thresholds = _config.GetSection("QuizLevelThresholds");
            var intermediateMin = thresholds.GetValue<int>("IntermediateMin");
            var advancedMin = thresholds.GetValue<int>("AdvancedMin");

            var level = totalScore >= advancedMin ? LevelEnum.Advanced
                      : totalScore >= intermediateMin ? LevelEnum.Intermediate
                      : LevelEnum.Beginner;

            user.Level = level;
            await _userManager.UpdateAsync(user);

            return ServiceResult<QuizResultDto>.Ok(new QuizResultDto { TotalScore = totalScore, Level = level.ToString() });
        }
    }
}