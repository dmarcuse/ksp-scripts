parameter begin is 10000.

sas off.
set ship:control:pilotmainthrottle to 0.

lock steering to -ship:orbit:velocity:surface.

if alt:radar > begin {
	print "Waiting until radar altitude less than " + begin + "m".
	wait until alt:radar <= begin.
}

print "Beginning powered landing".

when alt:radar <= 300 then {
	print "Deploying landing gear".
	gear on.
}

set pid to pidloop(0.01, 0, 0.1).
set pid:setpoint to -1.
set pid:minoutput to 0.
set pid:maxoutput to 1.

lock throttle to pid:update(time:seconds, alt:radar).

wait until ship:status = "landed" or ship:status = "splashed".
print "Landing complete".
sas on.