@lazyglobal off.

declare parameter tgtalt is 100000.
declare parameter tgtinc is 0.
declare parameter deployed is false.

runoncepath("/lib/launch").
runoncepath("/lib/utils").
runoncepath("/lib/deploy").

launchtoorbit(tgtalt, tgtinc, {
	declare parameter status.

	if (altitude > (1.05 * body:atm:height)) and not deployed {
		set deployed to true.

		deployfairings().
		deployantennas().
		panels on.
	}

	clearscreen.
	print "Launching to orbit".
	print "Target altitude: " + formatmeters(tgtalt).
	print "Target inclination: " + tgtinc + "°".
	if not deployed {
		print "Autodeploy: armed".
	} else {
		print "Autodeploy: disabled/already triggered".
	}
	print status.
	return true.
}).

print "DONE".