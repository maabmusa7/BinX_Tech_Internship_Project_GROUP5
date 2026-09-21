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

        public QuizService(AppDbContext db, UserManager<ApplicationUser> userManager)
        {
            _db = db;
            _userManager = userManager;
        }

        public async Task<List<QuizQuestionDto>> GetQuizAsync()
        {
            return await _db.QuizQuestions
                .Include(q => q.Options)
                .Select(q => new QuizQuestionDto
                {
                    Id = q.Id,
                    Text = q.Text,
                    Category = q.Category,
                    Difficulty = q.Difficulty.ToString(),
                    Options = q.Options.Select(o => new QuizOptionDto { Id = o.Id, Text = o.Text }).ToList()
                })
                .ToListAsync();
        }

        public async Task<ServiceResult<QuizResultDto>> SubmitQuizAsync(int userId, QuizSubmitDto dto)
        {
            var user = await _userManager.FindByIdAsync(userId.ToString());
            if (user == null)
                return ServiceResult<QuizResultDto>.Fail(ServiceError.Unauthorized, "مستخدم غير موجود.");

            var totalQuestions = await _db.QuizQuestions.CountAsync();

            var questionIds = dto.Answers.Select(a => a.QuestionId).ToList();
            var validOptions = await _db.QuizOptions
                .Where(o => questionIds.Contains(o.QuizQuestionId))
                .ToListAsync();

            int correctCount = 0;
            // "صح" = اختارت أعلى خيار نقاط لهاد السؤال (أبسط تعريف بدون علم مسبق بإجابة "صحيحة" واحدة)
            var maxPointsPerQuestion = validOptions
                .GroupBy(o => o.QuizQuestionId)
                .ToDictionary(g => g.Key, g => g.Max(o => o.Points));

            foreach (var answer in dto.Answers)
            {
                var option = validOptions.FirstOrDefault(o =>
                    o.Id == answer.SelectedOptionId && o.QuizQuestionId == answer.QuestionId);

                if (option != null && maxPointsPerQuestion.TryGetValue(answer.QuestionId, out var maxPoints) && option.Points == maxPoints)
                    correctCount++;
            }

            var percentage = totalQuestions > 0 ? (double)correctCount / totalQuestions * 100 : 0;
            var (level, cefr) = CefrCalculator.FromQuizPercentage(percentage);

            user.Level = level;
            user.CefrLevel = cefr;
            await _userManager.UpdateAsync(user);

            return ServiceResult<QuizResultDto>.Ok(new QuizResultDto
            {
                TotalScore = (int)percentage,
                CorrectCount = correctCount,
                TotalQuestions = totalQuestions,
                Level = level.ToString(),
                CefrLevel = cefr,
                TimeTakenSeconds = dto.TimeTakenSeconds
            });
        }
    }
}