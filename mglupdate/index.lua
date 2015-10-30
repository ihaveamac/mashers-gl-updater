dofile(System.currentDirectory().."/config.txt")

getstate_url = "http://ianburgwin.net/mglupdate/updatestate.php"
versionh_url = "http://ianburgwin.net/mglupdate/version.h"
boot3dsx_url = "http://ianburgwin.net/mglupdate/boot1.3dsx"
-- as in README.md, https sites don't work in ctrulib, unless there's a workaround, then nothing in "site" would be necessary

function updateState(stype, info)
	Screen.refresh()
	Screen.clear(TOP_SCREEN)
	Screen.debugPrint(5, 5, "mashers's Grid Launcher Updater v1.23a", Color.new(255, 255, 255), TOP_SCREEN)
	Screen.fillEmptyRect(0,399,17,18,Color.new(140, 140, 140), TOP_SCREEN)
	if stype == "gettingver" then
		Screen.debugPrint(5, 25, "Preparing", Color.new(255, 255, 255), TOP_SCREEN)
		Screen.flip()
	elseif stype == "gettingver" then
		Screen.debugPrint(5, 25, "The server is busy - waiting", Color.new(255, 255, 255), TOP_SCREEN)
		Screen.flip()
	elseif stype == "noconnection" then
		Screen.debugPrint(5, 25, "Couldn't get the latest version!", Color.new(255, 255, 255), TOP_SCREEN)
		Screen.debugPrint(5, 40, "Check your connection to the Internet.", Color.new(255, 255, 255), TOP_SCREEN)
		Screen.debugPrint(5, 60, "B: exit", Color.new(255, 255, 255), TOP_SCREEN)
		co = Console.new(BOTTOM_SCREEN)
		Console.append(co, info)
		Console.show(co)
		Screen.flip()
		while true do
			if Controls.check(Controls.read(), KEY_B) then
				exit()
			end
		end
	elseif stype == "showversion" then
		Screen.debugPrint(5, 25, "Do you want to download beta "..info.."?", Color.new(255, 255, 255), TOP_SCREEN)
		Screen.debugPrint(5, 45, "This file will be replaced:", Color.new(255, 255, 255), TOP_SCREEN)
		Screen.debugPrint(5, 60, boot3dsx_location, Color.new(255, 255, 255), TOP_SCREEN)
		Screen.debugPrint(5, 80, "If you want to change that, edit this:" , Color.new(255, 255, 255), TOP_SCREEN)
		Screen.debugPrint(5, 95, System.currentDirectory().."/config.txt" , Color.new(255, 255, 255), TOP_SCREEN)
		Screen.debugPrint(5, 115, "A: yes   B: no", Color.new(255, 255, 255), TOP_SCREEN)
		Screen.flip()
		while true do
			local pad = Controls.read()
			if Controls.check(pad, KEY_B) then exit()
			elseif Controls.check(pad, KEY_A) then return end
		end
	elseif stype == "downloading" then
		Screen.debugPrint(5, 25, "Downloading beta "..info..", sit tight!", Color.new(255, 255, 255), TOP_SCREEN)
		Screen.flip()
	elseif stype == "done" then
		Screen.debugPrint(5, 25, "All done!", Color.new(255, 255, 255), TOP_SCREEN)
		Screen.debugPrint(5, 45, "A/B: exit", Color.new(255, 255, 255), TOP_SCREEN)
		Screen.flip()
		while true do
			if Controls.check(Controls.read(), KEY_A) or Controls.check(Controls.read(), KEY_B) then
				exit()
			end
		end
	end
end

function exit()
	if not Controls.check(Controls.read(), KEY_ZL) then -- hold ZL to keep the temporary files
		System.deleteDirectory(System.currentDirectory().."/tmp")
	end
	System.exit()
end

-- #define currentversion XX
-- string.sub 24          ^

Screen.waitVblankStart()
updateState("gettingver")

-- check network connection and trigger actions on the server
status, err = pcall(function()
	Network.requestString(getstate_url)
end)
if not status then
	updateState("noconnection", err)
end

System.createDirectory(System.currentDirectory().."/tmp")
--           #define currentversion <error>
fullstate = "error error error error<error>" -- substring would get <error> if something weird happened. should NEVER happen
function getServerState()
	fullstate = Network.requestString(versionh_url)
end
getServerState()

if fullstate == "notready" then
	-- expects the boot.3dsx to be cached on the server quickly. normally won't take more than 1-2 seconds
	updateState("cacheupdating")
	ti = Timer.new()
	Timer.resume(ti)
	while Timer.getTime(ti) <= 3000 do end
	Timer.destroy(ti)
	getServerState()
end
sstate = string.sub(fullstate, 24)
updateState("showversion", sstate)
updateState("downloading", sstate)
Network.downloadFile(boot3dsx_url, System.currentDirectory().."/tmp/boot1.3dsx")
System.deleteFile(boot3dsx_location)
System.renameFile(System.currentDirectory().."/tmp/boot1.3dsx", boot3dsx_location)
-- TEMPORARY
Network.downloadFile("http://ianburgwin.net/mglupdate/index.lua", System.currentDirectory().."/tmp/index.lua")
System.deleteFile(System.currentDirectory().."/index.lua")
System.renameFile(System.currentDirectory().."/tmp/index.lua", System.currentDirectory().."/index.lua")
-- TEMPORARY
updateState("done")
