# mashers's Grid Launcher Updater
This program grabs the latest version of mashers's Homebrew Launcher with grid layout. You can check it out here: https://gbatemp.net/threads/release-homebrew-launcher-with-grid-layout.397527/

This program uses a modified Lua Player Plus by Rinnegatamante to greatly reduce filesize. It is based on [this commit](https://github.com/Rinnegatamante/lpp-3ds/tree/312125395509486ddac02512a3594f8a904ebb75). The source of this is in "lpp-3ds-strip".

The "site" part is meant to download and cache the latest version and boot1.3dsx from https://github.com/mashers/3ds_hb_menu. This is done because ctrulib can't seem to download from HTTPS sites (if there is a way, tell me and I'll forward it).

Some of this was quickly put together and not made to be easily changed for use in the future (it's not that hard though). The server-side code could definitely be optimized in some way, but it fits the purpose for the time being.

## How to use
This updater can be added to the grid launcher's settings menu by placing mglupdate.3dsx, config.txt, and index.lua all in /gridlauncher/update

Otherwise, extract it any place you like (e.g. /3ds/mglupdate)

If your launcher is not at /boot.3dsx, edit config.txt to point it to the correct location.

Run the program and the program will attempt to show you the latest version available. Press A to download and apply the update. The launcher will automatically exit once the new version is in place.

## How it works
* When the user opens the program, it sends a request to "getstate_url" (by default, http://ianburgwin.net/mglupdate/updatestate.php). This causes the server to check "version.h" at [this URL](https://raw.githubusercontent.com/mashers/3ds_hb_menu/master/source/version.h)
* If they match, the program will then download the contents of "versionh_url" (by default, http://ianburgwin.net/mglupdate/version.h) simply to display the version number on screen.
* If they do not match, the server will download the newest version.h and boot1.3dsx (from [this URL](https://raw.githubusercontent.com/mashers/3ds_hb_menu/master/boot1.3dsx)) and store it for downloading. Then the program continues like usual.
* The location of the cached boot1.3dsx is at "boot3dsx_url" (by default, http://ianburgwin.net/mglupdate/boot1.3dsx).

None of the server-side code would exist if there was an easy way to download content from https sites using ctrulib or something.

# License
The updater Lua script is under the MIT license. Lua Player Plus is under the GPLv3 license.
