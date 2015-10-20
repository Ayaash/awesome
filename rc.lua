-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
-- Sound library
local APW = require("apw/widget")
-- Key Documentation
require("modules/keydoc")
-- Vicious
local vicious = require("vicious")
-- Run or Raise
local ror = require("aweror")
-- Binding
local binding = require("binding")
-- Rules
local rule = require("rules")
-- Wid
local wid = require("wid")
-- Signal
local signal = require("signal")
-- Other
local other = require("other")

-- Personal variables 

-- Load Debian menu entries
require("debian.menu")
-- Load revelation
require("revelation")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

--  Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init("~/.config/awesome/powerarrowf/theme.lua")

terminal = "urxvt"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor
browser = "firefox"

wp_timeout = 600
wp_path = "/home/ayaash/Images/Backgrounds/"
wp_files = {}
for f in io.popen("ls "..wp_path):lines() do
	table.insert(wp_files, f)
end

wp_timer = timer { timeout = 0 }
wp_index = math.random( 1, #wp_files)

wp_timer:connect_signal("timeout", signal.timeout)

wp_timer:start()
APWTimer = timer({ timeout = 0.5 }) -- set update interval in s
APWTimer:connect_signal("timeout", APW.Update)
APWTimer:start()

modkey = "Mod4"

font = "Terminus 12"

oneko = false
screen_left = false
touchpad = false
wicd = false

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}

-- Wallpaper
other.wallpaper()

-- Define a tag table which hold all screen tags.
tags = other.tags()

--  Menu
-- Create a laucher widget and a main menu
myawesomemenu = other.awesomemenu()

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "Debian", debian.menu.Debian_menu.Debian },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it

-- Wibox
wid.createwibox(screen)

-- Mouse bindings
root.buttons(binding.mousebinding())


-- Key bindings
globalkeys = binding.keybinding()

-- Set keys
root.keys(globalkeys)

-- Rules
awful.rules.rules = rule.globalrules()

-- Signal
client.connect_signal("manage", signal.manage)

client.connect_signal("focus", signal.focus)
client.connect_signal("unfocus", signal.unfocus)

-- User commands
other.userCommands()

-- Change gurb background for next boot
grub_wp = math.random(1, #wp_files)
other.grubWP(grub_wp)
