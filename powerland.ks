parameter begin is 10000.

sas off.
set ship:control:pilotmainthrottle to 0.

lock steering to -ship:orbit:velocity:surface.

if alt:radar > begin {
	print "Waiting until radar altitude less than " + begin + "m".
	wait until alt:radar <= begin.
}

kuniverse:timewarp:cancelwarp().
print "Beginning powered landing".

when alt:radar <= 300 then {
	print "Deploying landing gear".
	gear on.
}

set pid to pidloop(-0.1, 0, -0.006).
set pid:setpoint to 3.
set pid:minoutput to 0.
set pid:maxoutput to 1.

function upd {
	set throt to pid:update(time:seconds, ship:orbit:velocity:surface:mag()).
	print "V " + ship:orbit:velocity:surface:mag() at (0, 15).
	print "T " + throt at (0, 16).
	return throt.
}

lock throttle to upd().

wait until ship:status = "landed" or ship:status = "splashed".
print "Landing complete".
sas on.