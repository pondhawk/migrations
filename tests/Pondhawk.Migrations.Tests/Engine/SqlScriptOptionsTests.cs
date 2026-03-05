using DbUp;
using DbUp.Engine;
using DbUp.Support;
using Shouldly;

namespace Pondhawk.Migrations.Tests.Engine;

public class SqlScriptOptionsTests
{

    [Fact]
    public void Default_script_type_should_be_run_once()
    {
        var options = new SqlScriptOptions();

        options.ScriptType.ShouldBe(ScriptType.RunOnce);
    }

    [Fact]
    public void Default_run_group_order_should_match_dbup_defaults()
    {
        var options = new SqlScriptOptions();

        options.RunGroupOrder.ShouldBe(DbUpDefaults.DefaultRunGroupOrder);
    }

    [Fact]
    public void Should_allow_setting_run_always()
    {
        var options = new SqlScriptOptions { ScriptType = ScriptType.RunAlways };

        options.ScriptType.ShouldBe(ScriptType.RunAlways);
    }

    [Fact]
    public void Should_allow_setting_custom_run_group_order()
    {
        var options = new SqlScriptOptions { RunGroupOrder = 500 };

        options.RunGroupOrder.ShouldBe(500);
    }

}
