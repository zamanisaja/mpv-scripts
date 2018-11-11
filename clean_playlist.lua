#! /usr/bin/env lua
--

-- Removes files from this list of extensions from now playing
local msg = require 'mp.msg'

exclude_extensions =  {'srt', 'vtt', 'jpg', 'jpeg', 'png', 'nfo', }

local cleaned = nil

function clean_playlist(  )
    if (cleaned) then
        msg.verbose ("Cleaned before")
        return
    end
    print ("Cleaning playlist")
    n = tonumber (mp.get_property('playlist-count'))
    i = 0 
    while (i < n ) do
        f = mp.get_property("playlist/" .. tostring(i) .. "/filename")
        -- print ("Index is: " .. tostring(i))
        -- print ("Filename is " .. tostring(f))
        for _,ext in pairs(exclude_extensions) do
        if string.match(f,ext) then
            -- print ("Removing file " .. tostring(i) .."th : " .. f .. " from playlist")
            mp.command("playlist-remove " .. tostring(i))
            n = n-1 
            i = i-1 
        end 
        end 
        i = i + 1 
    end 

    cleaned = true
end

mp.register_event("start-file", clean_playlist)
