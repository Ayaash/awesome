local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")

other = {}
local layouts = 
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

function other.userCommands()
	-- user commands run during start
	awful.util.spawn_with_shell("xcompmgr -C")
	awful.util.spawn_with_shell('~/.config/awesome/locker')
	awful.util.spawn_with_shell("skype")
	awful.util.spawn_with_shell("pkill -9 wicd-client")
	awful.util.spawn_with_shell("wicd-gtk")
	awful.layout.inc(layouts,  1)
	awful.util.spawn_with_shell("numlockx on")
	awful.util.spawn_with_shell("synclient TouchpadOff=1")
end

function other.wallpaper()
	if beautiful.wallpaper then
		for s = 1, screen.count() do
			gears.wallpaper.maximized(beautiful.wallpaper, s, true)
		end
	end
end

return other
