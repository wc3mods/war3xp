# Warcraft 3 XP - AMX Mod X Plugin

> ⚠️ **DEPRECATION NOTICE**: This repository is no longer maintained and will receive no further updates. Please use the https://github.com/wc3mods/war3ft version instead for the latest features and improvements (it branched from the original war3 mod).

The original Counter-Strike plugin that brings Warcraft 3 races and skills into your game.

## Overview

Warcraft 3 XP is one of the most authentic Warcraft 3 experiences available for Counter-Strike. Originally developed by Spacedude, this plugin has been maintained and improved while staying true to its roots. The development timeline includes:

- Original development by Spacedude
- Continued development by Dopefish (STEAM, CS, and AMX compatibility updates)
- Current development by Ferret (Lead Developer)

## Features

- Authentic Warcraft 3 races and skills
- Maintains core gameplay mechanics from the original plugin
- Regular updates for compatibility with latest STEAM and CS versions
- Bug fixes and performance improvements
- Clean, original-like codebase

## Running a server

Each release has three builds:

- `war3xp-v…`: short-term XP (nothing is saved between maps)
- `war3xp-nvault-v…`: long-term XP saved with nVault
- `war3xp-mysql-v…`: long-term XP saved to MySQL. Set the connection in `addons/amxmodx/configs/mysql.cfg`; the password can be at most 31 characters.

The MySQL build uses AMX Mod X's legacy DBI natives. On AMX Mod X 1.10 the stock mysql module crashes the server once such a login succeeds (`DatabaseInfo::charset` is left uninitialized in `dbi_connect`). A fix has been submitted to AMX Mod X; until it is released, use a mysql module built with the fix, or the nVault build.

On newer Linux distributions (glibc 2.41+, e.g. Ubuntu 26.04), Metamod cannot load AMX Mod X because its binaries request an executable stack, and AMX Mod X silently doesn't start. Clear the flag with `patchelf --clear-execstack addons/amxmodx/dlls/amxmodx_mm_i386.so`.

To build: `utils/build_release.rb --version 2.6.5 --amxx-version 1.10.0-git5467 [--build-config mysql|nvault]` (needs Docker).

## Credits

- **Spacedude** - Original Developer
- **Dopefish** - Former Lead Developer
- **Ferret** - Most recent Lead Developer
- **Geesu** - Maintaining code base
