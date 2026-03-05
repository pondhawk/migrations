using DbUp.Engine;
using Shouldly;

namespace Pondhawk.Migrations.Tests.Engine;

public class DatabaseUpgradeResultTests
{

    [Fact]
    public void Successful_result_should_have_no_error()
    {
        var scripts = new[] { new SqlScript("script-001.sql", "SELECT 1") };

        var result = new DatabaseUpgradeResult(scripts, true, null, null);

        result.Successful.ShouldBeTrue();
        result.Error.ShouldBeNull();
        result.ErrorScript.ShouldBeNull();
        result.Scripts.Count().ShouldBe(1);
    }

    [Fact]
    public void Failed_result_should_contain_error_and_script()
    {
        var errorScript = new SqlScript("bad.sql", "BAD SQL");
        var exception = new Exception("Syntax error");

        var result = new DatabaseUpgradeResult(new[] { errorScript }, false, exception, errorScript);

        result.Successful.ShouldBeFalse();
        result.Error.ShouldBe(exception);
        result.ErrorScript.ShouldBe(errorScript);
    }

    [Fact]
    public void Scripts_collection_should_be_independent_copy()
    {
        var scripts = new List<SqlScript> { new("script-001.sql", "SELECT 1") };
        var result = new DatabaseUpgradeResult(scripts, true, null, null);

        scripts.Clear();

        result.Scripts.Count().ShouldBe(1);
    }

}
