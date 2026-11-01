# HD textures for Brothers in Arms: Hell's Highway

Short answer: yes, the game can run true HD textures, but not from a config
file. A config can only stop the engine from downsampling the textures it
already has. New detail has to come from new texture files.

## The three levels, in order of effort

### 1. Config only (this repo): sharper stock textures, not HD
Stock textures were mostly authored at 512 to 1024 px. Setting
MaxLODSize=4096 and LODBias=0 makes the engine always show the full authored
resolution instead of a lower mip, and MaxAnisotropy=16 keeps them sharp at
an angle. That is the ceiling for the stock files. No .ini value can add
pixels that were never shipped, and negative LODBias values do not upscale
anything.

### 2. Install an existing HD pack (recommended)
Since September 2026 there are real packs on Nexus Mods for this game:

- A full world overhaul: GrimReaper2121's BIAHH HD World 2.0, 3,165
  textures rebuilt, about 12.7 GB, at
  https://www.nexusmods.com/brothersinarmshellshighway/mods/13
- A weapons pack: GrimReaper2121's HD Weapons, about 511 MB, at
  https://www.nexusmods.com/brothersinarmshellshighway/mods/18
  (version 1.0 installed with TFC Installer; 2.0 uses the Brothers in
  Arms Mod Manager, mods/17 on the same site).

Both install through TFC Installer for UE2/UE3, which injects the new
textures into the game's .tfc texture file caches. Two things in this repo
matter for those packs:

- UseTextureFileCache must be True (v1 of this config set it to False,
  which works against .tfc based packs). Fixed in v2.
- Use the HD override in user-config/ (PoolSize=2048) and patch the game
  executable with a 4 GB / Large Address Aware patch. The game is a 32-bit
  DirectX 9 executable; without the patch it runs out of address space
  long before it runs out of VRAM.

Browse the packs: https://www.nexusmods.com/brothersinarmshellshighway
TFC Installer: search Nexus Mods for "TFC Installer for UE2-UE3".
Full step by step install instructions for Windows and Linux, with
helper scripts, are in textures/README.md.

### 3. Build your own pack
The pipeline the packs above use, if you want to make your own:

1. Extract textures from the game's .upk packages with UE Viewer (umodel).
   Hell's Highway is on its supported games list.
2. Upscale the extracted images 2x to 4x with an AI upscaler such as
   Real-ESRGAN or chaiNNer. Keep normal maps separate: upscaling a normal
   map like a colour photo damages it, renormalise after scaling.
3. Inject the results back into the .tfc caches with TFC Installer.
4. Ship it with PoolSize and LOD settings from level 2 above.

## Hard limits

- Unreal Engine 3 renders at most 4096x4096 per texture. Anything larger
  is clamped to the 4096 mip, so authoring at 8192 wastes disk and memory.
- Upscaling recovers apparent sharpness, it does not recover detail the
  original artists never drew. Expect cleaner, not remastered.
- Geometry, draw distance and lighting do not change with texture packs.
  For the remaining visual gap, ReShade (sharpening, colour) and driver
  level SGSSAA do more than any .ini edit.
