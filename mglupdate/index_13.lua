-- https://github.com/ihaveamac/mashers-gl-updater

vp_file = io.open("/gridlauncher/glinfo.txt", FREAD)
-- format: "sdmc:/boot1.3dsx|76"
vp = {}
-- vp[1] = launcher location
-- vp[2] = launcher version
for v in string.gmatch(io.read(vp_file, 0, io.size(vp_file)), '([^|]+)') do
	table.insert(vp, v)
end

getstate_url = "http://ianburgwin.net/mglupdate/updatestate.php"
versioninfo_url = "http://ianburgwin.net/mglupdate/version_info"
boot3dsx_url = "http://ianburgwin.net/mglupdate/boot1.3dsx"
-- as in README.md, https sites don't work in ctrulib, unless there's a workaround, then nothing in "site" would be necessary

function updateState(stype, info, info2)
	Screen.refresh()
	Screen.clear(TOP_SCREEN)
	Screen.debugPrint(5, 5, "mashers's Grid Launcher Updater v1.31", Color.new(255, 255, 255), TOP_SCREEN)
	Screen.fillEmptyRect(0,399,17,18,Color.new(155, 240, 255), TOP_SCREEN)
	if stype == "gettingver" then
		Screen.debugPrint(5, 25, "Checking version...", Color.new(255, 255, 255), TOP_SCREEN)
		Screen.debugPrint(5, 45, "You have beta "..vp[2], Color.new(255, 255, 255), TOP_SCREEN)
		Screen.flip()
	elseif stype == "gettingver" then
		Screen.debugPrint(5, 25, "The server is busy - waiting", Color.new(255, 255, 255), TOP_SCREEN)
		Screen.flip()
	elseif stype == "noconnection" then
		Screen.debugPrint(5, 25, "Couldn't get the latest version!", Color.new(255, 255, 255), TOP_SCREEN)
		Screen.debugPrint(5, 40, "Check your connection to the Internet.", Color.new(255, 255, 255), TOP_SCREEN)
		Screen.debugPrint(5, 55, "If the problem persists, please send a message", Color.new(255, 255, 255), TOP_SCREEN)
		Screen.debugPrint(5, 70, "to ihaveamac on GBAtemp.", Color.new(255, 255, 255), TOP_SCREEN)
		Screen.debugPrint(5, 90, "A/B: exit", Color.new(255, 255, 255), TOP_SCREEN)
		co = Console.new(BOTTOM_SCREEN)
		Console.append(co, info)
		Console.show(co)
		Screen.flip()
		while true do
			if Controls.check(Controls.read(), KEY_A) or Controls.check(Controls.read(), KEY_B) then
				exit()
			end
		end
	elseif stype == "showversion" then
		Screen.debugPrint(5, 45, "You have beta "..vp[2], Color.new(255, 255, 255), TOP_SCREEN)
		Screen.debugPrint(5, 25, "The latest available is "..info.."?", Color.new(255, 255, 255), TOP_SCREEN)
		Screen.debugPrint(5, 45, "This file will be replaced:", Color.new(255, 255, 255), TOP_SCREEN)
		Screen.debugPrint(5, 60, vp[1], Color.new(255, 255, 255), TOP_SCREEN)
		Screen.debugPrint(5, 80, "If you want to change that, edit this:" , Color.new(255, 255, 255), TOP_SCREEN)
		Screen.debugPrint(5, 95, System.currentDirectory().."/config.txt" , Color.new(255, 255, 255), TOP_SCREEN)
		Screen.debugPrint(5, 115, "A: yes   B: no", Color.new(255, 255, 255), TOP_SCREEN)
		Screen.flip()
		while true do
			local pad = Controls.read()
			if Controls.check(pad, KEY_B) then exit()
			elseif Controls.check(pad, KEY_A) then return end
		end
	elseif stype == "dllauncher" then
		Screen.debugPrint(5, 25, "Downloading beta "..info..", sit tight!", Color.new(255, 255, 255), TOP_SCREEN)
		Screen.flip()
	elseif stype == "dlupdater" then
		Screen.debugPrint(5, 25, "Downloading updater "..info..", sit tight!", Color.new(255, 255, 255), TOP_SCREEN)
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

-- hold ZL to keep the temporary files
function exit()
	if not Controls.check(Controls.read(), KEY_ZL) then
		System.deleteDirectory(System.currentDirectory().."/tmp")
	end
	System.exit()
end

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
function getServerState()
	rawstate = Network.requestString(versioninfo_url)
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

-- separate by |
state = {}
for v in string.gmatch(rawstate, '([^|]+)') do
	table.insert(state, v)
end

action = updateState("showversion", sstate, vp[2])
if action == 1 or action == 3 then
	updateState("dllauncher", sstate)
	Network.downloadFile(boot3dsx_url, System.currentDirectory().."/tmp/boot1.3dsx")
	System.deleteFile(vp[1])
	System.renameFile(System.currentDirectory().."/tmp/boot1.3dsx", vp[1])
end
if action == 2 or action == 3 then
	updateState("dlupdater", sstate, vp[2])
	Network.downloadFile(boot3dsx_url, System.currentDirectory().."/tmp/boot1.3dsx")
	System.deleteFile(vp[1])
	System.renameFile(System.currentDirectory().."/tmp/boot1.3dsx", vp[1])
end
updateState("done")
