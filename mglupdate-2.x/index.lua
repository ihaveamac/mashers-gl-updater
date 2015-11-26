--ihaveamac--
-- updater issues go to https://github.com/ihaveamac/mashers-gl-updater/issues
-- licensed under the MIT license: https://github.com/ihaveamac/mashers-gl-updater/blob/master/LICENSE.md
version = "2.05"

-- site urls
getstate_url = "http://ianburgwin.net/mglupdate-2/updatestate.php"
versionh_url = "http://ianburgwin.net/mglupdate-2/version.h"
launcherzip_url = "http://ianburgwin.net/mglupdate-2/launcher.zip"

-- launcher information
-- vp[1] = launcher location
-- vp[2] = launcher version
vp = {"/boot.3dsx", "%NOVERSION%"}
if System.doesFileExist("/gridlauncher/glinfo.txt") then
	local gli_file = io.open("/gridlauncher/glinfo.txt", FREAD) -- format: "sdmc:/boot1.3dsx|76"
	local gli = {}
	for v in string.gmatch(io.read(gli_file, 0, io.size(gli_file)), '([^|]+)') do
		table.insert(gli, v)
	end
	vp[1] = gli[1]:sub(6)
	vp[2] = gli[2]:sub(1, gli[2]:len() - 1)
end

-- exit - hold L to keep the temporary files
function exit(noErr)
	if not Controls.check(Controls.read(), KEY_L) then
		deleteDirContents("/mgl_temp")
		System.deleteDirectory("/mgl_temp")
	end
	if not noErr then
		-- prevents a second error from showing when there's already an error
		error("%EXIT%")
	end
end

-- delete directory contents (custom function)
function deleteDirContents(dir)
	local cont = System.listDirectory(dir)
	for _, v in pairs(cont) do
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
function displayError(err)
	local co = Console.new(BOTTOM_SCREEN)
	Console.append(co, "\n\n\n\n\nError details:\n\n"..err)
	Console.show(co)
end
function drawLine(clr)
	Screen.fillEmptyRect(6, 393, 17, 18, clr, TOP_SCREEN)
end

-- credits
function drawMainInfo()
	Screen.refresh()
	Screen.clear(TOP_SCREEN)
	Screen.clear(BOTTOM_SCREEN)
	print(5, 5, "Grid Launcher Update v"..version, Color.new(63, 63, 63))
	print(5, 5, "Grid Launcher Update")
	printb(5, 5, "grid launcher by mashers", Color.new(127, 127, 127))
	printb(10, 20, "gbatemp.net/threads/397527/", Color.new(127, 127, 127))
	printb(5, 40, "updater by ihaveamac", Color.new(127, 127, 127))
	printb(10, 55, "ianburgwin.net/mglupdate", Color.new(127, 127, 127))
end

