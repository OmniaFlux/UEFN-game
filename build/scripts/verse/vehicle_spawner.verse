using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

vehicle_spawner := class(creative_device):

    @editable
    SpawnPad : creative_prop = creative_prop{}
    
    @editable
    VehicleSpawner : vehicle_spawner_device = vehicle_spawner_device{}
    
    @editable
    RespawnTrigger : trigger_device = trigger_device{}

    OnBegin<override>()<suspends>:void =
        RespawnTrigger.TriggeredEvent.Subscribe(OnRespawnRequested)
        VehicleSpawner.AgentEntersVehicleEvent.Subscribe(OnPlayerEntersVehicle)
        VehicleSpawner.AgentExitsVehicleEvent.Subscribe(OnPlayerExitsVehicle)

    OnRespawnRequested(Agent : agent):void =
        if (Player := player[Agent]):
            RespawnVehicle(Player)

    RespawnVehicle(Player : player):void =
        VehicleSpawner.SpawnVehicle()
        Print("Vehicle respawned for {Player.GetDisplayName()}")

    OnPlayerEntersVehicle(Agent : agent):void =
        if (Player := player[Agent]):
            Print("Player {Player.GetDisplayName()} entered vehicle")

    OnPlayerExitsVehicle(Agent : agent):void =
        if (Player := player[Agent]):
            Print("Player {Player.GetDisplayName()} exited vehicle")