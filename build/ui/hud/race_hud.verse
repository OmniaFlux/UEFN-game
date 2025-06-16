using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

race_hud := class(creative_device):

    @editable
    TimerDisplay : hud_message_device = hud_message_device{}
    
    @editable
    PositionDisplay : hud_message_device = hud_message_device{}
    
    @editable
    CheckpointDisplay : hud_message_device = hud_message_device{}

    var CurrentTime : float = 0.0
    var PlayerPosition : int = 1
    var CheckpointsReached : int = 0
    var TotalCheckpoints : int = 5

    OnBegin<override>()<suspends>:void =
        spawn { UpdateHUD() }

    UpdateHUD()<suspends>:void =
        loop:
            UpdateTimer()
            UpdatePosition()
            UpdateCheckpoints()
            Sleep(0.1)

    UpdateTimer():void =
        set CurrentTime = GetSimulationElapsedTime()
        Minutes := Floor(CurrentTime / 60.0)
        Seconds := CurrentTime - (Minutes * 60.0)
        TimeText := "Time: {Minutes}:{Seconds}"
        TimerDisplay.SetText(TimeText)

    UpdatePosition():void =
        PositionText := "Position: {PlayerPosition}"
        PositionDisplay.SetText(PositionText)

    UpdateCheckpoints():void =
        CheckpointText := "Checkpoints: {CheckpointsReached}/{TotalCheckpoints}"
        CheckpointDisplay.SetText(CheckpointText)

    SetPlayerPosition(Position : int):void =
        set PlayerPosition = Position

    SetCheckpointsReached(Checkpoints : int):void =
        set CheckpointsReached = Checkpoints