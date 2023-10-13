using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Verse.org/Random }

#########################################################################################################################
#Item Granter Randomizer PRO 
# ____               _                                     _         
#|  _ \             | |                                   | |        
#| |_) | _   _  ___ | |__   _   _   ___  _ __  ___   __ _ | |_  ___  
#|  _ < | | | |/ __|| '_ \ | | | | / __|| '__|/ _ \ / _` || __|/ _ \ 
#| |_) || |_| |\__ \| | | || |_| || (__ | |  |  __/| (_| || |_|  __/ 
#|____/  \__,_||___/|_| |_| \__, | \___||_|   \___| \__,_| \__|\___| 
#                            __/ |                                   
#                           |___/                                    
# More at https://dev.epicgames.com/community/profile/M07Y0/BushyCreates
# uhh look at my twitter and follow it for more i guess: https://Twitter.com/BushyCreate
#########################################################################################################################   
Reward := class<concrete><public>:
    # Get our devices that we can assign in the UEFN Editor
    @editable ItemGranter<public> : item_granter_device = item_granter_device{} # The Item Granters that one of which will be randomly chosen | Can be used to grant items (Leave empty to grant nothing when this granter is chosen)                                                                                        #Hi 👋😀
    @editable HUDMessage<public> : hud_message_device = hud_message_device{} # The Hud Message Device that one of which will be randomly chosen | Can be used to show messages on screen (Example: You found an Acorn!)
    @editable MessageFeed<public> : elimination_feed_device = elimination_feed_device{} # The Elimination Feed Device that one of which will be randomly chosen | Can be used to activate messages in the Kill Feed :P
    @editable Trigger<public> : trigger_device = trigger_device{} # Adds an Trigger that you can link to whatever you want, I won't judge :D
    
    #Variables
    @editable DebugMessage : string = "Hello World" # A funny debug message for well... Debugging!!!!!!!! yay woohoo!!!! Note: Only activates when DebugMode is true
    @editable DebugMode : logic = false # Can be used for debugging i guess

    GrantReward(Agent:agent):void=
        ItemGranter.GrantItem(Agent)  # Grants the Item
        HUDMessage.Show(Agent) # Shows the Hud Message
        MessageFeed.Activate(Agent) # Shows the message in the kill feed
        Trigger.Trigger(Agent) # Triggers the Trigger :3
        if (DebugMode?):
            Print("{DebugMessage}")


SearchableObjectManager := class(creative_device): # Makes it a Creative Device... 
    #Get our arrays :)
    @editable Rewards : []Reward = array{} # Makes it so you can add more Reward Classes in the Editor
    @editable Buttons : []button_device = array{} # Choose the BUTTON devices that you can use to activate the GrantItem function (Can be assigned in the editor) 
    

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void= # Activates when the game starts
        for (Objects : Buttons): # I honestly have no idea why this has to be here but it doesn't work without it (Try removing it and you can see an error (Use Ctrl+Z to reverse it if you try))
            Objects.InteractedWithEvent.Subscribe(GrantItem) # Activates the GrantItem when the button is pressed
            
            
    GrantItem(Agent : agent) : void = # Activates when a button is pressed
        @editable RandomNumber := GetRandomInt(0, Rewards.Length-1) # Generates an random number between 0 and the amount Indexes your array has (-1 at the end since it starts counting at 1 but we want to start at 0)
        if (TheReward:=Rewards[RandomNumber]):  # Chooses the Index that was generated on the previous line
            TheReward.ItemGranter.GrantItem(Agent) # Grants the Item
            TheReward.HUDMessage.Show(Agent) # Shows the Hud Message
            TheReward.MessageFeed.Activate(Agent) # Shows the message in the kill feed
            TheReward.Trigger.Trigger(Agent) # Triggers the Trigger that can trigger another trigger ok i'll stop
