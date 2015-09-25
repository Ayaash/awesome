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

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
-- beautiful.init("~/.config/awesome/themes/awesome-solarized/dark/theme.lua")
beautiful.init("~/.config/awesome/powerarrowf/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor
browser = "firefox"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

font = "Terminus 12"

oneko = false
screen_left = false
touchpad = false
wicd = false

-- Table of layouts to cover with awful.layout.inc, order matters.
-- }}}
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

-- {{ These are the power arrow dividers/separators }} --
arr1 = wibox.widget.imagebox()
arr1:set_image(beautiful.arr1)
rra1 = wibox.widget.imagebox()
rra1:set_image(beautiful.rra1)
arr2 = wibox.widget.imagebox()
arr2:set_image(beautiful.arr2)
rra2 = wibox.widget.imagebox()
rra2:set_image(beautiful.rra2)
arr3 = wibox.widget.imagebox()
arr3:set_image(beautiful.arr3)
rra3 = wibox.widget.imagebox()
rra3:set_image(beautiful.rra3)
arr4 = wibox.widget.imagebox()
arr4:set_image(beautiful.arr4)
rra4 = wibox.widget.imagebox()
rra4:set_image(beautiful.rra4)
arr5 = wibox.widget.imagebox()
arr5:set_image(beautiful.arr5)
arr6 = wibox.widget.imagebox()
arr6:set_image(beautiful.arr6)
arr7 = wibox.widget.imagebox()
arr7:set_image(beautiful.arr7)
arr8 = wibox.widget.imagebox()
arr8:set_image(beautiful.arr8)
arr9 = wibox.widget.imagebox()
arr9:set_image(beautiful.arr9)

-- Wallpaper
other.wallpaper()


-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[1])
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "Debian", debian.menu.Debian_menu.Debian },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibox

--{{-- Time and Date Widget }} --
tdwidget = wibox.widget.textbox()
local strf = '<span font="' .. font .. '" color="#EEEEEE" background="#777E76">%b %d %I:%M</span>'
vicious.register(tdwidget, vicious.widgets.date, strf, 20)

clockicon = wibox.widget.imagebox()
clockicon:set_image(beautiful.clock)

--{{ Net Widget }} --
netwidget = wibox.widget.textbox()
vicious.register(netwidget, vicious.widgets.net, function(widget, args)
    local interface = ""
    if args["{wlp2s0 carrier}"] == 1 then
        interface = "wlp2s0"
    elseif args["{enp3s0f2 carrier}"] == 1 then
        interface = "enp3s0f2"
    else
        return ""
    end
    return '<span background="'..beautiful.colors.violet..'" font="'..font..'"> <span font ="'..font..'" color="#FFFFFF">'..args["{"..interface.." down_kb}"]..'kbps'..'</span></span>' end, 10)

--{{ Battery Widget }} --
baticon = wibox.widget.imagebox()
baticon:set_image(beautiful.baticon)

