using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

simple_vehicle := class(creative_device):

    @editable
    VehicleSpawner : vehicle_spawner_device = vehicle_spawner_device{}

    OnBegin<override>()<suspends>:void =
        VehicleSpawner.AgentEntersVehicleEvent.Subscribe(OnEnterVehicle)

    OnEnterVehicle(Agent : agent):void =
        Print("Player entered vehicle")