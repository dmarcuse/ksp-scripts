clearscreen.

sas off.
lock steering to up.

print "Copying launch and deploy scripts".
copypath("0:launch", "launch").
copypath("0:deploy", "deploy").

print "Waiting 5 seconds to stabilize before launching".
wait 5.

print "Executing launch script for 100km".
print "-----".

runpath("launch", 100_000).

print "Executing deploy script".
print "-----".

runpath("deploy").

print "Removing boot script".
deletepath("boot/lko").