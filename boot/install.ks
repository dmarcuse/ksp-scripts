@lazyglobal off.

runpath("0:bin/install").

if core:bootfilename:matchespattern("^/?boot/install(.ksm?)?$") {
	set core:bootfilename to "/bin/startgui".
}

reboot.