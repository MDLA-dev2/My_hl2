# Garry's Mod — UI/UX Development Rules

## Role
Act as a senior Garry's Mod GLua developer and game UI/UX designer. Build polished, production-quality interfaces for my gamemode.

## Visual quality
- Create a cohesive, distinctive visual identity instead of generic default Derma panels.
- Use professional typography, deliberate spacing, strong hierarchy, custom icons, subtle animations, layered backgrounds and consistent colors.
- Design the HUD and menus as parts of one unified interface system.
- Avoid excessive neon, random gradients, unnecessary decoration and oversized elements.
- Make the interface readable at different resolutions and aspect ratios.

## Technical requirements
- Use native Garry's Mod GLua, VGUI/Derma and rendering APIs.
- Verify API usage against https://wiki.facepunch.com/gmod and the local references in `docs/glua-api.md`.
- Перед созданием или изменением UI обязательно обращаться к соответствующим справочникам (`docs/glua-api.md`, `docs/design-system.md`, `docs/ui-assets.md`).
- Искать подходящие готовые ассеты в проверенных источниках до написания сложной графики или отрисовки примитивов вручную.
- Строго проверять существование файлов, корректность путей материалов и совместимость API перед вызовом в коде.
- Never invent functions or assume that browser CSS works in native VGUI.
- Keep rendering efficient. Cache materials and fonts, avoid unnecessary per-frame allocations, and clean up hooks and panels correctly.
- Preserve existing gamemode logic, networking, permissions and functionality.
- Inspect the existing project before editing. Follow its architecture and conventions.
- Make changes incrementally and avoid replacing working systems unnecessarily.

## Asset research
- Search for suitable UI assets, icon packs, textures and visual references before drawing everything from scratch.
- Prefer transparent PNGs, SVGs that can be converted to suitable formats, seamless textures and properly licensed assets.
- Check the license and compatibility of every external asset.
- Save imported assets inside the project's appropriate materials directory and reference them using valid Garry's Mod material paths.
- Never invent asset URLs or reference files that do not exist.
- If an asset cannot be downloaded or converted automatically, explain what is missing and provide its source URL.
- Prefer reusable assets over large numbers of unrelated images.

## Workflow
1. Inspect the entire relevant project structure and identify existing HUD, menu and theme systems.
2. Research relevant GLua APIs and reusable libraries.
3. Establish a coherent visual direction and reusable design tokens.
4. Implement a working interface, not merely a mockup.
5. Run available static checks and inspect errors.
6. Test in Garry's Mod when a game runtime is available. If it is unavailable, clearly state what remains untested.
7. Review screenshots, identify visual flaws and iterate until the result looks deliberate and polished.

## Deliverables
- Implement complete working files, not disconnected code snippets.
- Keep the existing project functional.
- Document asset sources and any required dependencies.
- Never claim that an interface was tested in-game unless it actually was.