using System.Text.Json;
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
        TestProject   = "../tests/Pondhawk.Migrations.Tests/Pondhawk.Migrations.Tests.csproj";
        MainProject   = "../src/Pondhawk.Migrations/Pondhawk.Migrations.csproj";
        ArtifactsDir  = "../artifacts";

        var versionJson = JsonDocument.Parse(File.ReadAllText("../version.json"));
        var major = versionJson.RootElement.GetProperty("major").GetInt32();
        var minor = versionJson.RootElement.GetProperty("minor").GetInt32();
        var patch = versionJson.RootElement.GetProperty("patch").GetInt32();
        var build = context.Argument("build", 0);

        Version = $"{major}.{minor}.{patch}.{build}";
    }

}
