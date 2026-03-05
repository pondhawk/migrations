using Cake.Frosting;

namespace Build.Tasks;

[TaskName("Default")]
[IsDependentOn(typeof(PackTask))]
public sealed class DefaultTask : FrostingTask<BuildContext>
{
}
