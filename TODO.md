# TODO
Place all TODOs in here.  
There may be TODOs in any gdscript files

### CONTENTS
- [General](#general)
- [Vehicles](#vehicles)
- [Towers](#towers)

### General
- 1.0 Name
- 1.0 Executables
	- Win
	- Mac
	- Linux (+ 32 bit)
	- iOS
	- Android

### Game modes
- Mulitplayer as priority
- Tower Mode zoom in/out
- 1.0 Boot Splash / Logo
- 1.0 Make sure signals are attached at _ready() function 
- 1.0 Car colour assigned in the lobby
- 1.0 Add barries which cars cannot go past
- Warn cars which go in wrong direction after a little while
- 1.0 Multiplayer all from lobby [hide() show() methods] OR change_scene?
- More types of terrain
	- Hills?
	- Boost pads
- Tower colours match car colours for each player
- 1.0 Set # laps in the lobby
- 0.5 Basic Game:  
	2 Player online 
	- Clean up comments & prints
	- Export executable for mac, win, lin

- 1.0 New game without closing / reopening program
	- Laps reset on back to lobby / new game
	- Game resets correctly on back to lobby / new game
	- Other players return to lobby on network disconnect



- MK-style buttons? A, B + Directions (forward / reverse?)
- 1.0 Flesh out tower mode
	- Spawn towers (tower tokens / limited available)
	- Tower upgrades
	- Tower types
		- Slow enemy
- 1.0 Tower aim areas are circles on the ground (so oval really)
- Make tower aim angles more faithful to the isometric world
- Maybe towers can only aim in 8 directions?
- 1.0 Decide and get consistent with variable / function naming conventions (check python)
- 1.0 Test cross compatibility of different versions executables to determine version
- 1.0 Single player time trial / sandbox / tutorial level minimum
- Maybe 1 AI that follows simple track 
- 1.0 Restructure folders 
	- Assets (used images only, with full collections in TDRacer-dev and sources in the docs)
	- Vehicles
	- Towers
	- Levels
	- gd (replace lib)
	- Clean up OLD (Move to dev folder)
- 1.0 Towers
	- Tower which slows the car temporarily (attach timer)
	- Pistol
	- MG (Rapid fire)
	- Shotgun (Spray)
	- Rocket (BOOM!)
- 1.0 Full Game:  
	Multiplayer + single player with more content
	- Tower upgrades (at least 3 types with multi-tier upgrades)
	- Vehicle upgrades
		- 1 per tower type (counter)
		- Boost
		- Armour
	- NPC / AI opponent (at least 1) that builds towers as well (random strategy)
- > 2P Multiplayer
	- Players join the lobby, then game starts
	- PvP and Team modes
- 1.0 Main menu + splash screen
- Use Tiled Tilemap editor with tiled map importer  
	https://godotengine.org/asset-library/asset/158
- Other obstacles / items / weapons / things
- In-built level editor

### Vehicles
Do not make these with haste, many game balancing variants can be added in as the game develops  
Check out those loop maths dice games on YouTube
- Colour Cars come in (probably nice to choose colour then car)
Blue | Green | Grey | Orange | Pink | Purple | Red | White | Yellow   
	- Basic sedan car 			BG1G2OP1RWY
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

### Towers
- Cannon
- Flamthrower
- Laser
- Matter
- MG
- Pistol
- Rocket
- Shotgun
- Spazer

### Items
- Check Assets

### Terrain
- Road/grass inside corner
- More interesting terrain
- Animated decoration
- Wreckable decoration