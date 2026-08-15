-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

-- local omarchy_gdk_scale = 2
-- local omarchy_monitor_scale = "auto"

-- hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))
-- hl.monitor({ output = "", mode = "preferred", position = "auto", scale = omarchy_monitor_scale })

-- Configure a specific monitor.
-- hl.monitor({ output = "DP-2", mode = "2560x1440@144", position = "0x0", scale = 1 })

-- Portrait/rotated secondary monitor (transform: 1 = 90°, 3 = 270°).
-- hl.monitor({ output = "DP-2", mode = "preferred", position = "auto", scale = 1, transform = 1 })
--
hl.env("GDK_SCALE", "2")

hl.monitor({
	output = "eDP-1",
	mode = "2256x1504@60.00",
	position = "2560x672",
	scale = "2.00",
})

hl.monitor({
	output = "DP-2",
	mode = "3840x2160@60.00",
	position = "0x0",
	scale = "1.50",
})

local outputs = {
	"DP-2",
	"eDP-1",
}

local i = 1
for _, out in ipairs(outputs) do
	for j = 1, 5 do
		local options = {
			workspace = tostring(i),
			monitor = out,
		}
		if j == 1 then
			options.default = true
		end
		hl.workspace_rule(options)
		i = i + 1
	end
end

