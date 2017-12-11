@lazyglobal off.

declare function deployfairings {
	for f in ship:modulesnamed("ModuleProceduralFairing") {
		if f:hasevent("deploy") {
			f:doevent("deploy").
			print "Deployed fairing " + f:part:title.
		}
	}
}

declare function deployantennas {
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