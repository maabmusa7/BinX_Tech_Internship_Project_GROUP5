using Backend.Models;

namespace Backend.Services
{
    public static class CefrCalculator
    {
        private static readonly string[] Bands =
        {
            "A1", "A1 High", "A2", "A2 High",
            "B1", "B1 High", "B2", "B2 High",
            "C1", "C1 High", "C2"
        };

        public static (LevelEnum level, string cefr) FromQuizPercentage(double percentage)
        {
            string band = percentage switch
            {
                <= 30 => "A1",
                <= 40 => "A1 High",
                <= 50 => "A2",
                <= 60 => "A2 High",
                <= 70 => "B1",
                <= 78 => "B1 High",
                <= 85 => "B2",
                <= 90 => "B2 High",
                <= 95 => "C1",
                _ => "C2"
            };

            return (ToLevelEnum(band), band);
        }

        public static (LevelEnum level, string cefr) Recalibrate(string? currentCefr, double sessionAveragePerformance)
        {
            var index = Array.IndexOf(Bands, currentCefr ?? "A2");
            if (index < 0) index = 2; // افتراضي A2 لو ما كان محدد

            if (sessionAveragePerformance >= 85 && index < Bands.Length - 1)
                index += 1;
            else if (sessionAveragePerformance < 60 && index > 0)
                index -= 1;

            var newBand = Bands[index];
            return (ToLevelEnum(newBand), newBand);
        }

        private static LevelEnum ToLevelEnum(string band) => band switch
        {
            "A1" or "A1 High" or "A2" or "A2 High" => LevelEnum.Beginner,
            "B1" or "B1 High" or "B2" or "B2 High" => LevelEnum.Intermediate,
            _ => LevelEnum.Advanced
        };
    }
}