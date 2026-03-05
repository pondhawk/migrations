using Cake.Common.IO;
using Cake.Common.Tools.DotNet;
using Cake.Common.Tools.DotNet.Clean;
using Cake.Frosting;

namespace Build.Tasks;

[TaskName("Clean")]
public sealed class CleanTask : FrostingTask<BuildContext>
{

    public override void Run(BuildContext context)
    {
        context.DotNetClean(context.Solution, new DotNetCleanSettings
        {
            Configuration = context.Configuration
        });

        context.CleanDirectory(context.ArtifactsDir);
    }

}
