# Brothers in Arms: Hell's Highway Config (v2.0)

A corrected and tightened configuration for Brothers in Arms: Hell's Highway
(Unreal Engine 3, DirectX 9), tuned for high-end PCs and ultrawide
3440x1440 displays.

v2 is an audit of v1, not just a retune. Large parts of v1 set values the
engine never reads, or values it cannot honour (a 24 GB texture pool in a
32-bit process, 8192 px texture groups in an engine capped at 4096). v2
keeps everything that worked, removes everything that did not, and says so
in AUDIT.md.

## What actually improves the picture

- Full authored texture resolution at all distances (LODBias=0,
  MaxLODSize=4096, the UE3 maximum), 16x anisotropic filtering.
- A texture streaming pool sized for a 32-bit process: 1024 MB stock,
  2048 MB with the HD override in user-config/.
- Real shadow controls in the section the engine reads them from
  (MaxShadowResolution=2048, hardware shadow filtering).
- Frame rate smoothed and capped at 60 by default. Above 60 FPS this game
  increases weapon spread and player damage taken (PCGamingWiki), so the
  cap is a gameplay fix, not a performance limit. The comment in
  BaseEngine.ini shows how to uncap.
- Mouse smoothing off. UI scaling back to 1.0. Debug overlays off.
- Hardware detection extended: RTX 3060 Ti through RTX 5090 added to
  BaseCompat.ini at the top tier, next to the RTX 3090 from v1.

## HD textures

A config cannot make textures high definition, it can only stop the engine
downsampling them. For real HD textures, install a texture pack: since
September 2026 Nexus Mods hosts a full world overhaul (2,818 textures, up
to 4096x4096) and a 4K weapons pack for this game, both installed with
TFC Installer. Full explanation, limits and the do-it-yourself pipeline
are in HD-TEXTURES.md. If you install a pack, also apply the override in
user-config/ and a 4 GB patch to the game executable. Step by step
instructions for Windows and for Linux (Steam Proton), plus helper
scripts that do the backups, the 4 GB patch and the override for you,
are in textures/README.md.

## Installation

Important: Base*.ini files are templates. The game reads Sumac*.ini files
in your Documents folder, generated from the Base files on first run. If
you have run the game before, step 3 is the one that matters.

1. Back up both folders below before changing anything.
2. Copy the Base*.ini files from this repo into:
   <SteamLibrary>\steamapps\common\Brothers in Arms Hells Highway\Engine\Config
3. Then either:
   - Delete SumacEngine.ini, SumacGame.ini, SumacInput.ini and SumacUI.ini
     in Documents\My Games\BIA Hells Highway\SumacGame\Config\ and let the
     game rebuild them from the new Base files on next launch, or
   - Edit your existing Sumac files with the same values by hand.
4. Optional, HD packs only: merge user-config\SumacEngine.ini into your
   SumacEngine.ini after step 3.
5. For anti-aliasing that actually works in this DirectX 9 engine, force
   SGSSAA in NVIDIA Profile Inspector (compatibility flag 0x000010C1), see
   PCGamingWiki. The in-game MaxMultisamples value alone does little.
6. FOV: the durable method is the PCGamingWiki key binding fix in
   SumacInput.ini (FOV command on zoom release, F2 resets FOV for
   cutscenes). The FOVAngle value in BaseGame.ini is kept at 120.

An install script that does steps 1 to 3 with backups is in install.ps1.

## Files

- BaseEngine.ini: engine, streaming, system settings. Heavily corrected.
- BaseGame.ini: gameplay defaults. The invented combat sections from v1
  are removed, with a note explaining why.
- BaseCompat.ini: hardware scoring, modern GPUs added.
- BaseInput.ini: stock bindings, mouse smoothing off.
- BaseUI.ini: UI defaults, debug overlays off, scaling 1.0.
- user-config/SumacEngine.ini: HD texture pack override (PoolSize=2048).
- textures/: HD pack install guide for Windows and Linux, an install
  helper for each, and patch-laa.py (sets the 4 GB flag on the game exe).
- AUDIT.md: every v1 problem found, and what changed.
- HD-TEXTURES.md: how HD textures actually work for this game.
- install.ps1: backup and install helper (Windows).

## Credits

- Config by /u/Sassanix, v2 audit and corrections with Muse.
- Game data and fixes: PCGamingWiki, Brothers in Arms: Hell's Highway.
- Texture support reference: Epic Games UDK documentation,
  Texture Support and Settings.

## License

MIT, see LICENSE.
