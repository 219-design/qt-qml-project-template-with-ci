TL;DR: you can ignore the broken link in this repository. It's not hurting anything.

The "notable content" in this directory is a symlink:

clang_64 -> macos

Unless you have run 100% of the provisioning scripts, the symlink is likely
a broken symlink.

The reason this repo intentionally contains a broken symlink is to pro-actively
have the link/alias in place, so that when Qt macos libs are later installed,
all toolchains and scripts and makefiles "just work," regardless of whether they
expect to find the macos libs under "macos/" or under "clang_64/".

The `clang_64` will be a broken symlink in many cases, and that is expected and
acceptable.

To "unbreak" the broken link, one would run:

tools/ci/get_qt_libs_aqt_mac.sh

However, there is no need to run the script and no need to "unbreak" the link
unless you plan to compile the MacOS version of the app.

Finally, note that this README also plays a key role, beyond its normal, obvious
explanatory role. The additional purpose of the README is to preserve this
folder on the special branch named "cookiecutter." If we do not commit at least
one non-symlink file in this directory, then our automated process that creates
the "cookiecutter" branch will omit this directory, which would cause one or
more scripts to break when a downstream cookiecutter user tries to instantiate a
copy of this template repo.
