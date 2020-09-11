--[[
    Author: Andrew Kent (KentOPSki)
    Email: contact@andrewkent.me
    Last Update: 11-09-2020
    Description: This was done as a learning exercise to teach myself the LUA syntax using ComputerCraft and generally to have a bit of fun.
                 Feel free to use this script as you like, all I ask is for you to please keep this header in place for tracking purposes.
                 If you modify it then add your name next to mine at the top, if you like drop me an email showing me what you improved, I love that sort of thing!
--]]

--[[
    import statements
--]]
os.loadAPI("common")

--[[
    argument handling
--]]
local args = {...}
local givenTask = (args[1] and args[1] or '') 
local givenDirectory = (args[2] and args[2] or '')

--[[
    localised variables
--]]
local title = 'Backup Creator'
local version = 'v0.0.3'
local driveSide = common.findDrive()

--[[
    state functions
--]]
local function backup()
	common.colorMessage(colors.white, 'Beginning backup operation...')
    if (fs.exists(givenDirectory)) then
        common.writeToDisk(givenDirectory)
        common.labelDisk('backup')
    else
        common.colorMessage(colors.red, 'Directory not found!\nPlease specify an existing directory.')
    end
end

local function startup()
    common.colorMessage(colors.yellow, title..' '..version)
end

local function shutdown()
    sleep(1)
    write('Terminating ')
    term.setTextColor(colors.yellow)
    write(title..' '..version..'\n')
    term.setTextColor(colors.white)
    sleep(1)
end

--[[
    task functions
--]]
local function start()
    -- check if the disk drive is connected
    if driveSide then
        -- check if the item in the disk drive is a floppy disk
        if disk.hasData(driveSide) then
            -- check if the floppy disk is empty, if not prompt the user to format
            if (fs.list(disk.getMountPath(driveSide)) == 0) then
                backup()
            else
                common.colorMessage(colors.white, 'The disk inserted already contains data.')
                local promptToFormat = common.polarPrompt('Will you format '..disk.getLabel(driveSide)..'?')
                if (promptToFormat == true) then
                    common.formatDisk()
                    backup()
                elseif (promptToFormat == false) then
                    common.colorMessage(colors.red, 'Backup operation cancelled!')
                end
            end
        else
            common.colorMessage(colors.red, 'No disk inserted!\nPlease insert a disk to continue.')
        end
	end
end

local function restore()
	-- todo
end

-- startup
startup()

-- handle user task
if (givenTask == 'start') then
    start()
elseif (givenTask == 'restore') then
    restore()
else
    common.colorMessage(colors.red, 'Command not recognised!')    
end

-- shutdown
shutdown()