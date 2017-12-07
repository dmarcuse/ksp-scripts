parameter dryrun is false, keywords is list("log", "observe", "report", "record", "collect").

set sciparts to list().

// stock science experiments
for e in ship:modulesnamed("ModuleScienceExperiment") { sciparts:add(e). }

// dmagic orbital science
for e in ship:modulesnamed("DMModuleScienceAnimate") { sciparts:add(e). }

// dmagic orbital science: micro goo and micro mat bay
for e in ship:modulesnamed("DMRoverGooMat") { sciparts:add(e). }

// dmagic orbital science: soil moisture
for e in ship:modulesnamed("DMSoilMoisture") { sciparts:add(e). }

for module in sciparts {
	//print module.
	for event in module:alleventnames {
		for keyword in keywords {
			if event:contains(keyword) {
				print event.

				if (not dryrun and module:hasevent(event)) {
					module:doevent(event).
				}
			}
		}
	}
}