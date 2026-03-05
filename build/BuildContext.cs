using Cake.Common;
using Cake.Core;
using Cake.Frosting;

namespace Build;

public class BuildContext : FrostingContext
{

    public string Solution { get; }
    public new string Configuration { get; }
    public string TestProject { get; }
    public string MainProject { get; }
    public string ArtifactsDir { get; }
    public string Version { get; }

    public BuildContext(ICakeContext context) : base(context)
    {
        Solution      = "../pondhawk-migrations.sln";
        Configuration = context.Argument("configuration", "Release");
        Version       = context.Argument("version", "1.0.0");
        TestProject   = "../tests/Pondhawk.One.Migrations.Tests/Pondhawk.One.Migrations.Tests.csproj";
        MainProject   = "../src/Pondhawk.One.Migrations/Pondhawk.One.Migrations.csproj";
        ArtifactsDir  = "../artifacts";
    }

}
