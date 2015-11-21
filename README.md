# mashers's Grid Launcher Updater
This program downloads the latest version of mashers's Homebrew Launcher with grid layout. You can check it out here: https://gbatemp.net/threads/release-homebrew-launcher-with-grid-layout.397527/

This program uses a modified Lua Player Plus by Rinnegatamante, removing non-essential features to greatly reduce filesize. It is based on [this commit](https://github.com/Rinnegatamante/lpp-3ds/tree/312125395509486ddac02512a3594f8a904ebb75). The source of this is in "lpp-3ds-strip".

The "site" part is meant to download and cache the last version number and launcher.zip from https://github.com/mashers/3ds_hb_menu. This is done because ctrulib can't download from HTTPS sites right now (if there is a way, tell me and I'll forward it).

Some of this was quickly put together and not made to be easily changed for use in the future (it's not that hard though). The server-side code could definitely be optimized in some way, but it fits the purpose for the time being.

## How to use
This updater can be added to the grid launcher's settings menu by placing mglupdate.3dsx, config.txt, and index.lua all in /gridlauncher/update

Otherwise, extract it any place you like (e.g. /3ds/mglupdate)

If your launcher is not at /boot.3dsx, edit config.txt to point it to the correct location.

Run the program and the program will attempt to show you the latest version available. Press A to download and apply the update. The launcher will automatically exit once the new version is in place.

# License
The index.lua script is under the MIT license. Lua Player Plus is under the GPLv3 license.
