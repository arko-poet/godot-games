Problems:
- world cant be truly infinite - will run out of memory
	- limit world size
	- load/unload parts of it, need to save whats the difference between what was originally generated and what player changed (need seeds to generate same looking chunk)
- world needs to be random but needs to have patterns to randomnes, certain rules
	- fastnoiselite should do it
- drawing in tilemaplayer
	- easy just use set_cell
- ensuring whats in tilemaplayer is also interactable
- how to use fastnoiselite
	- inspector
	- script

Approach
- generate chunks as camera position changes
	- 0 - 960 -> 0
	- 961 - 1920 -> 1
	- -960 - -1 -> -1