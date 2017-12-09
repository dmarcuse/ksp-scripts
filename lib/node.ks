runoncepath("/lib/utils").

declare function executenode {
	declare parameter precision is 0.1.
	declare parameter warp is true.
	declare parameter callback is {
		declare parameter statusmessage.

		return true.
	}.

	// called when the function is stopped
	declare local stop is {
		kuniverse:timewarp:cancelwarp().
		unlock steering.
		unlock throttle.
		set ship:control:pilotmainthrottle to 0.
		sas on.
	}.

	if not hasnode {
		return.
	}

	// approximate time the burn will take in seconds
	local lock burnduration to nextnode:deltav:mag() / acceleration().

	// UT of the maneuver node
	local lock nodeut to nextnode:eta + time:seconds.

	// UT that the burn should be started
	local lock burnstarttime to nodeut - (burnduration / 2).

	// ETA of burn start
	local lock timetoburn to nextnode:eta - (burnduration / 2).

	// wait for burn window (30s before burn start)
	{
		if timetoburn > 30 and warp {
			kuniverse:timewarp:warpto(burnstarttime - 31).
		}

		until timetoburn <= 30 {
			if not callback("Waiting " + round(timetoburn) + "s for burn window") { stop(). return. }
		}
	}

	// align with maneuver vector and wait for burn start
	{
		kuniverse:timewarp:cancelwarp().
		sas off.
		lock steering to nextnode:deltav.

		until timetoburn <= 0 {
			if not callback("Waiting " + round(timetoburn) + "s for burn start") { stop(). return. }
		}
	}

	// perform burn
	{
		kuniverse:timewarp:cancelwarp().

		local lock targetacceleration to (1 - (alignerror() / 10)) * (nextnode:deltav:mag()).
		lock throttle to clamp(targetacceleration / acceleration(), 1, precision / acceleration()).

		until nextnode:deltav:mag() <= precision {
			if not callback("Burning, throttle " + round(throttle * 100) + "%") { stop(). return. }
		}
	}

	stop().
	remove nextnode.
}