// *****************************************************************

using Pondhawk.Migrations;
using Pondhawk.Migrations.Commands;
using JetBrains.Annotations;
using Pondhawk.Watch;
using Serilog;
using Spectre.Console;
using Spectre.Console.Cli;

Log.Logger = new LoggerConfiguration()
    .UseWatch("http://localhost:11000", "PondhawkMigrations")
    .CreateLogger();


var app = new CommandApp<DefaultCommand>();
app.Configure(config =>
{

    config.SetApplicationName("Pondhawk.Migrations");
    config.SetApplicationVersion("1.0.0");

    config.AddCommand<UpCommand>("Up")
        .WithDescription("Run a DB schema migration");

});

var result = await app.RunAsync(args);

await Task.Delay(500);
await Log.CloseAndFlushAsync();

return result;


namespace Pondhawk.Migrations
{
    [UsedImplicitly]
    public class DefaultCommand : AsyncCommand
    {

        public override Task<int> ExecuteAsync(CommandContext context)
        {

            UiHelper.ShowHeader();

            AnsiConsole.MarkupLine("Available commands:");
            AnsiConsole.MarkupLine("  [green]Snapshot[/] - Create an AWS RDS Snapshot of Target RDS instance");
            AnsiConsole.MarkupLine("  [green]Up[/] - Perform a DB schema migration");
            AnsiConsole.MarkupLine("");
            AnsiConsole.MarkupLine("Use [yellow]--help[/] with any command for more information.");

            return Task.FromResult(0);

        }

    }
}
