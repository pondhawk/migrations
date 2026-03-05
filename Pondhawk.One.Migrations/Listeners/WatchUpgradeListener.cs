

// ReSharper disable MemberCanBePrivate.Global
// ReSharper disable CollectionNeverQueried.Global
// ReSharper disable PropertyCanBeMadeInitOnly.Global

using DbUp.Engine.Output;
using Serilog;

namespace Pondhawk.Migrations.Listeners;

public class WatchUpgradeListener: IUpgradeLog
{

    public bool ShowProgress { get; set; } = true;
    public Action<string> ProgressWriter { get; set; } = Console.WriteLine;

    public int WarningsCount { get; private set; }
    public int ErrorsCount { get; private set;}

    public List<string> InfoMessages { get; } = [];
    public List<string> StatusMessages { get; } = [];

    private static readonly ILogger Logger = Log.ForContext("SourceContext", "Pondhawk.Migration");

    public void LogTrace(string format, params object[] args)
    {
        Logger.Verbose(string.Format(format, args));
    }

    public void LogDebug(string format, params object[] args)
    {
        Logger.Debug(string.Format(format, args));
    }

    public void LogInformation(string format, params object[] args)
    {

        var msg = string.Format(format, args);

        Logger.Information(msg);
        InfoMessages.Add(msg);

        if( ShowProgress )
            ProgressWriter(msg);

    }

    public void LogWarning(string format, params object[] args)
    {

        var msg = string.Format(format, args);

        Logger.Warning(msg);

        StatusMessages.Add(msg);
        WarningsCount++;

    }

    public void LogError(string format, params object[] args)
    {

        var msg = string.Format(format, args);

        Logger.Error(msg);

        StatusMessages.Add(msg);
        ErrorsCount++;
    }

    public void LogError( Exception ex, string format, params object[] args )
    {

        if( Logger.IsEnabled(Serilog.Events.LogEventLevel.Error) )
        {
            var msg = string.Format(format, args);
            Logger.Error( ex, msg );
        }

        ErrorsCount++;

    }

}
