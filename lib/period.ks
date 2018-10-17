@lazyglobal off.

runoncepath("/lib/utils").

declare function setperiod {
	declare parameter secs.
	declare parameter precision is 0.001.
	declare parameter statuscallback is { declare parameter status. return true. }.

	declare local stop is {
		unlock throttle.
		set throttle to 0.
		unlock steering.
		sas on.
		set ship:control:pilotmainthrottle to 0.
	}.

	kuniverse:timewarp:cancelwarp().
	sas off.

	declare local pdiff is 0.

	if ship:orbit:period > secs {
		lock steering to retrograde.

		set pdiff to {
			return ship:orbit:period - secs.
		}.
	} else {
		lock steering to prograde.
		
		set pdiff to {
			return secs - ship:orbit:period.
		}.
	}

	declare local getthrottle is {
		declare local acc is acceleration().
		declare local err is alignerror().
		declare local targetacc is (1 - (err / 10)) * (pdiff() / acc).

		if acc <= 0 or err > 5 {
			return 0.
		} else {
			return clamp(targetacc / acc, 1, precision / (acc / precision)).
		}
	}.

	lock throttle to getthrottle().
	
	until pdiff() < precision {
		if not statuscallback("Pdiff: " + pdiff() +  " Throttle: " + round(throttle * 100) + "%") { stop(). return. }
	}.

	stop().
	return.
}