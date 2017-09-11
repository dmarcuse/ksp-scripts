parameter orbit is 100000, deploysolar is true, deployantenna is true.

// altitude to start gravity turn
set turn_start to orbit / 10.

// gets the orbital speed of an orbit at a given height around a given body
function orbital_speed {
	parameter h, body is ship:orbit:body.
	return sqrt(body:mu / (h + (body:radius))).
}

// gets the current acceleration of this ship
function acceleration {
	return ship:availablethrust / ship:mass.
}

// deploy when in space
when altitude >= 75000 then {
	if deploysolar {
		print "Deploying solar panels".
		panels on.
	}

	if deployantenna {
		for a in ship:modulesnamed("ModuleRTAntenna") {
			if a:hasevent("activate") {
				if a:hasfield("dish range") {
					a:doevent("activate").
					print "Activated dish antenna " + a:part:title.
				}

				if a:hasfield("omni range") {
					a:doevent("activate").
					print "Activated omni antenna " + a:part:title.
				}
			}
		}
	}
}

print "Launching to orbit at " + round(orbit) + "m".

set ship:control:pilotmainthrottle to 0.
sas off.
lock throttle to 1.
lock steering to up.

// automatically stage when no thrust available
when ship:availablethrust = 0 and stage:ready then {
	stage.
	print "Stage " + stage:number + " activated".

	if stage:number > 0 {
		preserve.
	}
}

// burn to gravity turn start
print "Waiting until " + round(turn_start) + "m to begin gravity turn".
wait until altitude >= turn_start.

// gravity turn while raising apoapsis
set turn_ap to apoapsis.
print "Beginning gravity turn at " + round(altitude) + "m".
lock steering to up + R(0, -(apoapsis - turn_ap) / (orbit - turn_ap) * 75, 0).
wait until apoapsis >= orbit.

print "Coasting to start of circularization burn".
lock throttle to 0.

lock ap_time to time + eta:apoapsis.
lock ap_vel to velocityat(ship, ap_time):orbit.
lock v_diff to orbital_speed(orbit) - ap_vel:mag.
lock burn_time to v_diff / acceleration.
lock steering to ap_vel.

print "Projected burn: Δv = " + round(v_diff) + "m/s, duration = " + round(burn_time) + "s".
wait until eta:apoapsis <= burn_time / 2.

kuniverse:timewarp:cancelwarp().
print "Beginning circularization burn".

set pid to pidloop(-0.01, 0, -0.006).
set pid:setpoint to 0.
set pid:minoutput to 0.01.
set pid:maxoutput to 1.

//function upd {
//	set throt to pid:update(time:seconds, v_diff).
//	print "Throttle " + throt at(0,15).
//	print "V Diff   " + v_diff at(0, 16).
//	return throt.
//}

//lock throttle to upd().

lock throttle to pid:update(time:seconds, v_diff).
wait until v_diff <= 1.

print "Launch completed".
unlock throttle.
unlock steering.
sas on.
set ship:control:pilotmainthrottle to 0.