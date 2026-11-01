# v1 audit: what was wrong and what v2 changed

Every finding below was checked against how Unreal Engine 3 actually reads
its config files. UE3 ignores unknown keys silently, which is why v1 looked
fine in a text editor while large parts of it did nothing in game.

## Settings that did nothing at all (removed)

- BaseGame.ini: the [CombatEffects] and [CombatSimulation] sections.
  No game class reads those sections. bPreciseHitDetection,
  DamageCalculationPrecision, bEnableDynamicRagdoll and friends were
  invented and had zero effect.
- BaseEngine.ini [SystemSettings]: bAllowCascadedShadowMaps, NumCascades
  and CascadeDistributionExponent (Unreal Engine 4 shadow system; UE3 has
  whole scene shadow, no cascades).
- bEnableSSGI and bUseScreenSpaceReflections / SSR.Quality (screen space
  effects that do not exist in this engine).
- bUseTemporalAA (UE3 DirectX 9 has no temporal anti-aliasing).
- bUseVolumetricFog, bUseHighQualityFog, bUseHighQualityWater,
  WaterDetailQuality, bUseWaterRefraction, bUseHighQualityPhysics,
  bAllowPhysicsInteractions, bEnableRagdollPhysics, bEnableHDR and the
  PP_ colour multipliers in [SystemSettings] (the PP_ keys only work in
  [Engine.Player], where v1 already had them).
- The whole [Terrain] block at the end of BaseEngine.ini: foliage density,
  shadow distance and reflection keys placed in a section the renderer
  never reads for those values. Real shadow size keys now live in
  [SystemSettings] where they belong (MaxShadowResolution=2048).
- The [SpeedTree] wind keys and [Engine.PhysicsSettings] substeps block:
  not read from this file by this game.

## Settings that were real but set to harmful or impossible values (fixed)

- [TextureStreaming] PoolSize=24000. The value is in MB and the game is a
  32-bit process with about 2 GB of address space. It could never use a
  24 GB pool; the practical effect is streaming thrash and out-of-memory
  crashes. Now 1024 for stock textures, 2048 via the HD override.
- MaxTextureMipBias=-3 in [TextureStreaming]: not a key the streaming
  system uses. Removed.
- UseTextureFileCache=False: works against HD texture packs, which are
  delivered as .tfc caches. Now True.
- TEXTUREGROUP MaxLODSize=8192: UE3 caps rendered textures at 4096x4096
  (13 mips). 8192 was clamped by the engine. Now 4096.
- TEXTUREGROUP LODBias=-3 (and -6 for foliage): LODBias is an offset from
  the authored size, not an upscaler. Negative values cannot add detail,
  they only inflate memory use and shimmer. Now 0 everywhere, which means
  full authored resolution at all distances.
- SkeletalMeshLODBias=-3 and StaticMeshLODDistanceScale / ViewDistanceScale
  set to extremes (0.001 / 30.0): LOD bias clamps at 0 in practice. Now 0,
  and the nonstandard distance keys are gone.
- MaxMultisamples=16: not achievable here and generally not honoured by
  DirectX 9 UE3 in game. Now 4, with the real fix documented (force SGSSAA
  in NVIDIA Profile Inspector, compatibility flag 0x000010C1).
- MaxShadowResolution=8192 under the wrong section: shadow maps share one
  atlas, 8192 is not attainable in this build. Now 2048 in [SystemSettings].
- Frame rate: v1 disabled smoothing and set a 144 cap. PCGamingWiki
  documents that above 60 FPS this game increases weapon spread and makes
  the player more vulnerable. v2 smooths and caps at 60, with the trade-off
  stated in a comment so it is a choice, not a surprise.
- MinAllowableResolutionX/Y=3440/1440: locked the game out of any lower
  resolution, including windowed testing. Now 640x480.
- Fullscreen=False sat next to claims of fullscreen ultrawide play. Now
  True. ResX/ResY stay 3440x1440.
- UISceneScalingFactor=1.75 (set in two files): oversizes the whole UI.
  Now 1.0 in both.
- BaseUI.ini had seven debug overlay flags set to true (widget paths,
  render bounds, mouse position and more). All now false.
- BaseInput.ini had mouse smoothing on. Now off.

## The install problem v1 never mentioned (fixed in README)

Base*.ini files in the game's Engine\Config folder are only templates.
The game actually reads Sumac*.ini files in
Documents\My Games\BIA Hells Highway\SumacGame\Config\, which it generates
from the Base files on first run. On any install that has already been run
once, replacing the Base files alone changes nothing until the generated
Sumac files are deleted or edited. v2 ships a user-config override and
spells this out in the install steps.

## Kept from v1

- MaxAnisotropy=16, DetailMode=2, trilinear filtering, dynamic shadows and
  decals, full texture groups list: all real, all kept.
- The RTX 3090 entry in BaseCompat.ini, plus v2 adds RTX 3060 Ti through
  5090 at the top score tier.
- FOV work: note that the durable in-game method is the PCGamingWiki key
  binding method in SumacInput.ini (FOV command on zoom release, F2 to
  reset for cutscenes), not the CameraFOV line alone.
