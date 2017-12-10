runoncepath("/lib/utils").
runoncepath("/lib/node").
runoncepath("/lib/external/lazcalc").

declare function launchtoorbit {
	declare parameter tgtalt is 100000.
	declare parameter tgtinc is 0.
	declare parameter statuscallback is { declare parameter status. return true. }.

	declare local stop is {
		unlock steering.
		unlock throttle.
		set ship:control:pilotmainthrottle to 0.
		sas on.
	}.

	declare local callback is {
		declare parameter status.

		if stage:number > 0 and ship:availablethrust <= 0 and stage:ready {
			stage.
			steeringmanager:resetpids().
		}

		return statuscallback(status).
	}.
	
	declare local turnalt is tgtalt / 20.

	sas off.

	// apoapsis at time of gravity turn start
	declare local turnstartap is 0.

	declare local azimuthdata is lazcalc_init(tgtalt, tgtinc).

	declare local getsteering is {
		if altitude < turnalt {
			return up.
		} else {
			declare local pitch is 90 - ((apoapsis - turnstartap) / (tgtalt - turnstartap) * 75).
			return heading(lazcalc(azimuthdata), pitch).
		}
	}.

	lock throttle to 1.
	lock steering to getsteering().

	until altitude >= turnalt {
		if not callback("Ascent: Gravity turn at " + formatmeters(turnalt)) { stop(). return. }
	}

	set turnstartap to apoapsis.

	until apoapsis >= tgtalt {
		if not callback("Gravity turn: Apoapsis is " + formatmeters(apoapsis)) { stop(). return. }
	}

	// create circularization node
	declare local aptime is time:seconds + eta:apoapsis.
	declare local obtspd is orbitalspeed(tgtalt, ship:orbit:body).

	// todo: improve this stuff
	declare local progradeburn is obtspd - velocityat(ship, aptime):orbit:mag.
	declare local normalburn is -2 * obtspd * sin((ship:orbit:inclination - tgtinc) / 2).

	declare local circularizenode is node(aptime, 0, normalburn, progradeburn).
	add circularizenode.

	stop().

	executenode(0.1, true, {
		declare parameter status.
		return callback("Circularizing: " + status).
	}).

	stop().
}