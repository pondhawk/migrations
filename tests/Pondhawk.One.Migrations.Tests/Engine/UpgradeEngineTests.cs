using DbUp.Builder;
using DbUp.Engine;
using DbUp.Engine.Output;
using DbUp.Engine.Transactions;
using DbUp.Support;
using NSubstitute;
using Shouldly;

namespace Pondhawk.Migrations.Tests.Engine;

public class UpgradeEngineTests
{

    private readonly IConnectionManager _connectionManager;
    private readonly IJournal _journal;
    private readonly IScriptExecutor _scriptExecutor;
    private readonly IScriptProvider _scriptProvider;
    private readonly UpgradeConfiguration _config;

    public UpgradeEngineTests()
    {
        _connectionManager = Substitute.For<IConnectionManager>();
        _journal = Substitute.For<IJournal>();
        _scriptExecutor = Substitute.For<IScriptExecutor>();
        _scriptProvider = Substitute.For<IScriptProvider>();

        _connectionManager.OperationStarting(Arg.Any<IUpgradeLog>(), Arg.Any<List<SqlScript>>())
            .Returns(Substitute.For<IDisposable>());

        _journal.GetExecutedScripts().Returns([]);

        _config = new UpgradeConfiguration
        {
            ConnectionManager = _connectionManager,
            Journal = _journal,
            ScriptExecutor = _scriptExecutor,
        };
        _config.ScriptProviders.Add(_scriptProvider);
    }

    private UpgradeEngine CreateEngine() => new(_config);


    [Fact]
    public void Should_sort_scripts_by_run_group_order_then_name()
    {
        var scripts = new[]
        {
            new SqlScript("script-002.sql", "SELECT 1", new SqlScriptOptions { RunGroupOrder = 1000, ScriptType = ScriptType.RunOnce }),
            new SqlScript("post-run.sql", "SELECT 1", new SqlScriptOptions { RunGroupOrder = 10000, ScriptType = ScriptType.RunAlways }),
            new SqlScript("script-001.sql", "SELECT 1", new SqlScriptOptions { RunGroupOrder = 1000, ScriptType = ScriptType.RunOnce }),
            new SqlScript("pre-run.sql", "SELECT 1", new SqlScriptOptions { RunGroupOrder = 100, ScriptType = ScriptType.RunAlways }),
        };

        _scriptProvider.GetScripts(Arg.Any<IConnectionManager>()).Returns(scripts);

        var engine = CreateEngine();
        var result = engine.GetScriptsToExecute();

        result.Count.ShouldBe(4);
        result[0].Name.ShouldBe("pre-run.sql");
        result[1].Name.ShouldBe("script-001.sql");
        result[2].Name.ShouldBe("script-002.sql");
        result[3].Name.ShouldBe("post-run.sql");
    }

    [Fact]
    public void Should_exclude_already_executed_run_once_scripts()
    {
        var scripts = new[]
        {
            new SqlScript("script-001.sql", "SELECT 1", new SqlScriptOptions { RunGroupOrder = 1000 }),
            new SqlScript("script-002.sql", "SELECT 1", new SqlScriptOptions { RunGroupOrder = 1000 }),
        };

        _scriptProvider.GetScripts(Arg.Any<IConnectionManager>()).Returns(scripts);
        _journal.GetExecutedScripts().Returns(new[] { "script-001.sql" });

        var engine = CreateEngine();
        var result = engine.GetScriptsToExecute();

        result.Count.ShouldBe(1);
        result[0].Name.ShouldBe("script-002.sql");
    }

    [Fact]
    public void Should_always_include_run_always_scripts()
    {
        var scripts = new[]
        {
            new SqlScript("pre-run.sql", "SELECT 1", new SqlScriptOptions { RunGroupOrder = 100, ScriptType = ScriptType.RunAlways }),
            new SqlScript("script-001.sql", "SELECT 1", new SqlScriptOptions { RunGroupOrder = 1000 }),
        };

        _scriptProvider.GetScripts(Arg.Any<IConnectionManager>()).Returns(scripts);
        _journal.GetExecutedScripts().Returns(new[] { "pre-run.sql", "script-001.sql" });

        var engine = CreateEngine();
        var result = engine.GetScriptsToExecute();

        result.Count.ShouldBe(1);
        result[0].Name.ShouldBe("pre-run.sql");
    }

    [Fact]
    public void IsUpgradeRequired_should_return_true_when_scripts_pending()
    {
        var scripts = new[]
        {
            new SqlScript("script-001.sql", "SELECT 1", new SqlScriptOptions { RunGroupOrder = 1000 }),
        };

        _scriptProvider.GetScripts(Arg.Any<IConnectionManager>()).Returns(scripts);

        var engine = CreateEngine();
        engine.IsUpgradeRequired().ShouldBeTrue();
    }

