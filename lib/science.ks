declare function runallexperiments {
	declare parameter dryrun is false.
	declare parameter keywords is list("log", "observe", "report", "record", "collect").

	declare local ran is 0.
	declare local sciparts is list().

	// stock science experiments
	for e in ship:modulesnamed("ModuleScienceExperiment") { sciparts:add(e). }

	// dmagic orbital science
	for e in ship:modulesnamed("DMModuleScienceAnimate") { sciparts:add(e). }

	// dmagic orbital science: micro goo and micro mat bay
	for e in ship:modulesnamed("DMRoverGooMat") { sciparts:add(e). }

	// dmagic orbital science: soil moisture
	for e in ship:modulesnamed("DMSoilMoisture") { sciparts:add(e). }

	for module in sciparts {
		for event in module:alleventnames {
			for keyword in keywords {
				if event:contains(keyword) {
					print event.

					if (not dryrun and module:hasevent(event)) {
						module:doevent(event).
						set ran to ran + 1.
					}
				}
			}
		}
	}

	return ran.
}