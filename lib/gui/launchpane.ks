@lazyglobal off.

runoncepath("/lib/launch").
runoncepath("/lib/utils").
runoncepath("/lib/deploy").

declare function launchpane {
	declare parameter box.

	declare local stackpane is box:addstack().
	declare local optpane is stackpane:addvlayout().
	stackpane:showonly(optpane).

	declare local launchbtn is optpane:addbutton("Launch to orbit").

	declare local altlbl is optpane:addlabel("").
	declare local altslider is optpane:addhslider(10, 1, 100).
	local lock tgtalt to round(altslider:value) * 10000.
	
	set altslider:onchange to {
		declare parameter value.
		set altlbl:text to "Altitude " + formatmeters(tgtalt).
	}.

	altslider:onchange(altslider:value).

	declare local inclbl is optpane:addlabel("").
	declare local incslider is optpane:addhslider(0, -12, 12).
	local lock tgtinc to round(incslider:value) * 15.
	
	set incslider:onchange to {
		declare parameter value.
		set inclbl:text to "Inclination " + tgtinc + "°".
	}.

	incslider:onchange(incslider:value).

	declare local deploybtn is optpane:addcheckbox("Auto-deploy panels, fairings, antennas", false).

	return {
		if launchbtn:takepress {
			notify("Launching to orbit at " + formatmeters(tgtalt)).
			declare local statuspane is stackpane:addvlayout().
			stackpane:showonly(statuspane).

			declare local statuslbl is statuspane:addlabel("").
			declare local abortbtn is statuspane:addbutton("Abort launch").

			declare local deployed is not deploybtn:pressed.

			launchtoorbit(tgtalt, tgtinc, {
				declare parameter status.
				
				set statuslbl:text to status.

				if (altitude > (1.05 * body:atm:height)) and (not deployed) {
					set deployed to true.

					deployfairings().
					deployantennas().
					panels on.

					notify("Deployed panels, fairings, and antennas").
				}

				declare local aborted is abortbtn:takepress.
				if aborted {
					abort on.
					notify("Launch aborted!", 3, red).
				}

				return not aborted.
			}).

			stackpane:showonly(optpane).
			statuspane:dispose().
		}
	}.
}