--ihaveamac--
-- updater issues go to https://github.com/ihaveamac/mashers-gl-updater/issues
-- licensed under the MIT license: https://github.com/ihaveamac/mashers-gl-updater/blob/master/LICENSE.md

-- site urls
getstate_url = "http://ianburgwin.net/mglupdate-2/updatestate.php"
versionh_url = "http://ianburgwin.net/mglupdate-2/version.h"
launcher_url = "http://ianburgwin.net/mglupdate-2/launcher.zip"

-- launcher information
vp_file = io.open("/gridlauncher/glinfo.txt", FREAD) -- format: "sdmc:/boot1.3dsx|76"
vp = {}
-- vp[1] = launcher location
-- vp[2] = launcher version
for v in string.gmatch(io.read(vp_file, 0, io.size(vp_file)), '([^|]+)') do
	table.insert(vp, v)
end

-- exit - hold ZL to keep the temporary files
function exit()
	if not Controls.check(Controls.read(), KEY_ZL) then
		System.deleteDirectory(System.currentDirectory().."/tmp")
	end
	System.exit()
end

-- update information on screen
function updateState(stype, info)
	Screen.refresh()
	Screen.clear(TOP_SCREEN)
	Screen.debugPrint(5, 5, "Grid Launcher Updater v2.0d", Color.new(255, 255, 255), TOP_SCREEN)
	Screen.fillEmptyRect(6,393,17,18,Color.new(155, 240, 255), TOP_SCREEN)
	
	-- getting latest information
	if stype == "prepare" or stype == "cacheupdating" then
		Screen.debugPrint(5, 25, "Please wait a moment.", Color.new(255, 255, 255), TOP_SCREEN)
		Screen.flip()
	
	-- failed to get info, usually bad internet connection
	elseif stype == "noconnection" then
		Screen.debugPrint(5, 25, "Couldn't get the latest version!", Color.new(255, 255, 255), TOP_SCREEN)
		Screen.debugPrint(5, 40, "Check your connection to the Internet.", Color.new(255, 255, 255), TOP_SCREEN)
		Screen.debugPrint(5, 60, "If this problem persists, you might need to", Color.new(255, 255, 255), TOP_SCREEN)
		Screen.debugPrint(5, 75, "manually replace this updater.", Color.new(255, 255, 255), TOP_SCREEN)
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

-- show preparing
Screen.waitVblankStart()
updateState("prepare")

-- check network connection and trigger actions on the server
status, err = pcall(function()
	Network.requestString(getstate_url)
end)
if not status then
	updateState("noconnection", err)
end
