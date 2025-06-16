# UEFN Racing Game Setup Guide

## Prerequisites
- Unreal Editor for Fortnite installed
- Epic Games account with access to UEFN
- Basic understanding of Verse scripting

## Project Setup

### 1. Create New UEFN Project
1. Open Unreal Editor for Fortnite
2. Create new project
3. Choose "Blank Island" template
4. Name your project "UEFN_Race"

### 2. Import Scripts
1. Copy all `.verse` files from the `scripts/` directory
2. Place them in your UEFN project's Scripts folder
3. Compile the Verse code

### 3. Device Setup

#### Race Manager Device
- Place a `race_manager` device on your island
- Configure the following properties:
  - StartDevice: Trigger device at start line
  - CheckpointDevices: Array of trigger devices for checkpoints
  - FinishDevice: Trigger device at finish line
  - TimerDevice: HUD message device for race timer

#### Vehicle Spawner Device
- Place `vehicle_spawner` devices at spawn points
- Configure:
  - SpawnPad: Creative prop for visual spawn location
  - VehicleSpawner: Vehicle spawner device
  - RespawnTrigger: Trigger for manual respawn

#### Race HUD Device
- Place `race_hud` device on island
- Configure HUD message devices for:
  - Timer display
  - Position display
  - Checkpoint counter

### 4. Track Design
1. Create a circuit track using terrain tools
2. Place checkpoints at strategic locations
3. Add start/finish line markers
4. Include vehicle spawn points
5. Add barriers and decorative elements

### 5. Testing
1. Test in single player mode first
2. Verify all triggers work correctly
3. Check timer functionality
4. Test vehicle spawning/respawning
5. Validate checkpoint system

## Common Issues
- **Verse compilation errors**: Check syntax and device references
- **Devices not triggering**: Verify collision settings
- **Timer not updating**: Ensure HUD devices are properly configured
- **Vehicles not spawning**: Check vehicle spawner settings

## Next Steps
1. Playtest with friends
2. Optimize performance
3. Add visual polish
4. Publish to Fortnite Creative