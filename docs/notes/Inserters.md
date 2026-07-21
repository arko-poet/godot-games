How to implement inserters?
Requirements:
- Inserters need to move materials from one tile to the other
- If one thing in the tile is a building it should extract appropriate material
- If the destinatiopn tile is occupied it shouldn't move (no stacking of items per tile) unless its a building which would accept that resource

Options:
- Inserter needs to have ionfoprmation what's next to it
- Inserter needs to request necessary information from other entity
- Other entity can notify the inserter about what it can do

Implementation:
- I think it makes most sense for inserter to handle the logic of moving entities from one place to
- I need to store information which entity is where somewhere - there needs to be some place that has the knowledge of what is in particular cell
	- could simply hjave a dictionary somewhere or maybe a separate tilemaplayer with reference could be a good option
	- Probably easiest for every inserter to have a reference to that object so they can request information directly without need of signals (this reference would need to be setup by building controller)
- Inserter takes item from one side, either a movable object directly or extract resource from building
	- building need to be able to provide information on what can be extracted from their storage
	- regular movable objects can be just changed by position and appropriate update in entity that manges mapping of tiles to objects
- If destination cells is occupied
	- if its a material then dont move (not stackable)
	- if its a building then that building needs to provide information if it is  willing to accept such material

Tasks:
- [x] Implement Node2D called item which will be responsible for displaying items such as mined coal or other processed materials - it will need to snap to grid
- [x] Implement a dictionary of coords -> Node2D that occupy world cells
	- how to update these coords? options:
		- items and buildings notify of change in position by signal
		- items and buiilding communicate with world directly
		- signals seem better
		- the problem is how do I have a common thing across all buildings?
- [x] Implement logic of inserters
- [x] Enhance storage system of buildings so they can provide a fetchable materials that inserters can take
- [x] Enhance storage system of buildings so they can provide information which material they are willing to accept
- [x] Implement inserter rotations