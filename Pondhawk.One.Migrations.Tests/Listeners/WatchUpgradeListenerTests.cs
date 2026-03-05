using Pondhawk.Migrations.Listeners;
using Shouldly;

namespace Pondhawk.Migrations.Tests.Listeners;

public class WatchUpgradeListenerTests
{

    private static WatchUpgradeListener CreateListener(bool showProgress = false) => new()
    {
        ShowProgress = showProgress,
        ProgressWriter = _ => { }
    };


    [Fact]
    public void LogInformation_should_add_to_info_messages()
    {
        var listener = CreateListener();

        listener.LogInformation("Migration {0} applied", "script-001.sql");

        listener.InfoMessages.Count.ShouldBe(1);
        listener.InfoMessages[0].ShouldBe("Migration script-001.sql applied");
    }

    [Fact]
    public void LogWarning_should_add_to_status_messages_and_increment_count()
    {
        var listener = CreateListener();

        listener.LogWarning("Table {0} missing", "Users");

        listener.StatusMessages.Count.ShouldBe(1);
        listener.StatusMessages[0].ShouldBe("Table Users missing");
        listener.WarningsCount.ShouldBe(1);
    }

    [Fact]
    public void LogError_should_add_to_status_messages_and_increment_count()
    {
        var listener = CreateListener();

        listener.LogError("Failed: {0}", "bad sql");

        listener.StatusMessages.Count.ShouldBe(1);
        listener.StatusMessages[0].ShouldBe("Failed: bad sql");
        listener.ErrorsCount.ShouldBe(1);
    }

    [Fact]
    public void LogError_with_exception_should_increment_error_count()
    {
        var listener = CreateListener();
        var ex = new InvalidOperationException("boom");

        listener.LogError(ex, "Script failed: {0}", "script-002.sql");

        listener.ErrorsCount.ShouldBe(1);
    }

    [Fact]
    public void LogInformation_should_call_progress_writer_when_show_progress_is_true()
    {
        var written = new List<string>();
        var listener = new WatchUpgradeListener
        {
            ShowProgress = true,
            ProgressWriter = m => written.Add(m)
        };

        listener.LogInformation("Step {0}", 1);

        written.Count.ShouldBe(1);
        written[0].ShouldBe("Step 1");
    }

    [Fact]
    public void LogInformation_should_not_call_progress_writer_when_show_progress_is_false()
    {
        var written = new List<string>();
        var listener = new WatchUpgradeListener
        {
            ShowProgress = false,
            ProgressWriter = m => written.Add(m)
        };

        listener.LogInformation("Step {0}", 1);

        written.ShouldBeEmpty();
    }

    [Fact]
    public void Multiple_errors_should_accumulate_count()
    {
        var listener = CreateListener();

        listener.LogError("Error {0}", 1);
        listener.LogError("Error {0}", 2);
        listener.LogWarning("Warning {0}", 1);

        listener.ErrorsCount.ShouldBe(2);
        listener.WarningsCount.ShouldBe(1);
        listener.StatusMessages.Count.ShouldBe(3);
    }

    [Fact]
    public void LogTrace_and_LogDebug_should_not_affect_counts_or_messages()
    {
        var listener = CreateListener();

        listener.LogTrace("trace {0}", "msg");
        listener.LogDebug("debug {0}", "msg");

        listener.InfoMessages.ShouldBeEmpty();
        listener.StatusMessages.ShouldBeEmpty();
        listener.WarningsCount.ShouldBe(0);
        listener.ErrorsCount.ShouldBe(0);
    }

}
