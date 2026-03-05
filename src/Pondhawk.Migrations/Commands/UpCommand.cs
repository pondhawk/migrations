using System.ComponentModel;
using Pondhawk.Migrations.Modules;
using Pondhawk.Migrations.Modules.MySql;
using JetBrains.Annotations;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Pondhawk.Rules;
using Pondhawk.Rules.Validators;
using Serilog;
using Spectre.Console.Cli;

namespace Pondhawk.Migrations.Commands;


[UsedImplicitly]
public class UpCommand : AsyncCommand<UpCommand.UpSettings>
{

    private static readonly ILogger Logger = Log.ForContext<UpCommand>();

    private static class ExitCodes
    {
        public const int Success = 0;
        public const int ConfigurationError = 100;
        public const int DatabaseError = 200;
        public const int UpgradeError = 300;
    }

    [UsedImplicitly]
    public class UpSettings: CommandSettings
    {

        [CommandOption("-P|--provider")]
        [Description("The name of the Provider (MySql, Postgres, Sqlist, SqlServer, etc.)")]
        public string Provider { get; set; } = string.Empty;

        [CommandOption("-C|--connection")]
        [Description("The Db connection string")]
        public string ConnectionString { get; set; } = string.Empty;

        [CommandOption("-S|--scripts-path")]
        [Description("The scripts path")]
        public string ScriptsPath { get; set; } = string.Empty;

        public string VersionSchema { get; set; } = string.Empty;
        public string VersionTable { get; set; } =  string.Empty;

        public string PreRunScriptPattern { get; set; }  = string.Empty;
        public string ScriptPattern { get; set; }  = string.Empty;
        public string PostRunScriptPattern { get; set; }  = string.Empty;


        [CommandOption("-Q|--quiet")]
        [Description("No terminal output")]
        public bool Quiet { get; set; } = false;


        [CommandOption("-T|--test")]
        [Description("Just show discovered Options and pre run status")]
        public bool Testing { get; set; } = false;


    }


