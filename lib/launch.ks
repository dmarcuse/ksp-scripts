@lazyglobal off.

runoncepath("/lib/utils").
runoncepath("/lib/node").
//runoncepath("/lib/external/lazcalc").

declare function launchazimuth {
	declare parameter tgtalt.
	declare parameter tgtinc.
	declare parameter s is ship.

	declare local launchlat is s:latitude.

	declare local southbound is tgtinc < 0.
	set tgtinc to abs(tgtinc).

	if abs(launchlat) > tgtinc {
		set tgtinc to abs(launchlat).
		notify("Inclination impossible, adjusting to " + tgtinc, 3, red).
	} else if (180 - abs(launchlat)) < tgtinc {
		set tgtinc to 180 - abs(launchlat).
		notify("Inclination impossible, adjusting to " + tgtinc, 3, red).
	}

	declare local b is s:orbit:body.
	declare local equatorialspd is (2 * constant:pi * b:radius) / b:rotationperiod.

	declare local tgtspd is orbitalspeed(tgtalt, b).

	return {
		declare local inertialazimuth is arcsin(max(min(cos(tgtinc) / cos(s:latitude), 1), -1)).
		declare local vxrot is tgtspd * sin(inertialazimuth) - equatorialspd * cos(launchlat).
		declare local vyrot is tgtspd * cos(inertialazimuth).

		declare local azimuth is mod(arctan2(vxrot, vyrot) + 360, 360).

		if southbound {
			if azimuth <= 90 {
				return 180 - azimuth.
			} else if azimuth >= 270 {
				return 540 - azimuth.
			}
		} else {
			return azimuth.
		}
	}.
}

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

	declare local getheading is launchazimuth(tgtalt, tgtinc, ship).

	declare local getsteering is {
		declare local p is 90.
		if altitude >= turnalt {
			set p to 90 - ((apoapsis - turnstartap) / (tgtalt - turnstartap) * 75).
		}

		return heading(getheading(), p).
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