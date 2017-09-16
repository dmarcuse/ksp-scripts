parameter secs, precision is 0.001.

sas off.
set ship:control:pilotmainthrottle to 0.

print "Current orbital period " + ship:orbit:period.
print "Target orbital period " + secs.

local pdiff is 0.
if ship:orbit:period > secs {
	lock pdiff to ship:orbit:period - secs.
	lock steering to retrograde.
} else {
	lock pdiff to secs - ship:orbit:period.
	lock steering to prograde.
}

set pid to pidloop(-0.001).

set pid:minoutput to 0.0001.
set pid:maxoutput to 1.
set pid:setpoint to 0.

function upd {
	set throt to pid:update(time:seconds, pdiff).
	print "Pdiff " + pdiff at (0, 15).
	print "T " + throt at (0, 16).
	return throt.
}

lock throttle to upd().

wait until pdiff < precision.
print "Done".
sas on.