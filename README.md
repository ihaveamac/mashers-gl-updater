# mashers's Grid Launcher Updater
This program grabs the latest version of Masher's Homebrew Launcher with grid layout. You can check it out here: https://gbatemp.net/threads/release-homebrew-launcher-with-grid-layout.397527/

This program uses a modified Lua Player Plus by Rinnegatamante to greatly reduce filesize. It is based on [this commit](https://github.com/Rinnegatamante/lpp-3ds/tree/312125395509486ddac02512a3594f8a904ebb75). The source of this is in "lpp-3ds-strip".

The source code of the server-side code is in "site". Most of this was to get up and running, and considering the low load the site would get, it probably is not really the best way to do things.

This could really be turned into an updater of anything. Most of this is to get around the HTTPS limitation of ctrulib (if there's a fix, tell me and I'll try to forward it appropriately).

## How to use
Place "mglupdate" in the /3ds folder, or anywhere you like.

If your launcher is not at /boot.3dsx, edit config.txt to point it to the correct location.

Run the program and the program will attempt to show you the latest version available. Press A to download and apply the update. The launcher will automatically exit once the new version is in place.

## How it works
TODO: this

# License
The updater Lua script is under the MIT license. Lua Player Plus is under the GPLv3 license.
