# UE-Mod-PRMZL
Script to automate the Unreal Engine modding pipeline needed to test and share mods from packaging to testing

This batch file can automate almost the whole process AFTER setting up the files in the UnrealEditor project.
This way you dont need to mess around with folder browsing, renaming and zipping the archives by hand and it saves hundreds of mouseclicks in the testing process, which your back and wrist will thank you for.


Features:
- Packing the UE project
- Renaming the pakchunk archives .utoc .ucas .pak
- Moving from Output folder to ~mods folder
- Creating a Readme for each file or one for multiple
- Zipping each mod into its own .zip archive
- Launching the game automatically after to test the mod 

How It Works:

Simply set up the .bat file in an editor for your current project and instead of hitting "package for windows" inside the Editor, you just run the .bat.

Those are the things you need to setup:

:: Unreal Engine Path
set ENGINE_PATH="C:\UEX.XX\Engine\Build\BatchFiles\RunUAT.bat"                       --> Path to the RunUAT.bat file from your Engine folder

:: Unreal Project Path
set PROJECT_PATH="C:\Users\User\Documents\Unreal Projects\Project\Example.uproject"  --> Path to your Unreal Engine Project File

:: UE Package Directory                                                              --> The package directory from your project
set ARCHIVE_DIR="C:\UE_Package_Directory"

:: Game Destination Path (Optional for automatic game launch if enabled)
set GAME_PATH="C:\Path\To\Game.exe"                                                  --> Path to the game exe 

:: Source and Destination paths (Source=Package Directory, Destination=Game ~mods or paks folder) 
set SOURCE_PATH="M:\UE_Package_Directory\WindowsNoEditor\...\Content\Paks"          --> Package directory
set DESTINATION_PATH="Y:\SteamLibrary\steamapps\common\...\...\Content\Paks\~mods"  --> Mods folder where the script moves your renamed mods to

:: Mod Files (can have multiple at once with ChunkID:ModName format seperated with Space)
set MOD_FILES=555:Modname1 556:Mod2Name 557:Mod3Name 558:Mod4Name

:: Assign mod descriptions for the readme (Optional if readme is enabled)
(
    echo 555:Description of your mod
    echo 556:Description of your mod
    echo 557:Description of your mod 
    echo 558:Description of your mod
) > mod_descriptions.txt

========================================
::Toggle Optional Features::
========================================

:: Enable ZIP Creation (1 = Yes, 0 = No)
set ENABLE_ZIP=1
:: Enable Game Launch (1 = Yes, 0 = No)
set ENABLE_GAME_LAUNCH=1
:: Enable README Creation (1 = Yes, 0 = No)
set ENABLE_README=1

:: Readme Configuration
set "MOD_AUTHOR=Misberave"
::Date (Automatic)
set "MOD_DATE=%DATE%"
::Link (Optional)
set LINK=www.Example.com

:: README Mode (1 = Own README for each Mod, 2 = Summary README for multiple Mods)
set README_MODE=1

:: Filename for summary Readme
set ALL_MODS_README=Readme.txt

::Script Color (BG/Text) (0 = Black, 1 = Blue, 2 = Green, 3 = Aqua/Cyan, 4 = Red, 5 = Purple, 6 = Yellow/Brown, 7 = White/Gray, 8 = Dark Gray, 9 = Light Blue, A = Light Green, B = Light Aqua/Cyan, C = Light Red, D = Light Purple/Magenta, E = Light Yellow, F = Bright White)

color 02

::Color when finish
set COLOR_FINISH=01
