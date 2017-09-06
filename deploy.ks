parameter solar is true, omni is true, dish is true.


for a in ship:modulesnamed("ModuleRTAntenna") {
	if a:hasevent("activate") {
		if a:hasfield("dish range") and dish {
			a:doevent("activate").
			print "Activated dish antenna " + a:part:title.
		}

		if a:hasfield("omni range") and omni {
			a:doevent("activate").
			print "Activated omni antenna " + a:part:title.
		}
	}
}

if solar {
	panels on.
	print "Deployed solar panels".
}