# UE-Mod-PRMZL
Script to automate the Unreal Engine modding pipeline needed to test and share mods from packaging to testing

This batch file can automate almost the whole process AFTER setting up the UnrealEditor project.
This way you dont need to mess around with folder browsing, renaming and zipping the archives by hand and it saves hundreds of mouseclicks in the testing process, which your back and wrist will thank you for.

Features:
- Packing the UE project
- Renaming the pakchunk archives .utoc .ucas .pak
- Moving from Output folder to ~mods folder
- Creating a Readme for each file or one for multiple
- Zipping each mod into its own .zip archive
- Launching the game automatically after to test the mod 
