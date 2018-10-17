@lazyglobal off.

runoncepath("/lib/period").
runoncepath("/lib/utils").

declare function periodpane {
	declare parameter box.

	declare local stackpane is box:addstack().
	declare local optpane is stackpane:addvlayout().
	stackpane:showonly(optpane).

	declare local execbtn is optpane:addbutton("Adjust orbital period").

	declare local vallbl is optpane:addlabel("").
	declare local valbox is optpane:addtextfield("0").
	local lock tgttime to valbox:text:tonumber(0).

	set valbox:onchange to {
		declare parameter value.
		set vallbl:text to "Target time " + formattime(tgttime).
	}.

	valbox:onchange(valbox:text).

	declare local precisionlbl is optpane:addlabel("").
	declare local precisionslider is optpane:addhslider(-3, -5, 2).
	local lock tgtprecision to 10 ^ round(precisionslider:value, 0).

	set precisionslider:onchange to {
		declare parameter value.
		set precisionlbl:text to "Precision " + tgtprecision + "s".
	}.

	precisionslider:onchange(precisionslider:value).

	return {
		if execbtn:takepress {
			declare local statuspane is stackpane:addvlayout().
			stackpane:showonly(statuspane).

			declare local statuslbl is statuspane:addlabel("").
			declare local abortbtn is statuspane:addbutton("Abourt launch").

			setperiod(tgttime, tgtprecision, {
				declare parameter status.
				set statuslbl:text to status.

				return not abortbtn:takepress.
			}).

			stackpane:showonly(optpane).
			statuspane:dispose().
		}
	}.
}