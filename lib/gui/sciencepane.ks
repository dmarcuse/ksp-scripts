runoncepath("/lib/science").
runoncepath("/lib/notify").

declare function sciencepane {
	declare parameter box.

	declare local runexps is box:addbutton("Run experiments now").
	set runexps:onclick to {
		notify("Ran " + runallexperiments() + " experiment(s).").
	}.
}