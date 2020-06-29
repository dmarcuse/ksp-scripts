@lazyglobal off.

runpath("0:bin/install", false).

if core:bootfilename:matchespattern("^/?boot/install.*(.ksm?)?$") {
	set core:bootfilename to "".
}
