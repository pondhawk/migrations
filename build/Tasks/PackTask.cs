using Cake.Common.Tools.DotNet;
using Cake.Common.Tools.DotNet.Pack;
using Cake.Core;
using Cake.Frosting;

namespace Build.Tasks;

[TaskName("Pack")]
[IsDependentOn(typeof(TestTask))]
public sealed class PackTask : FrostingTask<BuildContext>
{

    public override void Run(BuildContext context)
    {
        context.DotNetPack(context.MainProject, new DotNetPackSettings
        {
            Configuration = context.Configuration,
            NoBuild = true,
            NoRestore = true,
            OutputDirectory = context.ArtifactsDir,
            ArgumentCustomization = args => args.AppendQuoted($"/p:Version={context.Version}")
        });
    }

}
