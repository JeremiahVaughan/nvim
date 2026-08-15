-- Extra autostart processes
-- exec-once = uwsm-app -- my-service
-- hl.on(
-- 	"hyprland.start",
-- 	function ()
-- 		hl.exec_cmd("uwsm-app -- my-service")
-- 	end
-- )

-- Do not want notifications
hl.on(
	"hyprland.start",
	function ()
		hl.exec_cmd('sh -c "sleep 1; makoctl mode -a do-not-disturb"')
	end
)
