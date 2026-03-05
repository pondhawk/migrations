using DbUp.Engine;
using DbUp.Engine.Output;
using DbUp.Engine.Transactions;
using DbUp.MySql;
using Microsoft.Extensions.DependencyInjection;
using NSubstitute;
using Pondhawk.Migrations.Modules;
using Pondhawk.Migrations.Modules.MySql;
using Shouldly;

namespace Pondhawk.Migrations.Tests.Modules;

public class MySqlModuleTests
{

    private static MySqlModule CreateModule() => new()
    {
        ConnectionString = "server=localhost; database=test; user=root; password=pass;",
        VersionSchema = "myschema",
        VersionTable = "SchemaVersions",
    };


    [Fact]
    public void Should_register_connection_manager()
    {
        var services = new ServiceCollection();
        var module = CreateModule();

        module.ConfigureServices(services);

        using var sp = services.BuildServiceProvider();
        using var scope = sp.CreateScope();

        var cm = scope.ServiceProvider.GetService<IConnectionManager>();
        cm.ShouldNotBeNull();
        cm.ShouldBeOfType<MySqlConnectionManager>();
    }

    [Fact]
    public void Should_register_journal()
    {
        var services = new ServiceCollection();
        var module = CreateModule();

        module.ConfigureServices(services);

        // Journal needs IConnectionManager and IUpgradeLog
        services.AddScoped(_ => Substitute.For<IUpgradeLog>());

        using var sp = services.BuildServiceProvider();
        using var scope = sp.CreateScope();

        var journal = scope.ServiceProvider.GetService<IJournal>();
        journal.ShouldNotBeNull();
    }

    [Fact]
    public void Should_register_script_executor()
    {
        var services = new ServiceCollection();
        var module = CreateModule();

        module.ConfigureServices(services);

        // ScriptExecutor needs IConnectionManager, IUpgradeLog, and IJournal
        services.AddScoped(_ => Substitute.For<IUpgradeLog>());

        using var sp = services.BuildServiceProvider();
        using var scope = sp.CreateScope();

        var executor = scope.ServiceProvider.GetService<IScriptExecutor>();
        executor.ShouldNotBeNull();
    }

    [Fact]
    public void Should_implement_IImplementationModule()
    {
        var module = CreateModule();

        module.ShouldBeAssignableTo<IImplementationModule>();
    }

    [Fact]
    public void Should_have_migration_module_for_attribute()
    {
        var attrs = typeof(MySqlModule)
            .GetCustomAttributes(typeof(MigrationModuleForAttribute), false)
            .Cast<MigrationModuleForAttribute>()
            .ToList();

        attrs.Count.ShouldBe(1);
        attrs[0].Name.ShouldBe("MySql");
    }

}
