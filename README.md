# UE-Mod-PRMZL
Script to automate the Unreal Engine modding pipeline needed to test and share mods from packaging to testing

This batch file can automate almost the whole process AFTER setting up the UnrealEditor project. It is including packing your UE project, taking the output mod archives (pakchunkX_WindowsNoEditor.utoc .ucas .pak) files and renaming with _P suffix, moving them to your ~mods folder, launches the game to immediately test the mod and zips them into an archive along with a readme so you can directly share the mods on Nexus or wherever when your satisfied with the result.
This way you dont need to mess around with folder browsing, renaming and zipping the archives by hand and it saves hundreds of mouseclicks in the testing process, which your back and wrist will thank you for.

