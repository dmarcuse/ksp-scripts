declare function notify {
	declare parameter text.
	declare parameter timeout is 3.
	declare parameter color is blue.

	hudtext(text, timeout, 1, 15, color, true).
}