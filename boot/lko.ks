clearscreen.

print "Copying launch script".
copypath("0:surface/launch", "surface/launch").

print "Waiting 5 seconds to stabilize before launching".
wait 5.

print "----- Executing launch script for 100km".
runpath("surface/launch", 100_000, true, true).
print "----- Launch script completed".

print "Removing boot script".
deletepath("boot/lko").

print "Launch sequence completed".