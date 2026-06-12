This will be an automation game inspired by Factorio
#### Project Goals
- Procedural generation of the world
	- different resources in different places, different sizes etc
	- maybe some decorations as well
- crafting - make stuff out of other stuff
- building
	- extraction building
	- processing building
- conveyor belts
- inserters

#### Technical Details/Scope
- TileMapLayer heavy game
	- terrain layer
	- resource layer
	- building layer
- Procedural Generation
	- experiment with **FastNoiseLite** - godots noise generation
	- maybe a chunk system
	- maybe a seed system would be cool to learn
- Conveyor Belt
	- they connect to each other
	- they can be rotated
	- items queue on them
- Inserters
	- move resources from one tile to other
- Buildings
	- 1 building for extracting resources
	- 1 building for processing 2 resources into 3rd
- Crafting
	- use resources to make buildings
- Resources
	- fuel resource + material resource = new resource
- Extract resources manually