@lazyglobal off.

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
		set throttle to 0.
		set ship:control:pilotmainthrottle to 0.
		sas on.
	}.

	if not hasnode {
		return.
	}

	// approximate time the burn will take in seconds
	// local lock burnduration to nextnode:deltav:mag / acceleration().
	declare local burnduration is nodeburntime().

	// UT that the burn should be started
	local lock burnstarttime to nextnode:time - (burnduration / 2).
	// declare local burnstarttime is nextnode:time - (burnduration / 2).

	// ETA of burn start
	local lock timetoburn to nextnode:eta - (burnduration / 2).
	// declare local timetoburn is nextnode:eta - (burnduration / 2).

	// wait for burn window (30s before burn start)
	{
		if timetoburn > 30 and warp {
			kuniverse:timewarp:warpto(burnstarttime - 31).
		}

		until timetoburn <= 30 {
			wait 0. // save power while waiting
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

		local lock targetacceleration to (1 - (alignerror() / 10)) * (nextnode:deltav:mag).

		declare local getthrottle is {
			declare local a is acceleration().
			if a <= 0 {
				return 0.
			} else {
				return clamp(targetacceleration / a, 1, precision / a).
			}
		}.
		
		lock throttle to getthrottle().

		until nextnode:deltav:mag <= precision {
			if not callback("Burning, throttle " + round(throttle * 100) + "%") { stop(). return. }

			if ship:availablethrust <= 0 and stage:number > 0 and stage:ready {
				stage.
				steeringmanager:resetpids().
			}
		}
	}

	stop().
	remove nextnode.
}