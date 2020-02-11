local wibox = require ("wibox")
local beautiful = require("beautiful")
local vicious = require("vicious")
local awful = require("awful")
local APW = require("apw/widget")

local wid = {}
beautiful.init("~/.config/awesome/powerarrowf/theme.lua")
font = "Terminus 12"

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

--{{ Time and Date Widget }} --
datewidget = wibox.widget.textbox()
vicious.register(datewidget,
				 vicious.widgets.date,
				 "<span font='"..font.."' color='"..beautiful.colors.base03.."' background='"..beautiful.colors.cyan.."'>%b %d %R</span>",
				 20)

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
batterywidget = wibox.widget.textbox()
vicious.register(batterywidget, vicious.widgets.bat, "<span background='"..beautiful.colors.blue.."' font='"..font.."' color='"..beautiful.colors.base03.."'>$1$2%</span>", 10, "BAT0")

--{{---| File Size widget |-----

fswidget = wibox.widget.textbox()

vicious.register(fswidget, vicious.widgets.fs,
'<span background="'..beautiful.colors.dviolet..'" font="'..font..'"> <span font="'..font..'" color="#EEEEEE">${/home used_gb}/${/home avail_gb} GB </span></span>',
800)

fsicon = wibox.widget.imagebox()
fsicon:set_image(beautiful.fsicon)

--{{---| CPU / sensors widget |-----------
cpuwidget = wibox.widget.textbox()
vicious.register(cpuwidget, vicious.widgets.cpu,
'<span background="'..beautiful.colors.violet..'" font="'..font..'"> <span font="'..font..'" color="'..beautiful.colors.base03..'">$1%</span></span>', 5)

cpuicon = wibox.widget.imagebox()
cpuicon:set_image(beautiful.cpuicon)

--{{--| MEM widget |-----------------
memwidget2 = wibox.widget.textbox()
vicious.register(memwidget2, vicious.widgets.mem, "<span background='"..beautiful.colors.violet.."' font='"..font.."' color='"..beautiful.colors.base03.."'>$1%</span>", 13)
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

function wid.createwibox(screen)										  
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
		left_layout.forced_width = 1000

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
end

return wid
