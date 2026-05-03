### System Requirements:
-  Backpack Items
	- Visual Texture
	- Support various sizes, a footprint
	- right angle clockwise rotations
	- can be placed on the grid
	- items can be placed on it
	- moving or rotating backpack moves items inside of it
	- a single item can span over multiple backpacks
- Grid
	- needs to accept backpacks instead of items 
	- still needs to have knowledge of items (for combat processing), not necessarily direct
- Hovering of Items and bags should have som visial feedback

### Task Order
- [x] Define an abstract Backpack Control Node
	- needs to utilise draw for appearence
	- needs a footprint
- [x] create first back of size 3x3 - initial bag
- [x] drag and drop api 
	- backpacks needs to implement drag api
	- extend item box to accept backpacks
	- properly offset bag preview
- [x] modify grid to accept backpacks (still accept items)
- [x] modify backpacks to accept items
	- [x] need to span over multiple bag somehow
	- [x] might need communication between bags via inventory
	- [x] need some visual cue on where item is going
	- [x] picking up backpack with items
		- [x] backpacks need to know whiuch items are placed over them
			- [x] when adding item provide item reference to item, with information if its part of item or full
			- [x] when item is moved remove that reference (probably by iterating over all bags and checking for item reference)
			- [x] when bag contains partial items, prevent drag call
			- [x] when bag contains full item, add duplicates of items to preview for dragging, provide item references to data so they can be moved in the grid like bag
	- [x] fix bugs
- [x] visual hover feedback
- [ ] add bag rotations
	- [x] rotate bags like items
	- [x] make sure bags can be rotated with item in it
		- [x] preview needs to rotate
		- [x] ensure placing bag with rotation places items in proper cells
			- the solution seems to be to store bag calles item occupies instead of top left corner it occupies, or at least store enough information to recompute which cells are occupied
		- [x] rotating bag rotates items
		- [x] preview needs to match grid states properly
		- [x] what if I rotate item but placement fails?
			- items get scattered all over the grid
			- I need to either detect placement failure and unrotate items
			- or apply rotation if placement is successful
			- the problem with unrotating after failure is I would need information how amny times the preview was rotated to know how many times to unrotate it
			- the problem with applying rotations after drop is successful is that can_drop uses rotated state so I would have to save rotation state without actually applying rotation and then yeah this is clearly more complex
			- [x] unrotate items when bag palcement fails
- [ ] make code not ass
	- [ ] do some compositon or inheritance between bags and items, a lot of similarity
- [x] prevent grid from accepting items, backpacks fully handle it now

### Bugs
- [x] I dont need globals anymore, constants have global scope if there is a class name
- [x] bags can overlap
- [x] bags cant be placed back in inventory when moving between box and inventory
- [x] maybe prevent drawing in cells where bags are
- [x] some weird bug with items disappearing when moved between inventory and box or something
- [x] swapping items in the bags can cause ordering issue, part of item above bag part of item below
- [x] prevent bag dragging during combat
- [x] preview items in a bag dont position properly
- [x] item moved with bag are not placed in correct cell
- [x] some weird ass bug that delays after dragging after failing bag dragging when it was not allowed or something, dont know kidna werird
	- doesnt seem reproducable anymore
- [x] weird case where bag is being dragged instead of item
	-  seems to happen when bag is added after item and item is moved on the bag, so an ordering issue
- [x] items dont disappear when dragged as part of bag
- [x] items need to move back to item box with the bag
- [x] another bug where certain cells become not allowed for some reason, happens when i have multiple bags and items
- [x] visual indexing issues
- [x] items disappear under bags when dragging
	- doesnt seem reproducable anymore
- [x] items are not removed from bags when moving to inventory? its fine except they are not together visually so monka
- [x] shader is not applied vertically if objects are rotated
- [ ] bonus cells dont get unrotated

### Other Things to work on
- might be better to cerate common node for Item and Bag

### Thoughts
- Bag name ideas: Pouch, Satchel, Saddlebag, Haversack, Sack, Sling, Holster, Quiver, Wallet, Pockets, Backpack, Pack, Trunk, Chest, Crate, Barrel, Strongbox, Void Pouch, Bottomless Sack, Dimensional Pocket, Ether Sack, Runebag, Holding Pouch, Fanny Pack, Bindle, Knapsack, Ditty Bag, Swag Bag