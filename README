# wow_build information

There's not much to this repo.  The main point is to version control two
scripts.  I do my main development on Fedora running in WSL2 on Windows.

## localbuild.sh

This script uses BigWigs packager to package the current mod and install it
for all WoW clients for which is supported using the symlinks in the top level.
This is a quick way to get test code into a client where I can actually do
something with it.

## luacheck.sh

This script just uses the `.luacheckrc` to run a check against the code for a
particular mod. I'll periodically update the globals list in the config so
that it doesn't produre warnings for valid functions, but this does help me
discover typos in global function names and values or attempts to overwrite
built-in game functionality.

Someday I might consider trying to check out and walk all the WoW code for
a list of known globals so that I don't have to manually add what I want to
use... someday.

The luacheck program needs to be intsalled in `luarocks/bin/luacheck`

If you have `luarocks` installed from your distro, something like this will
work (from within the repo):

```luarocks install luacheck --tree luarocks```

## Other Notes

The symlinks point to my own game path through WSL, but they obviously could
point anywhere. `.gitmodules` points to the repos of record that I maintain,
plus one for the packager.

This could arguably be used by anyone for any WoW development where packager
is involved, but your mileage may vary.
