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
vp[1] = vp[1]:sub(7)

-- exit - hold L to keep the temporary files
function exit()
	if not Controls.check(Controls.read(), KEY_L) then
		System.deleteDirectory(System.currentDirectory().."/tmp")
	end
	System.exit()
end

-- printing to screen function
function print(x, y, text)
	Screen.debugPrint(x, y, text, Color.new(255, 255, 255), TOP_SCREEN)
end
function printb(x, y, text)
	Screen.debugPrint(x, y, text, Color.new(255, 255, 255), BOTTOM_SCREEN)
end
function drawLine()
	Screen.fillEmptyRect(6,393,17,18,Color.new(155, 240, 255), TOP_SCREEN)
end

-- update information on screen
function updateState(stype, info)
	Screen.refresh()
	Screen.clear(TOP_SCREEN)
	Screen.clear(BOTTOM_SCREEN)
	print(5, 5, "Grid Launcher Updater v2.0d")
	drawLine()
	
	-- getting latest information
	if stype == "prepare" or stype == "cacheupdating" then
		print(5, 25, "Please wait a moment.")
		Screen.flip()
	
	-- failed to get info, usually bad internet connection
	elseif stype == "noconnection" then
		print(5, 25, "Couldn't get the latest version!")
		print(5, 40, "Check your connection to the Internet.")
		print(5, 60, "If this problem persists, you might need to")
		print(5, 75, "manually replace this updater.")
		print(5, 90, "github.com/ihaveamac/mashers-gl-updater")
		print(5, 110, "B: exit")
		co = Console.new(BOTTOM_SCREEN)
		Console.append(co, info)
		Console.show(co)
		Screen.flip()
		while true do
			if Controls.check(Controls.read(), KEY_B) then
				exit()
			end
		end
	
	-- show version and other information
	elseif stype == "showversion" then
		print(5, 25, "The latest version is "..info..".")
		print(5, 40, "You have "..vp[2]..".")
		print(5, 60, "The launcher will be updated at:")
		print(5, 75, vp[1]:sub(7))
		-- DEBUG
		while true do
			if Controls.check(Controls.read(), KEY_B) then
				exit()
			end
		end
	
	-- the end!!!
	end
end

-- show preparing
Screen.waitVblankStart()
updateState("prepare")
System.createDirectory(System.currentDirectory().."/tmp")

-- check network connection and trigger actions on the server
status, err = pcall(function()
	Network.requestString(getstate_url)
end)
if not status then
	updateState("noconnection", err)
end
updateState("noconnection", "worked")
fullstate = "error error error error<error>" -- substring would get <error> if something weird happened. should NEVER happen
function getServerState()
	fullstate = Network.requestString(versionh_url)
end
getServerState()
