# TDRacer
Multiplayer Tower Defence Racing Game Mashup
  made with Godot 3

### Quickstart

project.godot in TowerDefenseRacer

There are executables in the bin folder

### Build a level  
View 'RaceTrack1' in 'Maps' for example  
1. Create new scene  
2. Add Node2D  
3. Add Tilemap named 'Environment'
4. Add Tilemaps 'Decoration', 'Boundary' as children of 'Environment'
5. Add Area2D named 'Grass'
6. Add CollisionPolygon2D as child of 'Grass'
7. Draw tiles on to 'Environment', 'Decoration', 'Boundary'
8. Draw polygon for 'Grass' (movement slows here)