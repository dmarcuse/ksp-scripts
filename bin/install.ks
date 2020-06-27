@lazyglobal off.

// installs all code from the archive, optionally compiling .ks files and copying .ksm files

declare parameter keepsource is false.

declare function installdir {
	declare parameter basepath is "/".

	declare local installed is 0.
	declare local usedspace is 0.

	cd("0:" + basepath).
	declare local items is 0.
	list files in items.

	for item in items {
		if not item:name:startswith(".") {
			declare local fpath is basepath + item:name.
			if item:isfile {
				if item:extension = "ks" {
					print "Installing " + fpath.
					set installed to installed + 1.
					if keepsource {
						copypath(fpath, "1:" + fpath).
						set usedspace to usedspace + item:size.
					} else {
						declare local newpath is "1:" + fpath + "m".
						compile fpath to "1:" + fpath + "m".

						if item:size < open(newpath):size {
							// compiled program larger than source - copy it directly
							deletepath(newpath).
							copypath(fpath, "1:" + fpath).
							set usedspace to usedspace + item:size.
						} else {
							set usedspace to usedspace + open(newpath):size.
						}
					}
				}
			} else {
				deletepath("1:" + fpath).
				set installed to installed + installdir(fpath + "/").
			}
		}
	}

	return installed.
}

declare local oldpath is path().

cd("0:").
hudtext("Successfully installed " + installdir() + " files.", 3, 1, 24, green, true).
cd(oldpath).