@lazyglobal off.

// some generic utitlity function

declare function notify {
	declare parameter text.
	declare parameter timeout is 3.
	declare parameter color is green.

	hudtext(text, timeout, 1, 24, color, true).
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

declare function formatmeters {
	declare parameter meters.

	if meters >= 1e9 {
		return round(meters / 1e9, 1) + "Gm".
	} else if meters >= 1e6 {
		return round(meters / 1e6, 1) + "Mm".
	} else if meters >= 1e3 {
		return round(meters / 1e3, 1) + "km".
	} else if meters >= 1e0 {
		return round(meters / 1e0, 1) + "m".
	} else {
		return round(meters / 1e-3, 1) + "mm".
	}
}

declare function formattime {
	declare parameter seconds.
	
	declare local text is "".

	if seconds > 21600 {
		declare local days is floor(seconds / 21600).
		set text to text + days + "d ".
		set seconds to seconds - (days * 21600).
	}

	if seconds > 3600 {
		declare local hours is floor(seconds / 3600).
		set text to text + hours + "h ".
		set seconds to seconds - (hours * 3600).
	}

	if seconds > 60 {
		declare local minutes is floor(seconds / 60).
		set text to text + minutes + "m ".
		set seconds to seconds - (minutes * 60).
	}

	set text to text + seconds + "s".
	return text.
}

declare function orbitalspeed {
	declare parameter tgtalt.
	declare parameter body is ship:orbit:body.
	return sqrt(ship:orbit:body:mu / (tgtalt + ship:orbit:body:radius)).
}