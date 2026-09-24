using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace BackendTrack.Migrations
{
    /// <inheritdoc />
    public partial class AddTopicCategory : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<string>(
                name: "AudioUrl",
                table: "Turns",
                type: "longtext",
                nullable: true,
                oldClrType: typeof(string),
                oldType: "longtext")
                .Annotation("MySql:CharSet", "utf8mb4")
                .OldAnnotation("MySql:CharSet", "utf8mb4");

            migrationBuilder.AddColumn<double>(
                name: "FluencyScore",
                table: "Turns",
                type: "double",
                nullable: false,
                defaultValue: 0.0);

            migrationBuilder.AddColumn<string>(
                name: "NativeAudioUrl",
                table: "Turns",
                type: "longtext",
                nullable: true)
                .Annotation("MySql:CharSet", "utf8mb4");

            migrationBuilder.AddColumn<string>(
                name: "PhonemeFocusSound",
                table: "Turns",
                type: "longtext",
                nullable: true)
                .Annotation("MySql:CharSet", "utf8mb4");

            migrationBuilder.AddColumn<string>(
                name: "PhonemeTip",
                table: "Turns",
                type: "longtext",
                nullable: true)
                .Annotation("MySql:CharSet", "utf8mb4");

            migrationBuilder.AddColumn<string>(
                name: "TextInput",
                table: "Turns",
                type: "longtext",
                nullable: true)
                .Annotation("MySql:CharSet", "utf8mb4");

            migrationBuilder.AddColumn<double>(
                name: "VocabularyScore",
                table: "Turns",
                type: "double",
                nullable: false,
                defaultValue: 0.0);

            migrationBuilder.AddColumn<int>(
                name: "Category",
                table: "Topics",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "EstimatedMinutes",
                table: "Topics",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "MaxTurns",
                table: "Topics",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<string>(
                name: "SessionMission",
                table: "Topics",
                type: "longtext",
                nullable: false)
                .Annotation("MySql:CharSet", "utf8mb4");

            migrationBuilder.AddColumn<double>(
                name: "AvgFluency",
                table: "Sessions",
                type: "double",
                nullable: true);

            migrationBuilder.AddColumn<double>(
                name: "AvgPronunciation",
                table: "Sessions",
                type: "double",
                nullable: true);

            migrationBuilder.AddColumn<double>(
                name: "AvgVocabulary",
                table: "Sessions",
                type: "double",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "XpEarned",
                table: "Sessions",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<string>(
                name: "Category",
                table: "QuizQuestions",
                type: "longtext",
                nullable: false)
                .Annotation("MySql:CharSet", "utf8mb4");

            migrationBuilder.AddColumn<int>(
                name: "Difficulty",
                table: "QuizQuestions",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<string>(
                name: "CefrLevel",
                table: "AspNetUsers",
                type: "longtext",
                nullable: true)
                .Annotation("MySql:CharSet", "utf8mb4");

            migrationBuilder.AddColumn<int>(
                name: "CosmicXp",
                table: "AspNetUsers",
                type: "int",
                nullable: false,
                defaultValue: 0);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "FluencyScore",
                table: "Turns");

            migrationBuilder.DropColumn(
                name: "NativeAudioUrl",
                table: "Turns");

            migrationBuilder.DropColumn(
                name: "PhonemeFocusSound",
                table: "Turns");

            migrationBuilder.DropColumn(
                name: "PhonemeTip",
                table: "Turns");

            migrationBuilder.DropColumn(
                name: "TextInput",
                table: "Turns");

            migrationBuilder.DropColumn(
                name: "VocabularyScore",
                table: "Turns");

            migrationBuilder.DropColumn(
                name: "Category",
                table: "Topics");

            migrationBuilder.DropColumn(
                name: "EstimatedMinutes",
                table: "Topics");

            migrationBuilder.DropColumn(
                name: "MaxTurns",
                table: "Topics");

            migrationBuilder.DropColumn(
                name: "SessionMission",
                table: "Topics");

            migrationBuilder.DropColumn(
                name: "AvgFluency",
                table: "Sessions");

            migrationBuilder.DropColumn(
                name: "AvgPronunciation",
                table: "Sessions");

            migrationBuilder.DropColumn(
                name: "AvgVocabulary",
                table: "Sessions");

            migrationBuilder.DropColumn(
                name: "XpEarned",
                table: "Sessions");

            migrationBuilder.DropColumn(
                name: "Category",
                table: "QuizQuestions");

            migrationBuilder.DropColumn(
                name: "Difficulty",
                table: "QuizQuestions");

            migrationBuilder.DropColumn(
                name: "CefrLevel",
                table: "AspNetUsers");

            migrationBuilder.DropColumn(
                name: "CosmicXp",
                table: "AspNetUsers");

            migrationBuilder.UpdateData(
                table: "Turns",
                keyColumn: "AudioUrl",
                keyValue: null,
                column: "AudioUrl",
                value: "");

            migrationBuilder.AlterColumn<string>(
                name: "AudioUrl",
                table: "Turns",
                type: "longtext",
                nullable: false,
                oldClrType: typeof(string),
                oldType: "longtext",
                oldNullable: true)
                .Annotation("MySql:CharSet", "utf8mb4")
                .OldAnnotation("MySql:CharSet", "utf8mb4");
        }
    }
}
