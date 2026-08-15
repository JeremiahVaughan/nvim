-- See https://wiki.hyprland.org/Configuring/Monitors/
-- List current monitors and resolutions possible: hyprctl monitors
-- Format: monitor = [port], resolution, position, scale
--
-- Optimized for retina-class 2x displays, like 13" 2.8K, 27" 5K, 32" 6K.

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

