declare function systempane {
	declare parameter box.

	declare local diskuse is box:addhlayout().
	diskuse:addlabel(round(100 * (1 - (core:volume:freespace / core:volume:capacity)), 1) + "% disk usage").
}