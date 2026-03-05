using Microsoft.Extensions.DependencyInjection;

namespace Pondhawk.Migrations.Modules;

public interface IImplementationModule
{

    public string ConnectionString { get; init; }
    public string VersionSchema { get; init; }
    public string VersionTable { get; init; }

    void ConfigureServices(IServiceCollection services);

}
