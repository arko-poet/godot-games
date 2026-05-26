### System Requirements
- trying to mimic Backpack Battles system where items outside of inventory grid behave like physical items
- the challenge is that control components dont exist in physical world so cant be simulated this way, so there are 2 options
	- refactor items to be nodes2d, create new drag and drop api for Node2D so they snap to grid
	- create node2d components which will be activated when items are outside of Inventory, click on them to start dragging actual physical components
- need to create some space where physical items obey physical laws, this will replace ItemBox

### Implementation
- Attempt to implement Node2D as a component of Item
- Clicking on physical item is going to hide it while showing force drag control item
- Failing drop operation is going to move item back to physical world by hiding control, showing physical and moving it to physical world
- To obey physical laws I think RigidBody will be appropriate os that I can assign weight to certain item parts, e.g. mace is going to have most of its weight at the tip, and less at handle
- The Items need to be able to gain momentum by users input, so user can throw it , this may require full reafactor to node2d, not sure if I can do it in some other way. Technically it might be possible to fake it, user drags control node around but underneath it there is a hidden rigidbody which gains momentum
- Composition
	- Option 1 Control parent, Node2D child
	- Option 2 Node2D parent, Control child
	- Option 3 separate associated components
		- this seems the least clunky option, other options are kinda hard cause Control and Node2D is a different coordinate system, also its tricky to move/hide one without affecting the other

### Tasks
- [x] Add some collision walls around visible area so item dont fall off the screen
- [x] Create a test item object made of rigidbodies that is going to exist in physical world and be colliding with the walls, obey gravity
- [x] Make test item draggable, drag drop, gain momentum on mouse movement
	- [x] draggable
	- [x] droppable
	- [x] ease on input
	- [x] momentum
- [x] Compose test dragabble with actual item and try to snap it to grid
- [ ] converty testitem from grid to physical world


### Problems
- [ ] the rigid body release impulse can be applied multiple times which make objects exceed speed limit
- [ ] sometimes the firection of the impulse does not match where player expects the object to go, its not intuitive
	- perhaps an average of recent mouse movement would work better than whats now
- [ ] input is captured on rigidbodies even when dragging control nodes