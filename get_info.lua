#! /usr/bin/env lua
-- Get information about playing file

local msg = require 'mp.msg'
local utils = require 'mp.utils'

function get_info()
    msg.info ("Showing info")

    working_directory    = mp.get_property("working-directory")
    path = mp.get_property("path")
    filename_noext = mp.get_property("filename/no-ext")

    -- https://mpv.io/manual/stable/#lua-scripting-utils-join-path(p1,-p2)
    -- if p2 itself is absoulte returns p2
    abs_path = utils.join_path (working_directory , path)

    msg.verbose ("working_directory: " .. working_directory)
    msg.verbose ("path: " .. path)
    msg.verbose ("abs_path: " .. abs_path)
    msg.verbose ("filename_noext: " .. filename_noext)

    filename_noext = string.gsub(filename_noext,"_"," ")

    -- %w : alphanumerical letters
    -- [%w_] : alphanumerical letters plus underscore
    -- Escape with %- and %( 
    -- abs_path = "/media/Saja/New/Youtube/201809/(20180901)-Improvement_Pill-4_TYPES_Of_Books_You_HAVE_To_Read-(hmi39SnIEVc).mp4"
    _,_, parent_parent_dir, parent_dir  = string.find(abs_path,".*/([%w_]+)/([%w_]+)/.*$")
    -- filename_noext = "(date)-channel-tilte-(id)"
    -- (20180901)-Improvement_Pill-4_TYPES_Of_Books_You_HAVE_To_Read-(hmi39SnIEVc)
    --   date, channel, title, yt_id = string.find(filename_noext,"%(date%)%-(ch)%-(ti)%-%(ytid%)$")
    _,_, date, channel, title, yt_id = string.find(filename_noext,"%((.*)%)%-(.*)%-(.*)%-%((.*)%)$")

    if yt_id then
        msg.verbose ("filename_noext: " .. filename_noext)
        msg.verbose ("abs_path:  " .. abs_path)
        msg.verbose ("parent_parent_dir : " .. parent_parent_dir )
        msg.verbose ("date: " .. date)
        msg.verbose ("channel: " .. channel)
        msg.verbose ("title: " .. title)
        msg.verbose ("yt_id: " .. yt_id)

        msg.info ("\"https://www.youtube.com/watch?v="  .. yt_id .. "\"")

        mp.osd_message("\t" ..  parent_parent_dir .. "-> " .. parent_dir .. "\n" ..
                       "\t" .. "Channel: " ..  channel .. "\n" ..
                       "\t" .. "Title: "   ..  title .. "\n" ..
                       "\t" .. "date:  "   .. date .. "\n" 
                        , 4)
        mp.set_property( "force-media-title" , channel .. " - " .. title )
        -- mp.set_property( "screenshot-template" , "%#02n-%{media-title}")

    else

        msg.verbose ( "Not a Youtube file")
        media_title = mp.get_property("media-title")
        media_title = string.gsub(media_title ,"_"," ")
        msg.verbose ("media_title: " .. media_title)
        mp.osd_message( parent_parent_dir .. "-> " .. parent_dir .. "\n"
                        .. "Title:  " .. filename_noext  , 4 )
    end
end

mp.register_event("start-file", get_info )
mp.add_forced_key_binding("i", "get_info", get_info)
