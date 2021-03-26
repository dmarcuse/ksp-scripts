@lazyglobal off.

// some generic utility functions

declare function notify {
	declare parameter text.
	declare parameter timeout is 3.
	declare parameter color is green.

	hudtext(text, timeout, 1, 24, color, true).
}

// get the ship's current acceleration
declare function acceleration {
	return ship:availablethrust / ship:mass.
}

// square a value
declare function square {
	declare parameter x.
	return x * x.
}

// calculate the current steeringmanager total pitch/yaw error
declare function alignerror {
	return sqrt(square(steeringmanager:yawerror) + square(steeringmanager:pitcherror)).
}

// clamp a value to be between the given max and min values
declare function clamp {
	declare parameter value.
	declare parameter maxval.
	declare parameter minval.

	return max(min(value, maxval), minval).
}

// format a number of meters as human-readable text
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

// format a number of seconds as human-readable text
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

// calculate the necessary speed to maintain an orbit at the given altitude around the given body (defaults to current orbiting body)
declare function orbitalspeed {
	declare parameter tgtalt.
	declare parameter b is ship:orbit:body.
	return sqrt(b:mu / (tgtalt + b:radius)).
}

// get the burn duration of the next maneuver node considering the ship's dv
declare function nodeburntime {
	// todo: wait for deltav to stabilize?
	declare local remaining is nextnode:deltav:mag.
	declare local totaltime is 0.
	declare local currentstage is ship:stagenum.

	until remaining <= 0 or currentstage = 0 {
		declare local dv is ship:stagedeltav(currentstage).
		declare local p is min(1, remaining / dv:current).
		set remaining to remaining - dv:current * p.
		set totaltime to totaltime + dv:duration * p.
		set currentstage to currentstage - 1.
	}

	return totaltime.
}