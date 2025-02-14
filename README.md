# Brothers in Arms: Hell's Highway Config (v1.0)

Welcome to the Version 1 release of this custom configuration for Brothers in Arms: Hell's Highway. This release is engineered to unlock the full potential of high-end systems (Up to 24 GB VRAM, and 32 GB RAM) and optimize gameplay on ultra-wide monitors (3440×1440).

## Screenshots

![15390_44](https://github.com/user-attachments/assets/d236fc6a-b23e-4b36-8197-32ddec6f6bba)
![15390_43](https://github.com/user-attachments/assets/5e730e5d-87c1-4b1d-959f-5e53a2adfd75)
![20250212143327_1](https://github.com/user-attachments/assets/41ca94a1-a3d4-437f-8fa5-e2da4fc6ad44)

---

## Overview

This configuration enhances your gaming experience by:
- **Optimizing Graphics & Visuals:** Improved texture streaming, advanced shadow filtering, and optimized lighting settings deliver richer, more immersive visuals.
- **Ultra-Wide Monitor Support:** Adjusted Field-of-View (FOV) and UI scaling ensure a flawless display on ultrawide screens.
- **Enhanced Combat & Gameplay:** Custom combat tweaks integrated in BaseGame.ini boost visual effects, precise hit detection, dynamic ragdoll physics, and smarter AI.
- **Optimized Audio & Input:** Fine-tuned audio settings and responsive input bindings provide a more engaging and fluid gameplay experience.
- **Robust Performance:** Tweaks across multiple configuration files ensure stability and peak performance on high-end hardware.

---

## Key Enhancements

- **Ultra-Wide Monitor Support:**
  - Enhanced FOV and UI scaling tailored for 3440×1440 displays.
  
- **Enhanced Graphics & Visual Quality:**
  - Upgraded texture streaming and lighting/shadow settings.
  - Adjusted BaseCompat.ini to properly recognize and leverage my RTX 3090 and AMD Ryzen 7 5800X, please adjust the Basecompat.ini to your hardware.
  
- **Optimized Combat Settings:**
  - Added custom sections in BaseGame.ini ([CombatEffects], [CombatSimulation]) to maximize combat visual effects and simulation.
  
- **Optimized Audio & Input:**
  - Fine-tuned configurations in BaseInput.ini and BaseUI.ini ensure responsive controls and a clear, well-scaled interface.

- **Improved Hardware Detection:**
  - BaseCompat.ini now includes revised thresholds for CPU speed, memory, and a dedicated entry for the RTX 3090 (Device ID 0x2204), please add your own by using Gpu-Z.
 
- **Enhanced Loading Performanc:**
  - Optimized asset streaming settings minimize load times by fully utilizing modern NVMe drives and SSD storage.  

---

## Installation Instructions

1. **Locate the Config Folder:**
   - On Steam, navigate to:
     ```
     X:\SteamLibrary\steamapps\common\Brothers in Arms Hells Highway\Engine\Config
     ```

2. **Backup Existing Files:**
   - Back up your current configuration files (e.g., BaseEngine.ini, BaseGame.ini, BaseCompat.ini, BaseInput.ini, BaseUI.ini) so you can restore them if needed.

3. **Replace the Config Files:**
   - Copy the provided configuration files into the folder, replacing the existing ones.

4. **Apply Additional Tweaks:**
   - For further adjustments and game data tweaks, refer to the [PCGamingWiki guide](https://www.pcgamingwiki.com/wiki/Brothers_in_Arms:_Hell's_Highway#Game_data).

5. **Optional – Enhance Visuals with Shaders:**
   - To further improve graphics, consider using advanced shaders such as DPX, Adaptive Sharpen, and Levels.
   - Visit [Reshade](https://reshade.me/) to download and apply your preferred shader presets.

---

## Files Included

- **BaseEngine.ini:** Enhanced engine settings, texture streaming, lighting, and more.
- **BaseGame.ini:** Custom combat and gameplay tweaks for high-end visuals and simulation.
- **BaseCompat.ini:** Adjusted hardware detection settings for proper classification of high-end components.
- **BaseInput.ini & BaseUI.ini:** Fine-tuned input bindings and UI scaling optimized for ultra-wide displays.
- **Additional Config Files:** Editor settings and key-binding configurations.

---

## Credits & Resources

- **Config by:** /u/Sassanix
- **Additional Tweaks & Game Data:**  
  [PCGamingWiki - Brothers in Arms: Hell's Highway](https://www.pcgamingwiki.com/wiki/Brothers_in_Arms:_Hell's_Highway#Game_data)
- **Shader Enhancements:**  
  [Reshade](https://reshade.me/)

---

## License

This project is released under the MIT License. See the [LICENSE](LICENSE) file for details.

---

Enjoy your enhanced gaming experience with improved visuals, optimized performance, and a smoother overall gameplay experience!
