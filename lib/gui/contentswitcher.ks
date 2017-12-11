@lazyglobal off.

declare function createswitcher {
	declare parameter window.
	declare parameter callbacks.

	declare local switcherbar is window:addhlayout().
	declare local switchidx is 0.
	declare local switchprev is switcherbar:addbutton("<").
	declare local switchpopup is switcherbar:addpopupmenu().
	declare local switchnext is switcherbar:addbutton(">").
	declare local panes is window:addstack().

	declare function updatepane {
		declare local next is panes:widgets[switchidx].
		set switchpopup:index to switchidx.
		panes:showonly(next).
	}

	set switchprev:onclick to {
		set switchidx to switchidx - 1.
		if switchidx < 0 {
			set switchidx to panes:widgets:length() - 1.
		}
		updatepane().
	}.

	set switchnext:onclick to {
		set switchidx to switchidx + 1.
		if switchidx >= panes:widgets:length() {
			set switchidx to 0.
		}
		updatepane().
	}.

	set switchpopup:onchange to {
		declare parameter changedto.
		set switchidx to switchpopup:index.
		updatepane().
	}.

	return {
		declare parameter name.
		declare parameter builder is { declare parameter box. }.
		declare local box is panes:addvbox().
		switchpopup:addoption(name).
		declare local callback is builder(box).
		if callback:typename() = "UserDelegate" {
			callbacks:add(callback).
		}
		updatepane().
		return box.
	}.
}