batwidget = wibox.widget.textbox()
vicious.register( batwidget, vicious.widgets.bat, '<span background="#92B0A0" font="'..font..'"><span font="'..font..'" color="#FFFFFF" background="#92B0A0">$1$2% </span></span>', 30, "BAT0" )
--{{---| File Size widget |-----

fswidget = wibox.widget.textbox()

vicious.register(fswidget, vicious.widgets.fs,
'<span background="'..beautiful.colors.dviolet..'" font="'..font..'"> <span font="'..font..'" color="#EEEEEE">${/home used_gb}/${/home avail_gb} GB </span></span>',
800)

fsicon = wibox.widget.imagebox()
fsicon:set_image(beautiful.fsicon)

----{{--| Volume / volume icon |----------
volume = wibox.widget.textbox()
vicious.register(volume, vicious.widgets.volume,
'<span background="#4B3B51" font="'..font..'"><span font="'..font..'" color="#EEEEEE"> Vol:$1 </span></span>', 0.3, "Master")

volumeicon = wibox.widget.imagebox()
vicious.register(volumeicon, vicious.widgets.volume, function(widget, args)
    local paraone = tonumber(args[1])

    if args[2] == "♩" or paraone == 0 then
        volumeicon:set_image(beautiful.mute)
    elseif paraone >= 67 and paraone <= 100 then
        volumeicon:set_image(beautiful.volhi)
    elseif paraone >= 33 and paraone <= 66 then
        volumeicon:set_image(beautiful.volmed)
    else
        volumeicon:set_image(beautiful.vollow)
    end

end, 0.3, "Master")

--{{---| CPU / sensors widget |-----------
cpuwidget = wibox.widget.textbox()
vicious.register(cpuwidget, vicious.widgets.cpu,
'<span background="'..beautiful.colors.violet..'" font="'..font..'"> <span font="'..font..'" color="'..beautiful.colors.base03..'">$1%</span></span>', 5)

cpuicon = wibox.widget.imagebox()
cpuicon:set_image(beautiful.cpuicon)

--{{--| MEM widget |-----------------
memwidget = wibox.widget.textbox()

vicious.register(memwidget, vicious.widgets.mem, '<span background="#777E76" font="'..font..'"> <span font="'..font..'" color="#EEEEEE" background="#777E76">$1% $2MB </span></span>', 20)
memicon = wibox.widget.imagebox()
memicon:set_image(beautiful.mem)

-- Create a wibox for each screen and add it
mywiboxtop = {}
mywiboxbot = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({
                                                      theme = { width = 250 }
                                                  })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

datewidget = wibox.widget.textbox()
vicious.register(datewidget,
				 vicious.widgets.date,
				 "<span font='"..font.."' color='"..beautiful.colors.base03.."' background='"..beautiful.colors.cyan.."'>%b %d %R</span>",
				 20)

memwidget2 = wibox.widget.textbox()
vicious.register(memwidget2, vicious.widgets.mem, "<span background='"..beautiful.colors.violet.."' font='"..font.."' color='"..beautiful.colors.base03.."'>$1% ($2MB/$3MB)</span>", 13)

batterywidget = wibox.widget.textbox()
vicious.register(batterywidget, vicious.widgets.bat, "<span background='"..beautiful.colors.blue.."' font='"..font.."' color='"..beautiful.colors.base03.."'>$1$2%</span>", 10, "BAT0")

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywiboxtop[s] = awful.wibox({ position = "top", screen = s, height = "19" })
    mywiboxbot[s] = awful.wibox({ position = "bottom", screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

	-- Informative widgets
	local info = wibox.layout.fixed.horizontal()
	info:add(arr4)
	info:add(fswidget)
	info:add(fsicon)
	info:add(arr3)
	info:add(cpuwidget)
	info:add(cpuicon)
	info:add(netwidget)
	info:add(arr2)
	info:add(APW)
	info:add(arr1)
	info:add(datewidget)
	info:add(rra1)
	info:add(baticon)
    info:add(batterywidget)
	info:add(rra2)
	info:add(memicon)
	info:add(memwidget2)
	info:add(rra3)
    if s == 1 then info:add(wibox.widget.systray()) end
	info:add(rra4)

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
  	 right_layout:add(mylayoutbox[s])
	
    -- Now bring it all together (with the tasklist in the middle)
    local layouttop = wibox.layout.align.horizontal()
    layouttop:set_left(left_layout)
    layouttop:set_middle(info)
    layouttop:set_right(right_layout)

    local layoutbot = wibox.layout.align.horizontal()
    layoutbot:set_middle(mytasklist[s])

    mywiboxtop[s]:set_widget(layouttop)
    mywiboxbot[s]:set_widget(layoutbot)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(binding.mousebinding())

-- }}}

wp_timer = timer { timeout = 0 }

-- {{{ Key bindings
globalkeys = binding.keybinding()

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = rule.globalrules()
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                )

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- configuration - edit to your liking
wp_timeout = 600
wp_path = "/home/ayaash/Images/Backgrounds/"
wp_files = {}
for f in io.popen("ls "..wp_path):lines() do
	table.insert(wp_files, f)
end
wp_index = math.random( 1, #wp_files)

-- setup the timer
wp_timer:connect_signal("timeout", function()

	-- set wallpaper to current index
	for r = 1, screen.count() do
		gears.wallpaper.maximized( wp_path .. wp_files[wp_index] , r, true)
	end

	-- stop the timer (we don't need multiple instances running at the same time)
	wp_timer:stop()

	-- get next random index
	wp_index = math.random( 1, #wp_files)

	--restart the timer
	wp_timer.timeout = wp_timeout
	wp_timer:start()
end)

-- initial start when rc.lua is first run
wp_timer:start()

APWTimer = timer({ timeout = 0.5 }) -- set update interval in s
APWTimer:connect_signal("timeout", APW.Update)
APWTimer:start()

-- User commands
other.userCommands()

-- Change gurb background for next boot

grub_wp = math.random(1, #wp_files)

if string.sub(wp_files[grub_wp], -3) ~= "png" then
	awful.util.spawn_with_shell("convert "..wp_path..wp_files[grub_wp].." /boot/grub/themes/starfield/starfield.png")
else
	awful.util.spawn_with_shell("cp "..wp_path..wp_files[grub_wp].." /boot/grub/themes/starfield/starfield.png")
end
