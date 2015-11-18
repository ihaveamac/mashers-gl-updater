--ihaveamac--
-- updater issues go to https://github.com/ihaveamac/another-file-manager/issues
-- licensed under the MIT license: https://github.com/ihaveamac/another-file-manager/blob/master/LICENSE.md

getstate_url = "http://ianburgwin.net/mglupdate/updatestate.php"
versionh_url = "http://ianburgwin.net/mglupdate/version.h"
boot3dsx_url = "http://ianburgwin.net/mglupdate/boot1.3dsx"
-- as in README.md, https sites don't work in ctrulib, unless there's a workaround, then nothing in "site" would be necessary

function updateState(stype, info)
	Screen.refresh()
	Screen.clear(TOP_SCREEN)
	Screen.debugPrint(5, 5, "mashers's Grid Launcher Updater v1.23", Color.new(255, 255, 255), TOP_SCREEN)
	Screen.fillEmptyRect(0,399,17,18,Color.new(140, 140, 140), TOP_SCREEN)