    public override async Task<int> ExecuteAsync(CommandContext context, UpSettings settings)
    {

        var logger = Logger;

        UiHelper.ShowHeader();



         // *************************************************
        logger.Debug("Attempting to load defaults from pondhawk-migrations.yml");

        var defaultsPath = Path.Combine(Environment.CurrentDirectory, "pondhawk-migrations.yml");
        logger.Debug("Attempting to load defaults file from {DefaultsPath}", defaultsPath);
        var cb = new ConfigurationBuilder()
            .AddYamlFile(defaultsPath, optional: true);



        // *************************************************
        logger.Debug("Attempting to apply defaults to Up settings");
        var cm = cb.Build();
        var config = cm.Get<UpConfiguration>();

        if( config is not null )
        {

            if( string.IsNullOrWhiteSpace(settings.Provider) )
                settings.Provider = config.Provider;

            if( string.IsNullOrWhiteSpace(settings.ConnectionString) )
                settings.ConnectionString = config.ConnectionString;

            if( string.IsNullOrWhiteSpace(settings.ScriptsPath) )
                settings.ScriptsPath = config.ScriptsPath;

            if( string.IsNullOrWhiteSpace(settings.VersionSchema) )
                settings.VersionSchema = config.VersionSchema;

            if( string.IsNullOrWhiteSpace(settings.VersionTable) )
                settings.VersionTable = config.VersionTable;

            if( string.IsNullOrWhiteSpace(settings.PreRunScriptPattern) )
                settings.PreRunScriptPattern = config.PreRunScriptPattern;

            if( string.IsNullOrWhiteSpace(settings.ScriptPattern) )
                settings.ScriptPattern = config.ScriptPattern;

            if( string.IsNullOrWhiteSpace(settings.PostRunScriptPattern) )
                settings.PostRunScriptPattern = config.PostRunScriptPattern;

        }

        logger.Debug("Settings: {@Settings}", settings);

        // *************************************************
        logger.Debug("Attempting to Validate Settings");
        var (valid, violations) = ValidateSettings(settings);

        if (!valid)
        {
            UiHelper.ShowEvents( "Configuration Errors", "Option", "Error", violations );
            return ExitCodes.ConfigurationError;
        }


        if( settings.Quiet )
            UiHelper.BeQuiet();

        UiHelper.ShowOptions("Up Options", settings);


        // *************************************************
        logger.Debug("Attempting to build Core Module");
        var core = new CoreModule
        {
            ScriptPath           = settings.ScriptsPath,
            PreRunScriptPattern  = settings.PreRunScriptPattern,
            ScriptPattern        = settings.ScriptPattern,
            PostRunScriptPattern = settings.PostRunScriptPattern,
            ShowProgress         = !settings.Quiet
        };

        logger.Debug("CoreModule: {@CoreModule}", core);



        // *************************************************
        logger.Debug("Attempting to load Implementation Module: {Provider}", settings.Provider);
        var impl = settings.Provider switch
        {
            "MySql" => new MySqlModule
            {
                ConnectionString = settings.ConnectionString,
                VersionSchema = settings.VersionSchema,
                VersionTable = settings.VersionTable
            },
            _ => (IImplementationModule?)null
        };

        if (impl is null)
        {

            logger.Error("Failed to load Provider implementation");
            UiHelper.ShowError("Failed to load Provider implementation");

            return ExitCodes.ConfigurationError;

        }



        // *************************************************
        logger.Debug("Attempting to register modules");
        var services = new ServiceCollection();

        core.ConfigureServices(services);
        impl.ConfigureServices(services);



        // *************************************************
        logger.Debug("Attempting to run upgrade");

        UiHelper.Start();

        using var sp = services.BuildServiceProvider();
        using var scope = sp.CreateScope();



        // *************************************************
        logger.Debug("Attempting to resolve UpgradeService");
        var service = scope.ServiceProvider.GetRequiredService<UpgradeService>();



        // *************************************************
        logger.Debug("Attempting to check database connection");
        var ok = service.Engine.TryConnect( out var messages );
        if( !ok )
        {

            logger.Debug("Failed to connect to Database: {Messages}", messages);

            UiHelper.Stop();
            UiHelper.ShowError( $"Failed to connect to Database: {messages}" );
            UiHelper.ShowCompletion("Up");

            return ExitCodes.DatabaseError;

        }


        UiHelper.ShowRule("Progress");


        // *************************************************
        logger.Debug("Attempting to check if upgrade is required");
        if( !service.Engine.IsUpgradeRequired() )
        {

            logger.Debug("No DB schema migration required");

            UiHelper.Stop();
            UiHelper.ShowProgress("No DB schema migrations required",false);
            UiHelper.ShowCompletion("Up");

            return ExitCodes.Success;

        }



        // *************************************************
        if( settings.Testing )
        {

            var couldHaveRun = service.Engine.GetScriptsToExecute();

            logger.Debug("CouldHaveRun: {@CouldHaveRun}", couldHaveRun);

            foreach( var s in couldHaveRun )
                UiHelper.ShowProgress( $"In Test Mode - Would've run: ({s.Name})", false );

            UiHelper.ShowCompletion("Up");

            return ExitCodes.Success;

        }


        UiHelper.ShowProgress("Pre-run validation completed");


        // *************************************************
        logger.Debug("Attempting to perform DB schema upgrade");
        var result = service.Engine.PerformUpgrade();

        UiHelper.Stop();

        logger.Debug("Result: {@Result}", result);

        if( !result.Successful )
        {

            logger.Error("Failed to perform DB schema upgrade");
            logger.Debug("StatusMessages: {@StatusMessages}", service.Listener.StatusMessages);

            foreach( var msg in service.Listener.StatusMessages )
                UiHelper.ShowError(msg);

            if( result.Error is not null )
                UiHelper.ShowException( result.Error, $"Upgrade Exception run script ({result.ErrorScript?.Name})" );

            UiHelper.ShowCompletion("Up");

            return ExitCodes.UpgradeError;

        }


        UiHelper.ShowCompletion("Up");
        return ExitCodes.Success;


    }

    private (bool valid, IReadOnlyList<RuleEvent> violations) ValidateSettings(UpSettings settings)
    {

        Logger.Debug("Entering ValidateSettings");


        // *************************************************
        var services = new ServiceCollection();
        services.AddRules(GetType().Assembly);
        services.UseRules();

        using var sp = services.BuildServiceProvider();


        // *************************************************
        var rules = sp.GetRequiredService<IRuleSet>();

        var valid = rules.TryValidate(settings, out var violations);

        return (valid, violations);

    }


}

public class UpConfiguration
{

    public string Provider { get; init; } = string.Empty;
    public string ConnectionString { get; init; } = string.Empty;
    public string ScriptsPath { get; init; } = "./db-scripts";

    public string VersionSchema { get; init; } = string.Empty;
    public string VersionTable { get; init; } = "SchemaVersions";

    public string PreRunScriptPattern { get; init; }  = "pre-run-script.sql";
    public string ScriptPattern { get; init; }  = "script-*.sql";
    public string PostRunScriptPattern { get; init; }  = "post-run-script.sql";


}


[UsedImplicitly]
public sealed class SettingsValidationBuilder : ValidationBuilder<UpCommand.UpSettings>
{

    public SettingsValidationBuilder()
    {

        Assert(s => s.Provider).Required();
        Assert(s => s.ConnectionString).Required();
        Assert(s => s.ScriptsPath).Required();
        Assert(s => s.VersionTable).Required();
        Assert(s => s.PreRunScriptPattern).Required();
        Assert(s => s.ScriptPattern).Required().Contains("*");
        Assert(s => s.PostRunScriptPattern).Required();

    }



}
