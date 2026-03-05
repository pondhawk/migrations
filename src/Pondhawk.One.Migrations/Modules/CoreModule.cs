using System.Text;
using DbUp.Builder;
using DbUp.Engine;
using DbUp.Engine.Output;
using DbUp.Engine.Transactions;
using DbUp.ScriptProviders;
using DbUp.Support;
using Pondhawk.Migrations.Listeners;
using JetBrains.Annotations;
using Microsoft.Extensions.DependencyInjection;

// ReSharper disable AutoPropertyCanBeMadeGetOnly.Global
// ReSharper disable MemberCanBePrivate.Global

namespace Pondhawk.Migrations.Modules;

[AttributeUsage(AttributeTargets.Class, AllowMultiple = true)]
public class MigrationModuleForAttribute(string name) : Attribute
{
    public string Name { get; } = name;
}

[UsedImplicitly]
public class CoreModule
{

    public string ScriptPath { get; init; }  = string.Empty;
    public string PreRunScriptPattern { get; init; }  = string.Empty;
    public string ScriptPattern { get; init; }  = string.Empty;
    public string PostRunScriptPattern { get; init; }  = string.Empty;

    public bool ShowProgress { get; init; } = true;


    public void ConfigureServices(IServiceCollection services)
    {

        // Pre-run scripts (RunAlways, order 100)
        services.AddScoped<IScriptProvider>(_ =>
        {
            var fso = new FileSystemScriptOptions { Extensions = [PreRunScriptPattern], IncludeSubDirectories = false, Encoding = Encoding.UTF8 };
            var sso = new SqlScriptOptions { ScriptType = ScriptType.RunAlways, RunGroupOrder = 100 };
            return new FileSystemScriptProvider(ScriptPath, fso, sso);
        });

        // Main scripts (RunOnce, order 1000)
        services.AddScoped<IScriptProvider>(_ =>
        {
            var fso = new FileSystemScriptOptions { Extensions = [ScriptPattern], IncludeSubDirectories = false, Encoding = Encoding.UTF8 };
            var sso = new SqlScriptOptions { ScriptType = ScriptType.RunOnce, RunGroupOrder = 1000 };
            return new FileSystemScriptProvider(ScriptPath, fso, sso);
        });

        // Post-run scripts (RunAlways, order 10000)
        services.AddScoped<IScriptProvider>(_ =>
        {
            var fso = new FileSystemScriptOptions { Extensions = [PostRunScriptPattern], IncludeSubDirectories = false, Encoding = Encoding.UTF8 };
            var sso = new SqlScriptOptions { ScriptType = ScriptType.RunAlways, RunGroupOrder = 10000 };
            return new FileSystemScriptProvider(ScriptPath, fso, sso);
        });


        services.AddScoped<WatchUpgradeListener>(_ => new WatchUpgradeListener
        {
            ShowProgress = ShowProgress,
            ProgressWriter = m => UiHelper.ShowProgress(m)
        });

        services.AddScoped<IUpgradeLog>(sp => sp.GetRequiredService<WatchUpgradeListener>());


        services.AddScoped(sp =>
        {

            var conMgr      = sp.GetRequiredService<IConnectionManager>();
            var scriptEx    = sp.GetRequiredService<IScriptExecutor>();
            var listenerPrv = sp.GetRequiredService<WatchUpgradeListener>();
            var upgradeJrnl = sp.GetRequiredService<IJournal>();
            var scriptPrvs  = sp.GetRequiredService<IEnumerable<IScriptProvider>>();

            var ueb = new UpgradeEngineBuilder();

            ueb.Configure(cfg =>
            {

                cfg.ConnectionManager = conMgr;
                cfg.ScriptExecutor    = scriptEx;
                cfg.Journal           = upgradeJrnl;

                foreach (var p in scriptPrvs)
                    cfg.ScriptProviders.Add(p);

                cfg.AddLog(listenerPrv);

            });

            var engine = ueb.Build();

            return new UpgradeService(listenerPrv, engine);

        });


    }


}
