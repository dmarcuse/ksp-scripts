runoncepath("/lib/notify").
runoncepath("/lib/gui/contentswitcher").
runoncepath("/lib/gui/sciencepane").
runoncepath("/lib/gui/systempane").

declare function startgui {
	declare local window is gui(200).
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

	declare local addpane is createswitcher(window).

	addpane("Science", sciencepane@).
	addpane("System", systempane@).

	window:show().
	wait until stopped.
	window:hide().
	window:dispose().
}