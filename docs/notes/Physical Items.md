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

### Tasks
- [ ] Add some collision walls around visible area so item dont fall off the screen
- [ ] Create a test item object made of rigidbodies that is going to exist in physical world and be colliding with the walls, obey gravity
- [ ] Make test item draggable, drag drop, gain momentum on mouse movement
- [ ] Compose test dragabble with actual item and try to snap it to grid
- [ ] converty testitem from grid to physical world