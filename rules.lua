local awful = require("awful")
local beautiful = require("beautiful")
local binding = require("binding")
local naughty = require("naughty")

rule = {}

function rule.globalrules()
	local globalRule = { 
		-- Rules for all clients
		{ rule = { },
		 properties = { border_width = beautiful.border_width,
		 border_color = beautiful.border_normal,
		 focus = awful.client.focus.filter,
		 raise = true,
		 keys = binding.clientkeys(),
		 size_hints_honor = false,
		 buttons = binding.clientbuttons() }},
		{ rule = { class = "gimp" },
		 properties = { floating = true } },
		{ rule = { class = "Vivaldi" },
		 properties = { tag = tags[1][1], maximized_horizontal = true, maximized_vertical = true } },
		{ rule = { class = "Clementine" },
		 properties = { tag = tags[1][9], maximized = true } },
		{ rule = { class = "Steam" },
		 properties = { tag = tags[1][8] } },
		{ rule = { class = "Skype" },
		 properties = { tag = tags[1][1] } },
		{ rule = { class = "discord" },
		 properties = { tag = tags[1][2], maximized_horizontal = true, maximized_vertical = true } },
	}
	return globalRule
end

return rule
