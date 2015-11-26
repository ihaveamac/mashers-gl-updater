--ihaveamac--
-- updater issues go to https://github.com/ihaveamac/mashers-gl-updater/issues
-- licensed under the MIT license: https://github.com/ihaveamac/mashers-gl-updater/blob/master/LICENSE.md
version = "2.05"

-- debug info - only used during development
allow_force_error = true

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

-- since the drawing code has become big
dofile(System.currentDirectory().."/drawing.lua")

Screen.waitVblankStart()

-- error handling so cleanup can still happen
status, err = pcall(function()
	-- show preparing
	updateState("prepare")
	System.createDirectory("/mgl_temp")
	if allow_force_error and Controls.check(Controls.read(), KEY_L) then
		error("forced error")
	end

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