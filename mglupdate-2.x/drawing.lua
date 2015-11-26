-- print to screen
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
    Console.append(co, "\n\n\n\n\n\n\nError details:\n\n"..err)
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
    if vp[2] ~= "%NOVERSION%" then
        print(5, 5, "Grid Launcher Update - Installed: "..vp[2], Color.new(127, 127, 255))
        print(5, 5, "Grid Launcher Update - Installed: ", Color.new(127, 127, 127))
    end
    print(5, 5, "Grid Launcher Update")
    printb(5, 5, "updater "..version, Color.new(127, 127, 127))
    printb(5, 25, "grid launcher by mashers", Color.new(127, 127, 127))
    printb(10, 40, "gbatemp.net/threads/397527/", Color.new(127, 127, 127))
    printb(5, 60, "updater by ihaveamac", Color.new(127, 127, 127))
    printb(10, 75, "ianburgwin.net/mglupdate", Color.new(127, 127, 127))
end

-- update information on screen
lastState = ""
function updateState(stype, info)
    drawMainInfo()

    -- getting latest information
    if stype == "prepare" or stype == "cacheupdating" then
        drawLine(Color.new(0, 0, 255))
        print(5, 25, "Please wait a moment.")
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
        printb(10, 40, "gbatemp.net/threads/397527/", Color.new(255, 127, 127))
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
        print(5, 200, "L+X: reboot")
        printb(10, 75, "ianburgwin.net/mglupdate", Color.new(255, 127, 127))
        displayError(info)
        Screen.flip()
        while true do
            if Controls.check(Controls.read(), KEY_Y) then
                exit(true)
                System.exit()
            elseif Controls.check(Controls.read(), KEY_L) and Controls.check(Controls.read(), KEY_X) then
                exit(true)
                Screen.refresh()
                -- strange workaround for what I think is double buffering
                Screen.fillRect(0, 399, 0, 239, Color.new(0, 0, 0), TOP_SCREEN)
                Screen.fillRect(0, 319, 0, 239, Color.new(0, 0, 0), BOTTOM_SCREEN)
                print(5, 200, "L+X: rebooting, see you soon!", Color.new(0, 127, 0))
                Screen.flip()
                System.reboot()
            end
        end

        -- show version and other information
    elseif stype == "showversion" then
        drawLine(Color.new(85, 85, 255))
        -- crappy workaround to highlight specific words
        print(5, 25, "The latest version is "..info..".", Color.new(127, 127, 255))
        print(5, 25, "The latest version is")
        print(5, 45, "The grid launcher's location is:")
        print(5, 60, vp[1], Color.new(127, 127, 255))
        print(5, 80, "The updater will also be updated at:")
        print(5, 95, "/gridlauncher/update")
        print(5, 135, "A: download and install")
        print(5, 150, "B: exit")
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
        print(5, 115, "Y: exit")
        Screen.flip()
        while true do
            if Controls.check(Controls.read(), KEY_Y) then
                exit()
            end
        end

        -- the end!!!
    end
end
