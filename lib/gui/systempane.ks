@lazyglobal off.

declare function systempane {
	declare parameter box.

	declare local disklbl is box:addlabel(round(100 * (1 - (core:volume:freespace / core:volume:capacity)), 1) + "% disk usage").
}