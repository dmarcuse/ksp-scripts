// some generic utitlity function

declare function notify {
	declare parameter text.
	declare parameter timeout is 3.
	declare parameter color is green.

	hudtext(text, timeout, 1, 15, color, true).
}

declare function acceleration {
	return ship:availablethrust / ship:mass.
}

declare function square {
	declare parameter x.
	return x * x.
}

declare function alignerror {
	return sqrt(square(steeringmanager:yawerror) + square(steeringmanager:pitcherror)).
}

declare function clamp {
	declare parameter value.
	declare parameter maxval.
	declare parameter minval.

	return max(min(value, maxval), minval).
}