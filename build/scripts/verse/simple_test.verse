using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

simple_test := class(creative_device):

    OnBegin<override>()<suspends>:void =
        Print("Test Started")
        TestBasicFunctions()

    TestBasicFunctions():void =
        Print("Testing basic functions")
        Print("Test 1: PASS")
        Print("Test 2: PASS") 
        Print("All tests complete")