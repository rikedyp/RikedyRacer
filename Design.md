# Tower Defense Racer 
Isometric top-down 2D racing game tower defense fusion  
Made with Godot 3  

Design notes and future ideas

CONTENTS
[Overview](#overview)
[Gameplay](#gameplay)
[Godot project structure](#godot-project-structure)
[Future ideas](#future-ideas)
[Influences](#influences)
[Targets](#targets)
[Towers](#towers)
[Vehicles](#vehicles)
[Stages](#stages)

### Overview
- Mulitplayer as priority
- Mobile app compatability (consider touch screen)

### Gameplay
Splash screen
Main menu:
	Multi player
	Single player
Multiplayer + single player with more content
	- Tower upgrades (at least 3 types with multi-tier upgrades)
	- Vehicle upgrades
		- 1 per tower type (counter)
		- Boost
		- Armour
	- NPC / AI opponent (at least 1) that builds towers as well (random strategy)

### Godot project structure
- project.godot
	Godot project file
- Assets
	Images and Godot .tscn files for all game elements
	- Vehicles
	- Towers
	- Stages
- gd
	All .gd scripts 

### Future ideas
- Top down + 3rd person graphics
- 3D engine for version 2
- More types of terrain
	- Hills?
	- Boost pads
- In-built level editor 

### WIP
Different cars have features / abilities, resistance / weaknesses
- Preset / unlockable cars
- Customisable cars
- Trade fixed no. of points for speed, resilience, handling etc.

### Influences
- Infinitode
- Pixeljunk Monsters 2
- Other TD Games
- Mario Kart Advance
- Micro Machines
- Other Racing Games

### Targets
- Balancing mechanics a la mario kart
- Skilled players can evade hindrance but novice players can still enjoy a game

### Towers
- Tower colours match car colours for each player
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