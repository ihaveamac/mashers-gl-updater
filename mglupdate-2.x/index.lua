--ihaveamac--
-- updater issues go to https://github.com/ihaveamac/mashers-gl-updater/issues
-- licensed under the MIT license: https://github.com/ihaveamac/mashers-gl-updater/blob/master/LICENSE.md

-- site urls
getstate_url = "http://ianburgwin.net/mglupdate-2/updatestate.php"
versionh_url = "http://ianburgwin.net/mglupdate-2/version.h"
launcherzip_url = "http://ianburgwin.net/mglupdate-2/launcher.zip"

-- launcher information
vp_file = io.open("/gridlauncher/glinfo.txt", FREAD) -- format: "sdmc:/boot1.3dsx|76"
vp = {}
-- vp[1] = launcher location
-- vp[2] = launcher version
for v in string.gmatch(io.read(vp_file, 0, io.size(vp_file)), '([^|]+)') do
	table.insert(vp, v)
end
vp[1] = vp[1]:sub(6)
vp[2] = vp[2]:sub(1, vp[2]:len() - 1)

-- exit - hold L to keep the temporary files
function exit()
	if not Controls.check(Controls.read(), KEY_L) then
		deleteDirContents("/mgl_temp")
		System.deleteDirectory("/mgl_temp")
	end
	System.exit()
end

-- delete directory contents (custom function)
function deleteDirContents(dir)
	local cont = System.listDirectory(dir)
	for k, v in pairs(cont) do
		if v.directory then
			deleteDirContents(dir.."/"..v.name)
			System.deleteDirectory(dir.."/"..v.name)
		else
			System.deleteFile(dir.."/"..v.name)
		end
	end
end

-- printing to screen function
function print(x, y, text, clr)
	if not clr then
		clr = Color.new(255, 255, 255)
	end
	Screen.debugPrint(x, y, text, clr, TOP_SCREEN)
end
function printb(x, y, text, clr)
	if not clr then
		clr = Color.new(255, 255, 255)
	end
	Screen.debugPrint(x, y, text, clr, BOTTOM_SCREEN)
end
function drawLine(clr)
	Screen.fillEmptyRect(6, 393, 17, 18, clr, TOP_SCREEN)
end

-- credits
function drawCredits()
	printb(5, 40, "grid launcher by mashers", Color.new(127, 127, 127))
	printb(10, 55, "gbatemp.net/threads/397527/", Color.new(127, 127, 127))
	printb(5, 5, "updater by ihaveamac", Color.new(127, 127, 127))
	printb(10, 20, "ianburgwin.net/mglupdate", Color.new(127, 127, 127))
end

