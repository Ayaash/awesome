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

binding = {}
local oneko = false
local touchpad = false
local screen_left = false

-- Table of layouts to cover with awful.layout.inc, order matters.
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
-- }}}

function binding.keybinding()

	local globalkeys = awful.util.table.join(
	keydoc.group("Tag management"),
	awful.key({ modkey,           }, "Left",   awful.tag.viewprev       , "Next tag"),
	awful.key({ modkey,           }, "Right",  awful.tag.viewnext       , "Previous tag"),
	awful.key({ modkey,           }, "Escape", awful.tag.history.restore, "Switch to previous tag"),
	awful.key({ modkey,           }, "b", function() wp_timer:emit_signal("timeout") end, "Change background"),

	keydoc.group("Focus"),
	awful.key({ modkey,           }, "j",
	function ()
		awful.client.focus.byidx( 1)
		if client.focus then client.focus:raise() end
	end, "Focus next window"),
	awful.key({ modkey,           }, "k",
	function ()
		awful.client.focus.byidx(-1)
		if client.focus then client.focus:raise() end
	end, "Focus previous window"),
	awful.key({ modkey,	"Shift"	 }, "s",
	function ()
		if screen_left==false then
			awful.util.spawn("xrandr --output VGA1 --mode 1024x768 --left-of LVDS1")
		else
			awful.util.spawn("xrandr --output VGA1 --off")
		end
		screen_left= not screen_left
	end, "Additional screen toggle"),
	awful.key({modkey,				}, "F1", function () awful.screen.focus(2) end, "Swich to left screen"),
	awful.key({modkey,				}, "F2", function () awful.screen.focus(1) end, "Swich to right screen"),


	-- Layout manipulation
	keydoc.group("Layout manipulation"),
	awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end, "Increase master-width factor"),
	awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end, "Decrease master-width factor"),
	awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster( 1)      end, "Increase number of masters"),
	awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster(-1)      end, "Decrease number of masters"),
	awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol( 1)         end, "Increase number of columns"),
	awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol(-1)         end, "Decrease number of columns"),
	awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end, "Next layout"),
	awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end, "Previous layout"),
	awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end, "Swap with next window"),
	awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end, "Swap with previous window"),
	awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
	awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
	awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
	awful.key({ modkey,           }, "Tab",
	function ()
		awful.client.focus.history.previous()
		if client.focus then
			client.focus:raise()
		end
	end, "Focus previously focused window"),

	awful.key({ modkey, "Control" }, "n", awful.client.restore),

	-- Standard program
	keydoc.group("Misc"),
	awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end, "Spawn a terminal"),
	awful.key({ }, "Print", function () awful.util.spawn("scrot -e 'mv $f ~/screenshots/ 2>/dev/null'") end, "Screenshot"),
	awful.key({ modkey, "Control" }, "r", awesome.restart, "Restart awesome"),
	awful.key({ modkey, "Shift"   }, "q", awesome.quit, "Quit awesome"),
	awful.key({ modkey, "Shift"   }, "g", function() awful.util.spawn("gnome-terminal") end, "Gnome-terminal"),
	awful.key({ modkey, }, "t",
	function ()
		if touchpad == false then
			awful.util.spawn("synclient TouchpadOff=0")
		else
			awful.util.spawn("synclient TouchpadOff=1")
		end
		touchpad = not touchpad
	end, "TouchPad toggle"),
	awful.key({ modkey, 			 }, "o",
	function ()
		if oneko == false then
			awful.util.spawn("oneko -rv -tora")
		else
			awful.util.spawn("pkill -9 oneko")
		end
		oneko = not oneko
	end, "Oneko toggle"),

	awful.key({ modkey }, ";",
	function ()
		awful.util.spawn("sync")
		awful.util.spawn("xautolock -locknow")
	end, "Lock screen"),

	-- Prompt
	awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end, "Prompt for a command"),

	awful.key({ modkey }, "x",
	function ()
		awful.prompt.run({ prompt = "Run Lua code: " },
		mypromptbox[mouse.screen].widget,
		awful.util.eval, nil,
		awful.util.getdir("cache") .. "/history_eval")
	end),

	-- Other
	awful.key({ "Mod1" }, "w",  APW.Up),
	awful.key({"Mod1" }, "x",  APW.Down),
	awful.key({"Mod1" }, "c",         APW.ToggleMute),
	awful.key({ modkey, }, "F3", keydoc.display)
	)

	globalkeys = awful.util.table.join(globalkeys, ror.genkeys(modkey))

	-- Bind all key numbers to tags.
	-- Be careful: we use keycodes to make it works on any keyboard layout.
	-- This should map on the top row of your keyboard, usually 1 to 9.
	for i = 1, 9 do
		globalkeys = awful.util.table.join(globalkeys,
		-- View tag only.
		awful.key({ modkey }, "#" .. i + 9,
		function ()
			local screen = mouse.screen
			local tag = awful.tag.gettags(screen)[i]
			if tag then
				awful.tag.viewonly(tag)
			end
		end),
		-- Toggle tag.
		awful.key({ modkey, "Control" }, "#" .. i + 9,
		function ()
			local screen = mouse.screen
			local tag = awful.tag.gettags(screen)[i]
			if tag then
				awful.tag.viewtoggle(tag)
			end
		end),
		-- Move client to tag.
		awful.key({ modkey, "Shift" }, "#" .. i + 9,
		function ()
			if client.focus then
				local tag = awful.tag.gettags(client.focus.screen)[i]
				if tag then
					awful.client.movetotag(tag)
				end
			end
		end),
		-- Toggle tag.
		awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
		function ()
			if client.focus then
				local tag = awful.tag.gettags(client.focus.screen)[i]
				if tag then
					awful.client.toggletag(tag)
				end
			end
		end))
	end

	return globalkeys
end

function binding.clientkeys()
	local clientkeys = awful.util.table.join(
	keydoc.group("Window-specific bindings"),
	awful.key({ modkey,           }, "d",      function (c) c.fullscreen = not c.fullscreen  end, "Fullscreen"),
	awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
	awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     , "Toggle floating"),
	awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end, "Switch with master window"),
	awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        , "Move to the other screen"),
	awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end, "Raise window"),
	awful.key({ modkey,           }, "n",
	function (c)
		-- The client currently has the input focus, so it cannot be
		-- minimized, since minimized clients can't have the focus.
		c.minimized = true
	end),
	awful.key({ modkey,           }, "m",
	function (c)
		c.maximized_horizontal = not c.maximized_horizontal
		c.maximized_vertical   = not c.maximized_vertical
	end, "Maximise")
	)

	return clientkeys
end

function binding.mousebinding()
	bind = awful.util.table.join(
	awful.button({ }, 3, function () mymainmenu:toggle() end),
	awful.button({ }, 4, awful.tag.viewnext),
	awful.button({ }, 5, awful.tag.viewprev))
	return bind
end

function binding.clientbuttons()
	local clientbuttons = awful.util.table.join(
	awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
	awful.button({ modkey }, 1, awful.mouse.client.move),
	awful.button({ modkey }, 3, awful.mouse.client.resize))
	return clientbuttons
end

return binding