    [Fact]
    public void IsUpgradeRequired_should_return_false_when_all_executed()
    {
        var scripts = new[]
        {
            new SqlScript("script-001.sql", "SELECT 1", new SqlScriptOptions { RunGroupOrder = 1000 }),
        };

        _scriptProvider.GetScripts(Arg.Any<IConnectionManager>()).Returns(scripts);
        _journal.GetExecutedScripts().Returns(new[] { "script-001.sql" });

        var engine = CreateEngine();
        engine.IsUpgradeRequired().ShouldBeFalse();
    }

    [Fact]
    public void PerformUpgrade_should_execute_scripts_in_order()
    {
        var executionOrder = new List<string>();

        var scripts = new[]
        {
            new SqlScript("pre-run.sql", "PRE", new SqlScriptOptions { RunGroupOrder = 100, ScriptType = ScriptType.RunAlways }),
            new SqlScript("script-001.sql", "MAIN", new SqlScriptOptions { RunGroupOrder = 1000 }),
            new SqlScript("post-run.sql", "POST", new SqlScriptOptions { RunGroupOrder = 10000, ScriptType = ScriptType.RunAlways }),
        };

        _scriptProvider.GetScripts(Arg.Any<IConnectionManager>()).Returns(scripts);
        _scriptExecutor.When(x => x.Execute(Arg.Any<SqlScript>(), Arg.Any<IDictionary<string, string>>()))
            .Do(ci => executionOrder.Add(ci.Arg<SqlScript>().Name));

        var engine = CreateEngine();
        var result = engine.PerformUpgrade();

        result.Successful.ShouldBeTrue();
        executionOrder.Count.ShouldBe(3);
        executionOrder[0].ShouldBe("pre-run.sql");
        executionOrder[1].ShouldBe("script-001.sql");
        executionOrder[2].ShouldBe("post-run.sql");
    }

    [Fact]
    public void PerformUpgrade_should_return_failure_when_script_throws()
    {
        var scripts = new[]
        {
            new SqlScript("script-001.sql", "SELECT 1", new SqlScriptOptions { RunGroupOrder = 1000 }),
            new SqlScript("script-002.sql", "BAD SQL", new SqlScriptOptions { RunGroupOrder = 1000 }),
        };

        _scriptProvider.GetScripts(Arg.Any<IConnectionManager>()).Returns(scripts);
        _scriptExecutor.When(x => x.Execute(
                Arg.Is<SqlScript>(s => s.Name == "script-002.sql"),
                Arg.Any<IDictionary<string, string>>()))
            .Do(_ => throw new Exception("Syntax error"));

        var engine = CreateEngine();
        var result = engine.PerformUpgrade();

        result.Successful.ShouldBeFalse();
        result.Error.ShouldNotBeNull();
        result.Error!.Message.ShouldBe("Syntax error");
        result.ErrorScript.ShouldNotBeNull();
        result.ErrorScript!.Name.ShouldBe("script-002.sql");
        result.Scripts.Count().ShouldBe(1);
    }

    [Fact]
    public void PerformUpgrade_should_call_verify_schema()
    {
        var scripts = new[]
        {
            new SqlScript("script-001.sql", "SELECT 1", new SqlScriptOptions { RunGroupOrder = 1000 }),
        };

        _scriptProvider.GetScripts(Arg.Any<IConnectionManager>()).Returns(scripts);

        var engine = CreateEngine();
        engine.PerformUpgrade();

        _scriptExecutor.Received(1).VerifySchema();
    }

    [Fact]
    public void PerformUpgrade_should_return_success_with_no_scripts()
    {
        _scriptProvider.GetScripts(Arg.Any<IConnectionManager>()).Returns([]);

        var engine = CreateEngine();
        var result = engine.PerformUpgrade();

        result.Successful.ShouldBeTrue();
        result.Scripts.ShouldBeEmpty();
        _scriptExecutor.DidNotReceive().VerifySchema();
    }

    [Fact]
    public void Should_use_case_insensitive_comparer_when_configured()
    {
        _config.ScriptNameComparer = new ScriptNameComparer(StringComparer.OrdinalIgnoreCase);

        var scripts = new[]
        {
            new SqlScript("Script-001.sql", "SELECT 1", new SqlScriptOptions { RunGroupOrder = 1000 }),
        };

        _scriptProvider.GetScripts(Arg.Any<IConnectionManager>()).Returns(scripts);
        _journal.GetExecutedScripts().Returns(new[] { "script-001.sql" });

        var engine = CreateEngine();
        var result = engine.GetScriptsToExecute();

        result.ShouldBeEmpty();
    }

}
