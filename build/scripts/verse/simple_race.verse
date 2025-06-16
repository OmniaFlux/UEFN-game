using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

simple_race := class(creative_device):

    @editable
    StartTrigger : trigger_device = trigger_device{}
    
    @editable
    FinishTrigger : trigger_device = trigger_device{}

    var RaceStarted : logic = false

    OnBegin<override>()<suspends>:void =
        StartTrigger.TriggeredEvent.Subscribe(OnStartRace)
        FinishTrigger.TriggeredEvent.Subscribe(OnFinishRace)

    OnStartRace(Agent : agent):void =
        set RaceStarted = true
        Print("Race Started")

    OnFinishRace(Agent : agent):void =
        if (RaceStarted):
            Print("Race Finished")
            set RaceStarted = false