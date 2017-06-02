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

-- user commands run during start
function other.userCommands()
	awful.util.spawn_with_shell("xcompmgr -C -f -D 3")
	awful.util.spawn_with_shell("xset -b")
	awful.util.spawn_with_shell("syncleint TapButton1=1")
	awful.util.spawn_with_shell('~/.config/awesome/locker')
	awful.util.spawn_with_shell("numlockx on")
	awful.util.spawn_with_shell("synclient TouchpadOff=1")
end

terminal = "urxvt"

-- Wallpaper
function other.wallpaper()
	if beautiful.wallpaper then
		for s = 1, screen.count() do
			gears.wallpaper.maximized(beautiful.wallpaper, s, true)
		end
	end
end

-- Define a tag table which hold all screen tags.
function other.tags()
	local tags = {}
	for s = 1, screen.count() do
		-- Each screen has its own tag table.
		tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[1])
	end
	return tags
end

function other.awesomemenu()
	myawesomemenu = {
		{ "manual", terminal .. " -e man awesome" },
		{ "edit config", editor_cmd .. " " .. awesome.conffile },
		{ "restart", awesome.restart },
		{ "quit", awesome.quit }
	}
	return myawesomemenu
end

function other.grubWP(grub_WP)
	if string.sub(wp_files[grub_wp], -3) ~= "png" then
		awful.util.spawn_with_shell("convert "..wp_path..wp_files[grub_wp].." /boot/grub/themes/starfield/starfield.png")
	else
		awful.util.spawn_with_shell("cp "..wp_path..wp_files[grub_wp].." /boot/grub/themes/starfield/starfield.png")
	end
end

return other
