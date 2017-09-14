parameter precision is 0.1, warp is true.

sas off.
set ship:control:pilotmainthrottle to 0.

until not hasnode {
	lock dv to nextnode:deltav.
	lock burn to dv:mag() / (ship:availablethrust / ship:mass).

	print "Node dv: " + round(dv:mag(), 1) + "m/s".
	print "Estimated burn time: " + round(burn) + "s".
	lock steering to dv.
	
	if warp {
		lock pd to dv:direction:pitch - ship:facing:pitch.
		lock yd to dv:direction:yaw - ship:facing:yaw.

		lock pa to pd > -0.5 and pd < 1.5.
		lock ya to yd > -0.5 and yd < 0.5.

		print "Aligning before warping...".
		wait until pa and yd.
		print "Aligned, beginning warp".
		kuniverse:timewarp:warpto(time:seconds + nextnode:eta - 10 - burn / 2).
	}

	wait until nextnode:eta - 10 <= burn / 2.
	kuniverse:timewarp:cancelwarp().
	print "Cancelling timewarp".

	wait until nextnode:eta <= burn / 2.

	kuniverse:timewarp:cancelwarp().
	print "Starting node burn".

	local pid is pidloop(-0.01, 0, -0.006).
	set pid:setpoint to 0.
	set pid:minoutput to 0.01.
	set pid:maxoutput to 1.

	lock throttle to pid:update(time:seconds, dv:mag()).

	wait until dv:mag() <= precision.
	print "Burn completed".
	remove nextnode.
}

sas on.
set ship:control:pilotmainthrottle to 0.

unlock steering.
unlock throttle.