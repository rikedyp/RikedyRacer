# Tower Defense Racer 
Isometric top-down 2D racing game tower defense fusion  
Made with Godot 3  

Design notes and future ideas

CONTENTS  
[Overview](#overview)  
[Gameplay](#gameplay)  
[Godot project structure](#godot-project-structure)  
[Multiplayer methods](#multiplayer-methods)
[Future ideas](#future-ideas)  
[Influences](#influences)  
[Targets](#targets)  
[Towers](#towers)  
[Vehicles](#vehicles)  
[Stages](#stages)  
  
### Overview
- RikedyRacer is a 2D racing game / tower defense mashup.
- Made with Godot 3 
- Multiplayer focus
- 2D isometric top-down view a la Gaelco World Rally Championship

### Gameplay
Multiplayer + single player with more content  
	- Tower upgrades (at least 3 types with multi-tier upgrades)  
	- Vehicle upgrades  
		- Mana system (RaceCoin)
		- 1 per tower type (counter)  
		- Boost  
		- Armour  
	- NPC / AI opponent (at least 1) that builds towers as well (random strategy)  
##### User Stories
 1 - Open application from system menu  
Splash screen   
 2 - Main menu:    
	Multi player    
		Lobby menu (host / join)  
		3 - Host  
		3 - Join  
	Single player    

  
### Godot project structure
- project.godot
	Godot project file
- assets
	Images and Godot .tscn files for all game elements
	- vehicles
	- towers
	- stages
- gd
	All .gd scripts 

### Multiplayer methods
By design, Godot 3 let's you start multiplayer games in single player with ease. This means it is easier to focus on multiplayer functionality and modify stages in the future for single player modes.
TODO: Tutorial for this stuff
RikedyRacer uses a gamestate singleton node as a kind of global variables holder for game state information
This node contains some network connection related functions to bring players into the game and also spawn the players. Generally this means that all game levels (stages) require the same or similar structure. <- These details may be laid out at a later date.
Gamestate contains a variable my_player which is the reference to the current device's player.
It also contains a dictionary players which will be filled with the key game variables for all relevant players on the network and can be updated at particular times in the game (or regularly throughout the game).
Use gamestate methods to save game information.
TODO: Persistent game file for unlockables or whatever.

### Future ideas
- Top down + MK/F-Zero style graphics in race mode
- Pit stops can restore HP over time?
- 3D engine 
- More types of terrain
	- Hills?
	- Boost pads
- In-built level editor 
Different cars have features / abilities, resistance / weaknesses
- Preset / unlockable cars
- Customisable cars
- Trade fixed no. of points for speed, resilience, handling etc.
- Kubrickian (impossible) layouts e.g. Shining mansion
- Rocket League mini-game / game mode
- Drone battle / attack vehicles with drones / drone weapon
    - Drone tower that launches drones which you can control for short amount of time
- Double dash team mode 1 drives 1 tower defends / 1 drones
- Use Spine animations https://github.com/GodotExplorer/spine

### Influences
- Infinitode
- Pixeljunk Monsters 2
- Other TD Games
- Gaelco World Rally Championship
- F-Zero 
- R.C. Pro-Am 
- Mario Kart Advance
- Micro Machines
- Other Racing Games

### Targets
- Balancing mechanics a la mario kart
- Skilled players can evade hindrance but novice players can still enjoy a game

### Towers
- Tower colours match car colours for each player
- Towers are bigger
- Animated shooting, aiming, idling
- Slow enemy tower
- Crossbow / pistol short spurts low damage
- Trebuchet / charge laser low speed high damage
- Oil / toxic gas fountains
- Have the free assets for:
	- Cannon
	- Flamthrower
	- Laser
	- Matter
	- MG
	- Pistol
	- Rocket
	- Shotgun
	- Spazer

### Vehicles
Do not make these with haste, many game balancing / enhancing variants can be added in as the game develops  
Check out those loop maths dice games on YouTube
- Colour Cars come in (probably nice to choose colour then car)
Blue | Green | Grey | Orange | Pink | Purple | Red | White | Yellow   
	- Basic sedan car 			BG1G2OP1P2RWY
	- Sport coupe 				BG1G2OP1P2RWY
	- Compact city car 			BG1G2OP1P2RWY
	- Hothatch car 				BG1G2OP1P2RWY
	- Small delivery car 		BG1G2OP1P2RWY
	- Mini MPV 					BG1G2OP1P2RWY
	- Station wagon 			BG1G2OP1P2RWY
	- MPV 						BG1G2OP1P2RWY
	- Minibus 					BG1G2OP1P2RWY
	- Delivery van 				BG1G2OP1P2RWY
	- Pickup truck  			BG1G2OP1P2RWY
	- Small pickup car 			BG1G2OP1P2RWY
	- German sportscar 			BG1G2OP1P2RWY
	- Italian horse sportscar 	BG1G2OP1P2RWY
	- Italian bull sportscar 	BG1G2OP1P2RWY
	- Formula car 				BG1G2OP1P2RWY
	- Group C 					BG1G2OP1P2RWY
	- Group C Badass 			BG1G2OP1P2RWY
	- Kart 						BG1G2OP1P2RWY
- Ground + air vehicles (sea / air mode?) only affected by certain weapons

### Stages
- Consider Tiled imports
https://godotengine.org/asset-library/asset/158
- In-built level editor
- Road/grass inside corner
- More interesting terrain
- Animated decoration
- Wreckable decoration