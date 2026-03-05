using DbUp.Support;
using Shouldly;

namespace Pondhawk.Migrations.Tests.Engine;

public class ScriptNameComparerTests
{

    [Fact]
    public void Ordinal_comparer_should_be_case_sensitive()
    {
        var comparer = new ScriptNameComparer(StringComparer.Ordinal);

        comparer.Equals("Script.sql", "script.sql").ShouldBeFalse();
    }

    [Fact]
    public void OrdinalIgnoreCase_comparer_should_be_case_insensitive()
    {
        var comparer = new ScriptNameComparer(StringComparer.OrdinalIgnoreCase);

        comparer.Equals("Script.sql", "script.sql").ShouldBeTrue();
    }

    [Fact]
    public void Compare_should_delegate_to_inner_comparer()
    {
        var comparer = new ScriptNameComparer(StringComparer.Ordinal);

        comparer.Compare("a.sql", "b.sql").ShouldBeLessThan(0);
        comparer.Compare("b.sql", "a.sql").ShouldBeGreaterThan(0);
        comparer.Compare("a.sql", "a.sql").ShouldBe(0);
    }

    [Fact]
    public void Equal_strings_should_return_zero_from_compare()
    {
        var comparer = new ScriptNameComparer(StringComparer.OrdinalIgnoreCase);

        comparer.Compare("Script.sql", "script.sql").ShouldBe(0);
    }

}
