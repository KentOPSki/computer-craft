--[[
    Author: Andrew Kent (KentOPSki)
    Email: contact@andrewkent.me
    Last Update: 11-09-2020
    Description: This was done as a learning exercise to teach myself the LUA syntax using ComputerCraft and generally to have a bit of fun.
                 Feel free to use this script as you like, all I ask is for you to please keep this header in place for tracking purposes.
                 If you modify it then add your name next to mine at the top, if you like drop me an email showing me what you improved, I love that sort of thing!
--]]

local blacklist = {
	['disk'] = true,
	['rom'] = true
}

--[[ 
    a e s t h e t i c onscreen text
--]]
function colorMessage(color, text)
    sleep(1)
    term.setTextColor(color)
    print(text)
    term.setTextColor(colors.white)
    sleep(1)
end

--[[ 
    creates a prompt which the user must answer with a "yes" or "no"
--]]
function polarPrompt(text)
    local instruction ='\nPlease type "yes" or "no" and hit return.'
    -- display the prompt message
    colorMessage(colors.orange, text..instruction)
    -- user input
    term.setTextColor(colors.blue)
    local input = read()
    -- check if user input is valid
    if (input =='yes') or (input =='y') then
        term.setTextColor(colors.white)
        return true
    elseif (input =='no') or (input =='n') then
        term.setTextColor(colors.white)
        return false
    else
        term.setTextColor(colors.red)
        print('Input not valid.')
        -- recursively call the function until the correct input is given
        polarPrompt(instruction)
    end
end

--[[ 
    returns which side a "Disk Drive" is on, if one is present
--]]
function findDrive()
    -- iterate through all available sides from redstone API
    for index, side in pairs(rs.getSides()) do
        -- check for a peripheral connected on side and find the disk drive by checking its type
        if peripheral.isPresent(side) and peripheral.getType(side) == "drive" then
            -- define which side the drive is connected on
            return side
        end
    end
    colorMessage(colors.red, 'No disk drive found!\nPlease connect a disk drive to continue.')
    return false
end

--[[ 
    erases all data contained on any storage medium inserted into the "Disk Drive"
--]]
function formatDisk()
    -- loop through all the files on the disk
    for index, filename in pairs(fs.list('/disk/')) do
        -- delete each file / directory on the disk
		fs.delete('/disk/'..filename)
    end
    colorMessage(colors.white, 'Disk formatted.')
end

--[[ 
    writes all files / directory from the given root path to any storage medium inserted into the "Disk Drive"
--]]
function writeToDisk(path)
    -- loop through all the files in the given directory
    for index, filename in pairs(fs.list(path)) do
        -- check against the blacklist for read only files / directories
        if not blacklist[filename] then
            -- copy each file / directory to the disk
			fs.copy(path..filename, '/disk/'..filename)
			colorMessage(colors.white, 'Copied: '..filename..' to disk.')
		end
    end
    colorMessage(colors.green, 'Backup completed.')
end

--[[ 
    labels any storage medium inserted into the "Disk Drive", takes a prefix; affixed with the date and time
--]]
function labelDisk(prefix)
    local side = findDrive()
    if side then
        disk.setLabel(side, prefix..'-'..os.day()..'-'..textutils.formatTime(os.time(), true))
    end
end