using Cake.Common;
using Cake.Common.IO;
using Cake.Common.Tools.DotNet;
using Cake.Common.Tools.DotNet.NuGet.Push;
using Cake.Core;
using Cake.Frosting;

namespace Build.Tasks;

[TaskName("Publish")]
[IsDependentOn(typeof(PackTask))]
public sealed class PublishTask : FrostingTask<BuildContext>
{

    public override void Run(BuildContext context)
    {
        var source = context.Argument<string>("source", "https://api.nuget.org/v3/index.json");
        var apiKey = context.Argument<string>("api-key", "");

        if (string.IsNullOrWhiteSpace(apiKey))
            throw new CakeException("--api-key is required for publishing");

        var package = context.GetFiles($"{context.ArtifactsDir}/Pondhawk.Migrations.*.nupkg")
            .OrderByDescending(f => f.FullPath)
            .FirstOrDefault();

        if (package is null)
            throw new CakeException("No .nupkg found in artifacts directory");

        context.DotNetNuGetPush(package.FullPath, new DotNetNuGetPushSettings
        {
            Source = source,
            ApiKey = apiKey
        });
    }

}
