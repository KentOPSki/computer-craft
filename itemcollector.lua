--[[
    Author: Andrew Kent (KentOPSki)
    Email: contact@andrewkent.me
    Last Update: 12-12-2020
    Description: This was done as a learning exercise to teach myself the LUA syntax using ComputerCraft and generally to have a bit of fun.
                 Feel free to use this script as you like, all I ask is for you to please keep this header in place for tracking purposes.
                 If you modify it then add your name next to mine at the top, if you like drop me an email showing me what you improved, I love that sort of thing!
--]]

local modules = peripheral.find("manipulator")
if not modules then error("Must have a manipulator", 0) end
if not modules.hasModule("plethora:introspection") then error("The introspection module is missing", 0) end
 
local inventory = modules.getInventory()
local chest = peripheral.wrap("bottom")
 
while true do
  for slot, item in pairs(inventory.list()) do
    if item["name"] == "minecraft:dirt" then
      inventory.pushItems(peripheral.getName(chest), slot)
    end
  end
 
  sleep(5)
end