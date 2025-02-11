# UE-Mod-PRMZL

██████╗░██████╗░███╗░░░███╗███████╗██╗░░░░░
██╔══██╗██╔══██╗████╗░████║╚════██║██║░░░░░
██████╔╝██████╔╝██╔████╔██║░░███╔═╝██║░░░░░
██╔═══╝░██╔══██╗██║╚██╔╝██║██╔══╝░░██║░░░░░
██║░░░░░██║░░██║██║░╚═╝░██║███████╗███████╗
╚═╝░░░░░╚═╝░░╚═╝╚═╝░░░░░╚═╝╚══════╝╚══════╝
(Pack Rename Move Zip Launch)

This batch file can automate almost the whole process AFTER setting up the files in the UnrealEditor project.
This way you dont need to mess around with folder browsing, renaming and zipping the archives by hand and it saves hundreds of mouseclicks in the testing process, which your back and wrist will thank you for.

### Info: for packing without iostore you can change the Command at Step 1: and remove the "-iostore" so packing, renaming moving launch works just not the zip 
### **Features:**
- Packing the UE project
- Renaming the pakchunk archives .utoc .ucas .pak for multiple chunkIDs 
- Moving from Output folder to ~mods folder
- Creating a Readme for each file or one for multiple
- Zipping each mod into its own .zip archive
- Launching the game automatically after to test the mod

  
### How It Works:

Simply set up the .bat file in an editor for your current project and instead of hitting "package for windows" inside the Editor, you just run the .bat.



### Those are the things you need to setup:


set ENGINE_PATH="C:\UEX.XX\Engine\Build\BatchFiles\RunUAT.bat"
- Path to the RunUAT.bat 

set PROJECT_PATH="C:\Users\User\Documents\Unreal Projects\Project\Example.uproject"
- Path to your project file

set ARCHIVE_DIR="C:\UE_Package_Directory"
- Package directory (same as Source Path)

set GAME_PATH="C:\Path\To\Game.exe" 
- Path to game for automatic launch

set SOURCE_PATH="M:\UE_Package_Directory\WindowsNoEditor\...\Content\Paks"   
- Package Directory 

set DESTINATION_PATH="Y:\SteamLibrary\steamapps\common\...\...\Content\Paks\~mods" 
- Destination=Game ~mods or paks folder)


set MOD_FILES=555:Modname1 556:Mod2Name 557:Mod3Name 558:Mod4Name 
- ChunkID:ModName format, can be multiple seperated with Space, defines what your packed chunks will be renamed to (_P gets added automatically)

(
    echo 555:Description of your mod
    echo 556:Description of your mod
    echo 557:Description of your mod  
    echo 558:Description of your mod
) > mod_descriptions.txt
- Assign mod descriptions for the readme, one line for each mod (Optional if readme is enabled)

set ENABLE_ZIP=1 
- Enables automatic zip file creation for each mod

set ENABLE_GAME_LAUNCH=1 
- Enables automatic launch of the game for testing of the mod

set ENABLE_README=1    
- Enables readme creation

Readme Configuration  
- Header content of the Readme

set "MOD_AUTHOR=YourName"

Date (Automatic)
set "MOD_DATE=%DATE%"

Link (Optional)
set LINK=www.Example.com

set README_MODE=1 
- README Mode (1 = Own README for each Mod, 2 = Summary README for multiple Mods)

set ALL_MODS_README=Readme.txt 
- Filename for summary Readme
