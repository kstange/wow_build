# wow_build information

There's not much to this repo.  The main point is to version control two
scripts I use for WoW development and related configuration data.  I do my
development in vim on Fedora running in WSL2 on Windows 11.

## localbuild.sh

This script uses BigWigs packager to package the current addon and install it
for all WoW clients for which it's supported using the symlinks in the top level.
This is a quick way to get test code into a client where I can actually do
something with it.

## luacheck.sh

This script uses the `.luacheckrc` to run a check against the code for a
particular addon. I'll periodically update the globals list in the config so
that it doesn't produce warnings for valid functions. This helps me
discover typos in global function names and values or attempts to overwrite
built-in game functionality, as well as things like global misuse inside of
functions.

I might someday consider trying to check out and walk all the WoW code for a
list of known globals so that I don't have to manually add what I want to use.
Maybe.

The luacheck program needs to be installed in `luarocks/bin/luacheck`

If you have `luarocks` installed from your distro, something like this will
work (from within the repo):

```bash
luarocks install luacheck --tree luarocks
```

## Other Notes

The symlinks point to my own game paths through WSL, but they obviously could
point anywhere. `.gitmodules` points to the packager so it's easy to find when
setting up the repo.

This could arguably be used by anyone for any WoW development where packager
is involved, but your mileage may vary.