-- update information on screen
lastState = ""
function updateState(stype, info)
	drawMainInfo()
	
	-- getting latest information
	if stype == "prepare" or stype == "cacheupdating" then
		drawLine(Color.new(0, 0, 255))
		print(5, 25, "Please wait a moment.")
		if vp[2] ~= "%NOVERSION%" then
			print(5, 40, "You have "..vp[2]..".", Color.new(127, 127, 255))
			print(5, 40, "You have")
		end
		Screen.flip()
	
	-- failed to get info, usually bad internet connection
	elseif stype == "noconnection" then
		drawLine(Color.new(255, 0, 0))
		print(5, 25, "Couldn't get the latest version!", Color.new(255, 127, 127))
		print(5, 40, "Check your connection to the Internet.")
		print(5, 60, "If this problem persists, you might need to")
		print(5, 75, "manually replace this updater.")
		print(5, 115, "Y: exit")
		displayError(info)
		Screen.flip()
		while true do
			if Controls.check(Controls.read(), KEY_Y) then
				exit()
			end
		end
	
	-- updater is disabled usually due to bad version pushed
	elseif stype == "disabled" then
		drawLine(Color.new(255, 0, 0))
		print(5, 25, "The updater has been temporarily disabled.", Color.new(255, 127, 127))
		print(5, 45, "This might be because a bad version was")
		print(5, 60, "accidentally pushed out, and would cause")
		print(5, 75, "problems launching homebrew.")
		print(5, 95, "Please try again later.")
		print(5, 115, "More information might be on the GBAtemp")
		print(5, 130, "thread on the bottom screen.")
		print(5, 170, "Y: exit")
		printb(10, 20, "gbatemp.net/threads/397527/", Color.new(255, 127, 127))
		displayError(info)
		Screen.flip()
		while true do
			if Controls.check(Controls.read(), KEY_Y) then
				exit()
			end
		end

	-- updater is disabled usually due to bad version pushed
	elseif stype == "error" then
		drawLine(Color.new(255, 0, 0))
		print(5, 25, "An error has occured.", Color.new(255, 127, 127))
		print(5, 40, "Please check the bottom screen.")
		print(5, 60, "If the problem is related to ZIP extraction,")
		print(5, 75, "try running the updater again.")
		print(5, 95, "If it happens again, reboot your system.")
		print(5, 115, "If neither work, please go to the mglupdate")
		print(5, 130, "page and post the error on the bottom")
		print(5, 145, "screen.")
		print(5, 185, "Y: exit")
		printb(10, 55, "ianburgwin.net/mglupdate", Color.new(255, 127, 127))
		displayError(info)
		Screen.flip()
		while true do
			if Controls.check(Controls.read(), KEY_Y) then
				exit(true)
				System.exit()
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
		print(5, 95, "The updater will also be updated at:")
		print(5, 110, "/gridlauncher/update")
		print(5, 150, "A: download and install")
		print(5, 165, "B: exit")
		Screen.flip()
		while true do
			local pad = Controls.read()
			if Controls.check(pad, KEY_B) then exit()
			elseif Controls.check(pad, KEY_A) then return end
		end
	
	-- show version and other information if glinfo.txt is missing
	elseif stype == "showversion-noinstall" then
		drawLine(Color.new(85, 85, 255))
		-- crappy workaround to highlight specific words
		print(5, 25, "The latest version is "..info..".", Color.new(127, 127, 255))
		print(5, 25, "The latest version is")
		print(5, 45, "You are missing /gridlauncher/glinfo.txt.")
		print(5, 65, "This might be because you are not using the")
		print(5, 80, "grid launcher yet, and are using this")
		print(5, 95, "program to install it.")
		print(5, 115, "The grid launcher will be installed to:")
		print(5, 130, vp[1], Color.new(127, 127, 255))
		print(5, 150, "The updater will also be updated at:")
		print(5, 165, "/gridlauncher/update")
		print(5, 205, "A: download and install")
		print(5, 220, "B: exit")
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

	-- prevent the program from automatically continuing if I make a mistake
	else
		drawLine(Color.new(255, 0, 0))
		print(5, 25, "uh...")
		print(5, 40, "If you are reading this on your 3DS,")
		print(5, 55, "tell ihaveamac on GitHub.")
		print(5, 75, "Note this: "..lastState)
		Screen.flip()
		while true do
			if Controls.check(Controls.read(), KEY_B) then
				exit()
			end
		end
	
	-- the end!!!
	end
end

Screen.waitVblankStart()

-- error handling so cleanup can still happen
status, err = pcall(function()
	-- show preparing
	updateState("prepare")
	System.createDirectory("/mgl_temp")

	-- check network connection and trigger actions on the server
	local n_status, n_err = pcall(function()
		Network.requestString(getstate_url)
	end)
	if not n_status then
		if n_err:sub(-3) == "404" then
			updateState("disabled", n_err)
			-- trying to forcibly enable the updater is not a good idea
			-- because you will most likely download a broken grid launcher
		else
			updateState("noconnection", n_err)
		end
	end

	-- get state of the server (if still downloading to cache the latest file)
	local state = ""
	local function getServerState()
		state = Network.requestString(versionh_url)
	end
	getServerState()

	-- if the server is still caching
	if fullstate == "notready" then
		-- expects launcher.zip to be cached on the server quickly. normally won't take more than 1-2 seconds
		updateState("cacheupdating")
		local ti = Timer.new()
		Timer.resume(ti)
		while Timer.getTime(ti) <= 3000 do end
		Timer.destroy(ti)
		getServerState()
	end

	-- display version information
	if vp[2] == "%NOVERSION%" then
		updateState("showversion-noinstall", state:sub(24))
	else
		updateState("showversion", state:sub(24))
	end

	-- download launcher.zip
	updateState("downloading", state:sub(24))
	System.deleteFile("/mgl_temp/launcher.zip")
	Network.downloadFile(launcherzip_url, "/mgl_temp/launcher.zip")

	-- extract launcher.zip
	updateState("extracting", state:sub(24))
	System.extractZIP("/mgl_temp/launcher.zip", "/mgl_temp")

	-- install the files
	updateState("installing", state:sub(24))
	System.createDirectory("/gridlauncher/update")
	deleteDirContents("/gridlauncher/update")
	local new_update = System.listDirectory("/mgl_temp/gridlauncher/update")
	for _, v in pairs(new_update) do
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
end)
if not status then
	if err:sub(-6) == "%EXIT%" then
		System.exit()
	else
		updateState("error", err)
	end
end