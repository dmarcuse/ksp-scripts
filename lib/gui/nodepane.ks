runoncepath("/lib/node").
runoncepath("/lib/utils").

declare function nodepane {
	declare parameter box.

	declare execbtn is box:addbutton("Execute maneuver node").

	return {
		if execbtn:takepress {
			if not hasnode {
				notify("No maneuver node present!").
				return.
			}

			notify("Executing maneuver node").
			set execbtn:enabled to false.

			declare local abortbtn is box:addbutton("Abort node execution").
			declare local statuslbl is box:addlabel("").

			executenode(0.1, true, {
				declare parameter status.
				set statuslbl:text to status.
				return not abortbtn:takepress.
			}).

			set execbtn:enabled to true.
			statuslbl:dispose().
			abortbtn:dispose().
		}
	}.
}