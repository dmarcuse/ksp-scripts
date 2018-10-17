@lazyglobal off.

declare parameter seconds.
declare parameter precision is 0.001.

runoncepath("/lib/period").

setperiod(seconds, precision, {
	declare parameter status.

	clearscreen.
	print "Adjusting orbital period" at (0, 0).
	print status at (0, 1).
	return true.
}).

print "DONE" at (0, 2).