-- update information on screen
function updateState(stype, info)
	Screen.refresh()
	Screen.clear(TOP_SCREEN)
	Screen.clear(BOTTOM_SCREEN)
	print(5, 5, "Grid Launcher Updater v2.02", Color.new(127, 127, 127))
	print(5, 5, "Grid Launcher Updater")
		drawCredits()
	
	-- getting latest information
	if stype == "prepare" or stype == "cacheupdating" then
		drawLine(Color.new(0, 0, 255))
		drawCredits()
		print(5, 25, "Please wait a moment.")
		print(5, 40, "You have "..vp[2]..".", Color.new(127, 127, 255))
		print(5, 40, "You have")
		Screen.flip()
	
	-- failed to get info, usually bad internet connection
	elseif stype == "noconnection" then
		drawLine(Color.new(255, 0, 0))
		drawCredits()
		print(5, 25, "Couldn't get the latest version!", Color.new(255, 127, 127))
		print(5, 40, "Check your connection to the Internet.")
		print(5, 60, "If this problem persists, you might need to")
		print(5, 75, "manually replace this updater.")
		print(5, 115, "B: exit")
		co = Console.new(BOTTOM_SCREEN)
		Console.append(co, "\n\n\n\n\n"..info)
		Console.show(co)
		Screen.flip()
		while true do
			if Controls.check(Controls.read(), KEY_B) then
				exit()
			end
		end
	
	-- show version and other information
	elseif stype == "showversion" then
		drawLine(Color.new(85, 85, 255))
		-- crappy workaround to highlight specific words
		print(5, 25, "The latest version is "..info..".", Color.new(127, 127, 255))
		print(5, 25, "The latest version is")
		print(5, 40, "You have "..vp[2]..".", Color.new(127, 127, 255))
		print(5, 40, "You have")
		print(5, 60, "The grid launcher's location is:")
		print(5, 75, vp[1], Color.new(127, 127, 255))
		print(5, 95, "If available, the updater will also be")
		print(5, 110, "updated at /gridlauncher/update.")
		print(5, 150, "A: download and install")
		print(5, 165, "B: exit")
		Screen.flip()
		while true do
			local pad = Controls.read()
			if Controls.check(pad, KEY_B) then exit()
			elseif Controls.check(pad, KEY_A) then return end
		end
	
	-- downloading launcher.zip
	elseif stype == "downloading" then
		drawLine(Color.new(127, 255, 127))
		print(5, 25, "-> Downloading "..info..", be patient!")
		print(5, 40, "    Extracting, sit tight!", Color.new(127, 127, 127))
		print(5, 55, "    Installing, this doesn't take long!", Color.new(127, 127, 127))
		print(5, 70, "    Done!", Color.new(127, 127, 127))
		print(5, 110, "Do not turn off the power.")
		Screen.flip()
	
	-- now comes the extraction
	elseif stype == "extracting" then
		drawLine(Color.new(127, 255, 127))
		print(5, 25, "    Downloading "..info..", be patient!", Color.new(127, 127, 127))
		print(5, 40, "-> Extracting, sit tight!")
		print(5, 55, "    Installing, this doesn't take long!", Color.new(127, 127, 127))
		print(5, 70, "    Done!", Color.new(127, 127, 127))
		print(5, 110, "Do not turn off the power.")
		Screen.flip()
	
	-- now comes the extraction
	elseif stype == "installing" then
		drawLine(Color.new(127, 255, 127))
		print(5, 25, "    Downloading "..info..", be patient!", Color.new(127, 127, 127))
		print(5, 40, "    Extracting, sit tight!", Color.new(127, 127, 127))
		print(5, 55, "-> Installing, this doesn't take long!")
		print(5, 70, "    Done!", Color.new(127, 127, 127))
		print(5, 110, "Do not turn off the power.")
		Screen.flip()
	
	-- and we're all done
	elseif stype == "done" then
		drawLine(Color.new(0, 255, 0))
		print(5, 25, "    Downloading "..info..", be patient!", Color.new(127, 127, 127))
		print(5, 40, "    Extracting, sit tight!", Color.new(127, 127, 127))
		print(5, 55, "    Installing, this doesn't take long!", Color.new(127, 127, 127))
		print(5, 70, "-> Done!", Color.new(127, 255, 127))
		print(5, 70, "->")
		print(5, 110, "A/B: exit")
		Screen.flip()
		while true do
			if Controls.check(Controls.read(), KEY_A) or Controls.check(Controls.read(), KEY_B) then
				exit()
			end
		end
	
	-- the end!!!
	end
end

-- show preparing
Screen.waitVblankStart()
updateState("prepare")
System.createDirectory("/mgl_temp")

-- check network connection and trigger actions on the server
status, err = pcall(function()
	Network.requestString(getstate_url)
end)
if not status then
	updateState("noconnection", err)
end

-- get state of the server (if still downloading to cache the latest file)
state = ""
function getServerState()
	state = Network.requestString(versionh_url)
end
getServerState()

-- if the server is still caching
if fullstate == "notready" then
	-- expects launcher.zip to be cached on the server quickly. normally won't take more than 1-2 seconds
	updateState("cacheupdating")
	ti = Timer.new()
	Timer.resume(ti)
	while Timer.getTime(ti) <= 3000 do end
	Timer.destroy(ti)
	getServerState()
end

-- display version information
updateState("showversion", state:sub(24))

-- download launcher.zip
updateState("downloading", state:sub(24))
Network.downloadFile(launcherzip_url, "/mgl_temp/launcher.zip")

-- extract launcher.zip
updateState("extracting", state:sub(24))
System.extractZIP("/mgl_temp/launcher.zip", "/mgl_temp")

-- install the files
updateState("installing", state:sub(24))
System.createDirectory("/gridlauncher/update")
deleteDirContents("/gridlauncher/update")
new_update = System.listDirectory("/mgl_temp/gridlauncher/update")
for k, v in pairs(new_update) do
	if v.directory then
		System.renameDirectory("/mgl_temp/gridlauncher/update/"..v.name, "/gridlauncher/update/"..v.name)
	else
		System.renameFile("/mgl_temp/gridlauncher/update/"..v.name, "/gridlauncher/update/"..v.name)
	end
end
System.deleteFile(vp[1])
System.renameFile("/mgl_temp/boot.3dsx", vp[1])

-- done!
updateState("done", state:sub(24))
