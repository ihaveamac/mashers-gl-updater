dofile(System.currentDirectory().."/config.txt")

getstate_url = "http://ianburgwin.net/mglupdate/updatestate.php"
boot3dsx_url = "http://ianburgwin.net/mglupdate/boot1.3dsx"
-- as in README.md, https sites don't work in ctrulib, unless there's a workaround

function updateState(stype, info)
	Screen.refresh()
	Screen.clear(TOP_SCREEN)
	Screen.debugPrint(5, 5, "mashers's Grid Launcher Updater v1.15", Color.new(255, 255, 255), TOP_SCREEN)
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
		Screen.debugPrint(5, 60, "Press B to exit", Color.new(255, 255, 255), TOP_SCREEN)
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
		Screen.debugPrint(5, 25, "(DEBUG) Full result: "..info, Color.new(255, 255, 255), TOP_SCREEN)
		Screen.debugPrint(5, 45, "Press A to download & update", Color.new(255, 255, 255), TOP_SCREEN)
		Screen.debugPrint(5, 60, "Press B to exit", Color.new(255, 255, 255), TOP_SCREEN)
		Screen.flip()
		while true do
			local pad = Controls.read()
			if Controls.check(pad, KEY_B) then exit()
			elseif Controls.check(pad, KEY_A) then return end
		end
	elseif stype == "errorversion" then
		Screen.debugPrint(5, 25, "Do you want to update?", Color.new(255, 255, 255), TOP_SCREEN)
		Screen.debugPrint(5, 45, "Press A to download & update", Color.new(255, 255, 255), TOP_SCREEN)
		Screen.debugPrint(5, 60, "Press B to exit", Color.new(255, 255, 255), TOP_SCREEN)
		Screen.flip()
		while true do
			local pad = Controls.read()
			if Controls.check(pad, KEY_B) then exit()
			elseif Controls.check(pad, KEY_A) then return end
		end
	elseif stype == "downloading" then
		Screen.debugPrint(5, 25, "Downloading, sit tight", Color.new(255, 255, 255), TOP_SCREEN)
		Screen.flip()
	elseif stype == "done" then
		Screen.debugPrint(5, 25, "All done!", Color.new(255, 255, 255), TOP_SCREEN)
		Screen.debugPrint(5, 45, "Press B to exit", Color.new(255, 255, 255), TOP_SCREEN)
		Screen.flip()
		while true do
			if Controls.check(Controls.read(), KEY_B) then
				exit()
			end
		end
	end
end

function exit()
	if not Controls.check(Controls.read(), KEY_ZL) then -- hold ZL to keep the temporary files
		System.deleteFile(System.currentDirectory().."/tmp/state")
		System.deleteDirectory(System.currentDirectory().."/tmp")
	end
	System.exit()
end

-- READY:#define currentversion XX
-- string.sub 29               ^
-- this includes the space. this is intended.

Screen.waitVblankStart()
updateState("gettingver")

System.createDirectory(System.currentDirectory().."/tmp")
fullstate = "error error error error error<error>" -- substring would get <error> if something weird happened
function getServerState()
	status, err = pcall(function()
		System.deleteFile(System.currentDirectory().."/tmp/state")
		-- Network.requestString did not seem to work properly.
		Network.downloadFile(getstate_url, System.currentDirectory().."/tmp/state")
		local tmp_s = io.open(System.currentDirectory().."/tmp/state", FREAD)
		fullstate = io.read(tmp_s, 0, io.size(tmp_s))
		io.close(tmp_s)
	end)
	if not status then
		updateState("noconnection", err)
	end
end
getServerState()

if state == "DOWNLOADING" then
	-- expects the boot.3dsx to be cached on the server quickly. normally won't take more than 1-2 seconds
	updateState("cacheupdating")
	ti = Timer.new()
	Timer.resume(ti)
	while Timer.getTime(ti) <= 3000 do end
	Timer.destroy(ti)
	getServerState()
end
if Controls.check(Controls.read(), KEY_R) then
	updateState("showversion", fullstate)
else
	updateState("errorversion")
end
updateState("downloading")
Network.downloadFile(boot3dsx_url, System.currentDirectory().."/tmp/boot1.3dsx")
System.deleteFile(boot3dsx_location)
System.renameFile(System.currentDirectory().."/tmp/boot1.3dsx", boot3dsx_location)
updateState("done")
