using DbUp.Engine;
using DbUp.Engine.Output;
using DbUp.Engine.Transactions;
using DbUp.ScriptProviders;
using Microsoft.Extensions.DependencyInjection;
using NSubstitute;
using Pondhawk.Migrations.Listeners;
using Pondhawk.Migrations.Modules;
using Shouldly;

namespace Pondhawk.Migrations.Tests.Modules;

public class CoreModuleTests
{

    private static CoreModule CreateModule(string scriptsPath = "./db-scripts") => new()
    {
        ScriptPath = scriptsPath,
        PreRunScriptPattern = "pre-run-script.sql",
        ScriptPattern = "script-*.sql",
        PostRunScriptPattern = "post-run-script.sql",
        ShowProgress = false,
    };

    private static ServiceCollection CreateServicesWithMocks()
    {
        var services = new ServiceCollection();

        services.AddScoped(_ => Substitute.For<IConnectionManager>());
        services.AddScoped(_ => Substitute.For<IJournal>());
        services.AddScoped(_ => Substitute.For<IScriptExecutor>());

        return services;
    }


    [Fact]
    public void Should_register_three_script_providers()
    {
        var services = CreateServicesWithMocks();
        var module = CreateModule();

        module.ConfigureServices(services);

        using var sp = services.BuildServiceProvider();
        using var scope = sp.CreateScope();

        var providers = scope.ServiceProvider.GetServices<IScriptProvider>().ToList();
        providers.Count.ShouldBe(3);
    }

    [Fact]
    public void Should_register_script_providers_as_file_system_providers()
    {
        var services = CreateServicesWithMocks();
        var module = CreateModule();

        module.ConfigureServices(services);

        using var sp = services.BuildServiceProvider();
        using var scope = sp.CreateScope();

        var providers = scope.ServiceProvider.GetServices<IScriptProvider>().ToList();
        providers.ShouldAllBe(p => p is FileSystemScriptProvider);
    }

    [Fact]
    public void Should_register_watch_upgrade_listener()
    {
        var services = CreateServicesWithMocks();
        var module = CreateModule();

        module.ConfigureServices(services);

        using var sp = services.BuildServiceProvider();
        using var scope = sp.CreateScope();

        var listener = scope.ServiceProvider.GetService<WatchUpgradeListener>();
        listener.ShouldNotBeNull();
    }

    [Fact]
    public void Should_register_upgrade_log_as_watch_listener()
    {
        var services = CreateServicesWithMocks();
        var module = CreateModule();

        module.ConfigureServices(services);

        using var sp = services.BuildServiceProvider();
        using var scope = sp.CreateScope();

        var log = scope.ServiceProvider.GetService<IUpgradeLog>();
        log.ShouldNotBeNull();
        log.ShouldBeOfType<WatchUpgradeListener>();
    }

    [Fact]
    public void Should_register_upgrade_service()
    {
        var services = CreateServicesWithMocks();
        var module = CreateModule();

        module.ConfigureServices(services);

        using var sp = services.BuildServiceProvider();
        using var scope = sp.CreateScope();

        var service = scope.ServiceProvider.GetService<UpgradeService>();
        service.ShouldNotBeNull();
        service.Engine.ShouldNotBeNull();
        service.Listener.ShouldNotBeNull();
    }

    [Fact]
    public void Should_respect_show_progress_setting()
    {
        var services = CreateServicesWithMocks();
        var module = new CoreModule
        {
            ScriptPath = "./db-scripts",
            PreRunScriptPattern = "pre-run-script.sql",
            ScriptPattern = "script-*.sql",
            PostRunScriptPattern = "post-run-script.sql",
            ShowProgress = false,
        };

        module.ConfigureServices(services);

        using var sp = services.BuildServiceProvider();
        using var scope = sp.CreateScope();

        var listener = scope.ServiceProvider.GetRequiredService<WatchUpgradeListener>();
        listener.ShowProgress.ShouldBeFalse();
    }

}
