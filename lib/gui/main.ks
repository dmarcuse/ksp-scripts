runoncepath("/lib/utils").
runoncepath("/lib/gui/contentswitcher").
runoncepath("/lib/gui/sciencepane").
runoncepath("/lib/gui/systempane").
runoncepath("/lib/gui/nodepane").
runoncepath("/lib/gui/launchpane").

declare function startgui {
	declare local window is gui(300).
	declare local stopped is false.

	// Create header
	{
		declare local header is window:addvlayout().
		
		declare local titlebar is header:addhlayout().
		declare local title is titlebar:addlabel("kOS Assistant").

		declare local reinstallbtn is titlebar:addbutton("⟳").
		set reinstallbtn:tooltip to "Reinstall system from archive and reboot".
		set reinstallbtn:onclick to {
			set reinstallbtn:enabled to false.
			runpath("/bin/install").
			reboot.
		}.

		declare local consolebtn is titlebar:addbutton(">_").
		set consolebtn:tooltip to "Close GUI and open terminal".
		set consolebtn:onclick to {
			if core:hasevent("open terminal") {
				core:doevent("open terminal").
				notify("Terminal opened").
				set stopped to true.
			} else {
				notify("Cannot open terminal").
			}
		}.

		declare local closebtn is titlebar:addbutton("X").
		set closebtn:tooltip to "Close GUI and shut down processor".
		set closebtn:onclick to {
			shutdown.
		}.
	}

	// Add content panes
	declare local callbacks is list().
	declare local addpane is createswitcher(window, callbacks).

	addpane("Node", nodepane@).
	addpane("Launch", launchpane@).
	addpane("Science", sciencepane@).
	addpane("System", systempane@).

	window:show().
	until stopped {
		for callback in callbacks {
			callback().
		}
		wait 0.
	}
	window:hide().
	window:dispose().
}