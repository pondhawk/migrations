using DbUp.Engine;
using DbUp.Engine.Output;
using DbUp.Engine.Transactions;
using DbUp.MySql;
using JetBrains.Annotations;
using Microsoft.Extensions.DependencyInjection;

namespace Pondhawk.Migrations.Modules.MySql;

[MigrationModuleFor("MySql")]
public class MySqlModule: IImplementationModule
{

    public string ConnectionString { get; init; } = string.Empty;
    public string VersionSchema { get; init; } = string.Empty;
    public string VersionTable { get; init; } =  string.Empty;

    public void ConfigureServices(IServiceCollection services)
    {

        services.AddScoped<IConnectionManager>(_ => new MySqlConnectionManager(ConnectionString));

        services.AddScoped<IJournal>(sp =>
        {
            var cm = sp.GetRequiredService<IConnectionManager>();
            var lp = sp.GetRequiredService<IUpgradeLog>();
            return new MySqlTableJournal(() => cm, () => lp, VersionSchema, VersionTable);
        });

        services.AddScoped<IScriptExecutor>(sp =>
        {
            var cm = sp.GetRequiredService<IConnectionManager>();
            var lp = sp.GetRequiredService<IUpgradeLog>();
            var uj = sp.GetRequiredService<IJournal>();
            return new MySqlScriptExecutor(() => cm, () => lp, VersionSchema, () => false, null, () => uj);
        });

    }

}
