using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

race_manager := class(creative_device):

    @editable
    StartDevice : trigger_device = trigger_device{}
    
    @editable 
    CheckpointDevices : []trigger_device = array{}
    
    @editable
    FinishDevice : trigger_device = trigger_device{}
    
    @editable
    TimerDevice : hud_message_device = hud_message_device{}

    var RaceActive : logic = false
    var RaceStartTime : float = 0.0
    var PlayerTimes : [player]float = map{}
    var PlayerCheckpoints : [player]int = map{}

    OnBegin<override>()<suspends>:void =
        StartDevice.TriggeredEvent.Subscribe(OnRaceStart)
        FinishDevice.TriggeredEvent.Subscribe(OnRaceFinish)
        
        for (Index := 0..CheckpointDevices.Length - 1):
            if (CheckpointDevice := CheckpointDevices[Index]):
                CheckpointDevice.TriggeredEvent.Subscribe(OnCheckpointReached)

    OnRaceStart(Agent : agent):void =
        if (Player := player[Agent]):
            StartRace()

    StartRace():void =
        set RaceActive = true
        set RaceStartTime = GetSimulationElapsedTime()
        set PlayerTimes = map{}
        set PlayerCheckpoints = map{}
        
        TimerDevice.SetText("Race Started!")
        Print("Race has begun!")

    OnCheckpointReached(Agent : agent):void =
        if (Player := player[Agent]):
            if (RaceActive):
                set PlayerCheckpoints[Player] = 1
                Print("Player reached checkpoint")

    OnRaceFinish(Agent : agent):void =
        if (Player := player[Agent]):
            if (RaceActive):
                RaceTime := GetSimulationElapsedTime() - RaceStartTime
                set PlayerTimes[Player] = RaceTime
                TimerDevice.SetText("Finished!")
                Print("Player finished race")