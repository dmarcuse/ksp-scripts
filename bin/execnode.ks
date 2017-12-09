declare parameter precision is 0.1.
declare parameter warp is true.

runoncepath("/lib/node").

executenode(precision, warp, {
	declare parameter status.

	clearscreen.
	print "Executing maneuver node" at(0,0).
	print status at(0,1).
	return true.
}).

print "DONE" at (0,2).