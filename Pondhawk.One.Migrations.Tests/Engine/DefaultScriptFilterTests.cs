using DbUp.Engine;
using DbUp.Engine.Filters;
using DbUp.Support;
using Shouldly;

namespace Pondhawk.Migrations.Tests.Engine;

public class DefaultScriptFilterTests
{

    private readonly DefaultScriptFilter _filter = new();
    private readonly ScriptNameComparer _comparer = new(StringComparer.Ordinal);

    private static SqlScript RunOnceScript(string name) =>
        new(name, "SELECT 1", new SqlScriptOptions { ScriptType = ScriptType.RunOnce });

    private static SqlScript RunAlwaysScript(string name) =>
        new(name, "SELECT 1", new SqlScriptOptions { ScriptType = ScriptType.RunAlways });


    [Fact]
    public void Should_exclude_already_executed_run_once_scripts()
    {
        var scripts = new[] { RunOnceScript("script-001.sql"), RunOnceScript("script-002.sql") };
        var executed = new HashSet<string> { "script-001.sql" };

        var result = _filter.Filter(scripts, executed, _comparer).ToList();

        result.Count.ShouldBe(1);
        result[0].Name.ShouldBe("script-002.sql");
    }

    [Fact]
    public void Should_include_run_always_scripts_even_if_already_executed()
    {
        var scripts = new[] { RunAlwaysScript("pre-run.sql") };
        var executed = new HashSet<string> { "pre-run.sql" };

        var result = _filter.Filter(scripts, executed, _comparer).ToList();

        result.Count.ShouldBe(1);
        result[0].Name.ShouldBe("pre-run.sql");
    }

    [Fact]
    public void Should_return_all_scripts_when_none_executed()
    {
        var scripts = new[] { RunOnceScript("script-001.sql"), RunOnceScript("script-002.sql") };
        var executed = new HashSet<string>();

        var result = _filter.Filter(scripts, executed, _comparer).ToList();

        result.Count.ShouldBe(2);
    }

    [Fact]
    public void Should_return_empty_when_all_run_once_scripts_executed()
    {
        var scripts = new[] { RunOnceScript("script-001.sql") };
        var executed = new HashSet<string> { "script-001.sql" };

        var result = _filter.Filter(scripts, executed, _comparer).ToList();

        result.ShouldBeEmpty();
    }

    [Fact]
    public void Should_handle_mixed_script_types()
    {
        var scripts = new[]
        {
            RunAlwaysScript("pre-run.sql"),
            RunOnceScript("script-001.sql"),
            RunOnceScript("script-002.sql"),
            RunAlwaysScript("post-run.sql")
        };
        var executed = new HashSet<string> { "script-001.sql" };

        var result = _filter.Filter(scripts, executed, _comparer).ToList();

        result.Count.ShouldBe(3);
        result.ShouldContain(s => s.Name == "pre-run.sql");
        result.ShouldContain(s => s.Name == "script-002.sql");
        result.ShouldContain(s => s.Name == "post-run.sql");
    }

    [Fact]
    public void Should_handle_empty_script_list()
    {
        var scripts = Array.Empty<SqlScript>();
        var executed = new HashSet<string> { "script-001.sql" };

        var result = _filter.Filter(scripts, executed, _comparer).ToList();

        result.ShouldBeEmpty();
    }

}
