parameter tgt_speed is 500000.

sas off.


lock speed to ship:orbit:velocity:surface:mag().

local pid is pidloop(0.01).
set pid:setpoint to tgt_speed.
set pid:minoutput to 0.
set pid:maxoutput to 1.

function upd {
	local throt is pid:update(time:seconds, speed).

	print "Speed " + round(speed, 1) + "m/s" at (0, 15).
	print "Throttle " + round(throt, 2) at (0, 16).

	return throt.
}

lock steering to up.
lock throttle to upd().

when ship:availablethrust = 0 and stage:ready then {
	stage.

	pid:reset().

	// seems to help avoid flipping around wildly for a few seconds after staging
	lock steering to up.

	return stage:number > 0.
}

wait until false.