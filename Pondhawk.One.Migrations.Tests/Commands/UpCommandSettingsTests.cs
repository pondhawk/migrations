using Pondhawk.Migrations.Commands;
using Shouldly;

namespace Pondhawk.Migrations.Tests.Commands;

public class UpCommandSettingsTests
{

    [Fact]
    public void Default_settings_should_have_empty_strings()
    {
        var settings = new UpCommand.UpSettings();

        settings.Provider.ShouldBe(string.Empty);
        settings.ConnectionString.ShouldBe(string.Empty);
        settings.ScriptsPath.ShouldBe(string.Empty);
        settings.VersionSchema.ShouldBe(string.Empty);
        settings.VersionTable.ShouldBe(string.Empty);
        settings.PreRunScriptPattern.ShouldBe(string.Empty);
        settings.ScriptPattern.ShouldBe(string.Empty);
        settings.PostRunScriptPattern.ShouldBe(string.Empty);
    }

    [Fact]
    public void Default_quiet_should_be_false()
    {
        var settings = new UpCommand.UpSettings();

        settings.Quiet.ShouldBeFalse();
    }

    [Fact]
    public void Default_testing_should_be_false()
    {
        var settings = new UpCommand.UpSettings();

        settings.Testing.ShouldBeFalse();
    }

}

public class UpConfigurationTests
{

    [Fact]
    public void Default_configuration_should_have_sensible_defaults()
    {
        var config = new UpConfiguration();

        config.Provider.ShouldBe(string.Empty);
        config.ConnectionString.ShouldBe(string.Empty);
        config.ScriptsPath.ShouldBe("./db-scripts");
        config.VersionSchema.ShouldBe(string.Empty);
        config.VersionTable.ShouldBe("SchemaVersions");
        config.PreRunScriptPattern.ShouldBe("pre-run-script.sql");
        config.ScriptPattern.ShouldBe("script-*.sql");
        config.PostRunScriptPattern.ShouldBe("post-run-script.sql");
    }

}
