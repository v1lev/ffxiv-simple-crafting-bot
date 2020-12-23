# ffxiv-simple-crafting-bot

A simple crafting bot for FFXIV based on AutoIT. It was made to automate insane boring process of making precrafts.

The bot allows you to craft the same item using one or more macros. Bot can start craft and press macro buttons over and over being in background.

Usage:

1. Install [AutoIt v3](https://www.autoitscript.com/site/).
1. Set game mode to windowed.
1. Find and set the game setting to not cut framerate if window in the backgound to avoid delays, because macros depend on framerate.
1. Choose the item that you want to craft, buy mats.
1. Prepare macros, put them on a hotbar with keybindings. 
1. Make local config.ini and set proper timings and keys for your macros. Bot macro timing = sum of command timings in macro + some delay (2-3 seconds). Set time or item limit numbers as well. Time limit = food limit. Item limit = number of items you can craft.
1. Use food if needed.
1. Open crafting window, choose the desired item and all the materials (in case you want to use HQ). Make sure that NumLock is enabled and pressing Num 0 key will put cursor on a synthesize button.
1. Start bot. You can minimize game window and do whatever.
