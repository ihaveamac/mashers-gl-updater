# mashers's Grid Launcher Updater
This program grabs the latest version of Masher's Homebrew Launcher with grid layout. You can check it out here: https://gbatemp.net/threads/release-homebrew-launcher-with-grid-layout.397527/

This program uses a modified Lua Player Plus by Rinnegatamante to greatly reduce filesize. It is based on [this commit](https://github.com/Rinnegatamante/lpp-3ds/tree/312125395509486ddac02512a3594f8a904ebb75). The source of this is in "lpp-3ds-strip".

The "site" part is meant to download and cache the latest version and boot1.3dsx from https://github.com/mashers/3ds_hb_menu. This is done because ctrulib can't seem to download from HTTPS sites (if there is a way, tell me and I'll forward it).

This is mostly a stopgap until an updater is built into the launcher, though this is also included with the launcher when normally downloaded from GBAtemp. Some of this was quickly put together and not made to be easily changed for use in the future (it's not that hard though).

## How to use
Place "mglupdate" in the /3ds folder, or anywhere you like.

If your launcher is not at /boot.3dsx, edit config.txt to point it to the correct location.

Run the program and the program will attempt to show you the latest version available. Press A to download and apply the update. The launcher will automatically exit once the new version is in place.

## How it works
TODO: this

# License
The updater Lua script is under the MIT license. Lua Player Plus is under the GPLv3 license.
