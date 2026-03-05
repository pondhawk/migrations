using DbUp.Engine;
using Pondhawk.Migrations.Listeners;

namespace Pondhawk.Migrations;

public class UpgradeService( WatchUpgradeListener listener, UpgradeEngine engine)
{

    public UpgradeEngine Engine => engine;
    
    public WatchUpgradeListener Listener => listener; 

}