// installs all code from the archive, compiling .ks files and copying .ksm files

declare function installdir {
	declare parameter basepath is "/".

	declare local installed is 0.

	cd("0:" + basepath).
	list files in items.

	for item in items {
		declare local fpath is basepath + item:name.
		if item:isfile {
			if item:extension = "ks" {
				print "Compiling " + fpath.
				set installed to installed + 1.
				compile fpath to "1:" + fpath + "m".
			} else if item:extension = "ksm" {
				print "Copying " + fpath.
				set installed to installed + 1.
				copypath(fpath, "1:" + fpath).
			}
		} else {
			set installed to installed + installdir(fpath + "/").
		}
	}

	return installed.
}

declare local oldpath is path().

cd("0:").
declare local installed is installdir().
hudtext("Successfully installed " + installed + " files.", 3, 1, 15, blue, true).
cd(oldpath).