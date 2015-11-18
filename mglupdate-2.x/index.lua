--ihaveamac--
-- updater issues go to https://github.com/ihaveamac/mashers-gl-updater/issues
-- licensed under the MIT license: https://github.com/ihaveamac/mashers-gl-updater/blob/master/LICENSE.md

getstate_url = "http://ianburgwin.net/mglupdate-2/updatestate.php"
versionh_url = "http://ianburgwin.net/mglupdate-2/version.h"
boot3dsx_url = "http://ianburgwin.net/mglupdate-2/launcher.zip"
-- as in README.md, https sites don't work in ctrulib, unless there's a workaround, then nothing in "site" would be necessary

function updateState(stype, info)
	Screen.refresh()
	Screen.clear(TOP_SCREEN)
	Screen.debugPrint(5, 5, "Grid Launcher Updater v2.0d", Color.new(255, 255, 255), TOP_SCREEN)
	Screen.fillEmptyRect(0,399,17,18,Color.new(140, 140, 140), TOP_SCREEN)
	if stype == "preparing" or stype == "gettingver" then
		Screen.debugPrint(5, 25, "Please wait a moment.", Color.new(255, 255, 255), TOP_SCREEN)
		Screen.flip()
	elseif stype == "noconnection" then
		Screen.debugPrint(5, 25, "Couldn't get the latest version!", Color.new(255, 255, 255), TOP_SCREEN)
		Screen.debugPrint(5, 40, "Check your connection to the Internet.", Color.new(255, 255, 255), TOP_SCREEN)
		Screen.debugPrint(5, 60, "If this problem persists, there is a chance that", Color.new(255, 255, 255), TOP_SCREEN)
		Screen.debugPrint(5, 75, "this updater manually needs to be replaced.", Color.new(255, 255, 255), TOP_SCREEN)
		Screen.debugPrint(5, 95, "B: exit", Color.new(255, 255, 255), TOP_SCREEN)
		co = Console.new(BOTTOM_SCREEN)
		Console.append(co, info)
		Console.show(co)
		Screen.flip()
		while true do
			if Controls.check(Controls.read(), KEY_B) then
				exit()
			end
		end
	end
end
updateState("noconnection")
