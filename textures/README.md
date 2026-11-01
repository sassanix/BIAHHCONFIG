# HD textures: download and install guide

## Why the texture files are not in this repo

Two hard reasons, not a choice:

- Size. The full world pack is about 7.2 GB. GitHub blocks any single file
  over 100 MB in a normal git push, and release assets cap at 2 GB per
  file. The pack cannot physically live here.
- Rights. The packs are other modders' work built on the game's own
  textures. They belong on their Nexus Mods pages, where the authors
  control them. This repo links to them and gives you the tooling around
  them instead.

## The packs

Download both from Nexus Mods (free account required to download):

- World overhaul: GrimReaper2121's BIAHH HD World 2.0, 3,165 textures
  rebuilt, current file about 12.7 GB (the original 1.0 from September
  2026 was 2,818 textures, 7.2 GB, and is kept on the page as an
  archived file).
  https://www.nexusmods.com/brothersinarmshellshighway/mods/13
- Weapons: GrimReaper2121's HD Weapons, current file about 511 MB.
  Note the install change: 1.0 installed with TFC Installer, 2.0
  installs with the Brothers in Arms Mod Manager instead (next link).
  If 1.0 is installed, uninstall it with TFC Installer first.
  https://www.nexusmods.com/brothersinarmshellshighway/mods/18
- Brothers in Arms Mod Manager (needed for the weapons pack 2.0):
  https://www.nexusmods.com/brothersinarmshellshighway/mods/17
- Game page: https://www.nexusmods.com/brothersinarmshellshighway

You also need:

- TFC Installer for UE2-UE3 (Nexus Mods, Modding Tools, by BenDerrick):
  https://www.nexusmods.com/site/mods/588
- The .NET 6 runtime (the installer will not start without it).

Install order matters: this repo's config first (see the main README),
then the Large Address Aware patch, then the packs, then the PoolSize
override. The helper scripts on this page do steps 2 and 4 for you and
walk you through step 3. The scripts drive TFC Installer, which is the
install path for the world pack and for weapons pack 1.0; for weapons
pack 2.0, follow the Mod Manager instructions on its Nexus page after
the same preparation steps.

## Windows

1. Install the v2 config from this repo (install.ps1 in the repo root).
   Run the game once and quit, so it generates its Sumac*.ini files.
2. Download the packs and extract each archive. A pack is ready when its
   folder contains a GameProfile.xml file.
3. Prepare the game (backups, Large Address Aware, PoolSize=2048):

   ```powershell
   cd textures
   .\install-textures.ps1 -GamePath "D:\SteamLibrary\steamapps\common\Brothers in Arms Hells Highway" -ModFolder "D:\Mods\BIAHH-HD-World" -TFCInstaller "D:\Tools\TFCInstaller.exe"
   ```

   No Python installed? The script still backs everything up and applies
   the config override, and prints how to set the LAA flag with a GUI
   4 GB patcher instead.
4. In TFC Installer (the script launches it if you passed its path):
   - Set the game folder to your game folder.
   - Set the mod folder to the extracted pack folder.
   - Click Update All and let it finish. It backs up the original game
     packages itself while it works.
5. Repeat steps 3 and 4 for the weapons pack.
6. Launch the game. First load of each level is slower while the new
   textures stream in; that settles after a minute in the level.

## Linux (Steam Proton)

The game is Steam app 15390. Everything Windows does to the game folder
works the same, because Proton reads the same files. The config the game
actually reads lives inside the Proton prefix, under
steamapps/compatdata/15390/pfx/, which is why the helper script exists.

1. Install the game in Steam and run it once, then quit. In Steam,
   Properties, Compatibility, a current Proton version is fine.
2. Install the v2 config's Base files into the game folder
   (steamapps/common/Brothers in Arms Hells Highway/Engine/Config), the
   same as on Windows.
3. Download the packs and TFC Installer on the host, extract the packs.
   Each extracted pack folder must contain GameProfile.xml.
4. Prepare the game and launch the installer inside the prefix:

   ```bash
   cd textures
   chmod +x install-textures.sh
   ./install-textures.sh --game-path "$HOME/.steam/steam/steamapps/common/Brothers in Arms Hells Highway" --mod-folder "$HOME/Downloads/BIAHH-HD-World" --tfc-installer "$HOME/Downloads/TFCInstaller.exe"
   ```

   The script sets the Large Address Aware flag natively (no Wine needed
   for that part), finds SumacEngine.ini inside the prefix, and sets
   PoolSize=2048 there.
5. The installer needs the .NET 6 Windows runtime inside the prefix. If
   it does not start, run: protontricks 15390 dotnetdesktop6, then
   re-run the script. Inside the installer, folders are picked through
   Wine, so your Linux paths appear under the Z: drive. Set the game
   folder, set the mod folder, click Update All.
6. Option B, if the installer will not run under Wine at all: the files
   it changes live in the shared game folder, so you can run the
   installer on any Windows machine or VM pointed at a copy of the game
   folder, then copy the modified game folder back. The Proton prefix
   and its config do not need to move.
7. Repeat for the weapons pack, then play through Steam as normal.

Steam Deck: the same steps work in Desktop Mode. Put the library path
where --game-path expects it (usually
$HOME/.local/share/Steam/steamapps/common/... or the SD card library).

## Verify it worked

- In game, get close to a brick wall, a uniform, and your rifle. With the
  world and weapons packs in, all three should be visibly sharper than
  stock at arm's length, not just at a distance.
- If textures still look stock, the usual causes are: PoolSize override
  applied to the wrong SumacEngine.ini (check the timestamp inside your
  Documents folder or prefix), the pack installed into a second copy of
  the game folder, or DetailMode not at 2 (the v2 config sets it).

## Uninstall

- Open TFC Installer, set the same game folder, and use Uninstall All.
  It restores the original packages from the backups it made.
- Restore the .exe from the .bak file patch-laa.py wrote next to it
  (or verify the game files in Steam, which also resets the config
  templates, so back up your Sumac*.ini files first if you want to keep
  the v2 settings).
- Set PoolSize back to 1024 in SumacEngine.ini, or delete the file and
  let the game rebuild it from the Base templates.
