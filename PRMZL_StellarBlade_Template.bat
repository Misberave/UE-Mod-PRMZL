@echo off
setlocal EnableDelayedExpansion
:main
::Created and directed by Misberave, with help from AI

::██████╗░██████╗░███╗░░░███╗███████╗██╗░░░░░
::██╔══██╗██╔══██╗████╗░████║╚════██║██║░░░░░
::██████╔╝██████╔╝██╔████╔██║░░███╔═╝██║░░░░░
::██╔═══╝░██╔══██╗██║╚██╔╝██║██╔══╝░░██║░░░░░
::██║░░░░░██║░░██║██║░╚═╝░██║███████╗███████╗
::╚═╝░░░░░╚═╝░░╚═╝╚═╝░░░░░╚═╝╚══════╝╚══════╝
::(Pack Rename Move Zip Launch)

::Script to automate the Unreal Engine modding pipeline needed to test and share mods from packaging to testing with automatic readme creation, customize settings below.
::https://github.com/Misberave

:: ======================================
:: CONFIGURATION - Set your values here, all in ""
:: ======================================

: Unreal Engine AutomationTool RunUAT.bat Path
set RUNUAT_PATH="M:\UE_4.26\Engine\Build\BatchFiles\RunUAT.bat"

: Unreal Engine cmd Path
set ENGINE_PATH=M:\UE_4.26\Engine\Binaries\Win64\UE4Editor-Cmd.exe

:: Unreal Project Path
set PROJECT_PATH=C:\Users\XXX\Documents\Unreal Projects\StellarBlade\SB.uproject

:: UE Package Directory
set ARCHIVE_DIR="M:\Modding_Data\StellarBlade"

::IOSTORE
set ENABLE_IOSTORE=1

:: Game Destination Path (Optional for automatic game launch if enabled)
set GAME_PATH="Y:\SteamLibrary\steamapps\common\StellarBladeDemo\SB.exe"

:: Source and Destination paths (Source=Package Directory, Destination=Game ~mods or paks folder)
set SOURCE_PATH="M:\Modding_Data\StellarBladd\WindowsNoEditor\StellarBlade\Content\Paks"
set DESTINATION_PATH="Y:\SteamLibrary\steamapps\common\StellarBladeDemo\SB\Content\Paks\~Mods"

:: Mod Files (can have multiple at once with ChunkID:ModName format seperated with Space)
set MOD_FILES=667:Example

:: Assign mod descriptions for the readme (Optional if readme is enabled)
(
    echo 667: Test
) > mod_descriptions.txt

========================================
::Toggle Optional Features::
========================================

:: Enable ZIP Creation (1 = Yes, 0 = No)
set ENABLE_ZIP=0
:: Enable Game Launch (1 = Yes, 0 = No)
set ENABLE_GAME_LAUNCH=1
:: Enable README Creation (1 = Yes, 0 = No)
set ENABLE_README=0

:: Readme Configuration
set "MOD_AUTHOR=YourName"
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


::End of Configuration Section, Dont edit following
=================================================================================



:: ======================================
:: Helper Function: Load Descriptions into Variables
:: ======================================
for /f "tokens=1,* delims=:" %%A in (mod_descriptions.txt) do (
    set "DESC[%%A]=%%B"
)

title UE Modding PRMZL

:: ======================================
:: Step 1: Run the Packing Process
:: ======================================

:: Starte das UE Packaging mit optionalem IOSTORE
echo Running UE BuildCookRun...

if "%ENABLE_IOSTORE%" == "1" (
    call %RUNUAT_PATH% BuildCookRun ^
        -nocompileeditor -installed -nop4 ^
        -project="%PROJECT_PATH%" ^
        -cook -stage -archive -archivedirectory="%ARCHIVE_DIR%" ^
        -package -ue4exe="%ENGINE_PATH%" ^
        -compressed -ddc=InstalledDerivedDataBackendGraph -iostore -pak ^
        -prereqs -manifests -targetplatform=Win64 ^
        -build -target=End -clientconfig=Shipping -utf8output
) else (
    call %RUNUAT_PATH% BuildCookRun ^
        -nocompileeditor -installed -nop4 ^
        -project="%PROJECT_PATH%" ^
        -cook -stage -archive -archivedirectory="%ARCHIVE_DIR%" ^
        -package -ue4exe="%ENGINE_PATH%" ^
        -compressed -ddc=InstalledDerivedDataBackendGraph -pak ^
        -prereqs -manifests -targetplatform=Win64 ^
        -build -target=End -clientconfig=Shipping -utf8output
)

if %errorlevel% neq 0 (
    echo ERROR: Packing process failed. Aborting!
    pause
    exit /b
)

echo Packing completed successfully!
echo.

chcp 65001 > nul 2>nul

:: ======================================
:: Step 2: Start the Renaming and Moving Process
:: ======================================
:: Remove quotation if needed
for %%I in (%SOURCE_PATH%) do set SOURCE_PATH=%%~I
for %%I in (%DESTINATION_PATH%) do set DESTINATION_PATH=%%~I

echo Starting the renaming and moving process...

if not exist "%SOURCE_PATH%" (
    echo ERROR: Source folder does not exist! Path: "%SOURCE_PATH%" >nul 2>nul
    pause
    exit /b
)

if not exist "%DESTINATION_PATH%" (
    echo Destination folder does not exist. Creating folder... >nul 2>nul
    mkdir "%DESTINATION_PATH%" >nul 2>nul
)

for %%S in (%MOD_FILES%) do (
    for /f "tokens=1,2 delims=:" %%A in ("%%S") do (
        set "PAKCHUNK_ID=%%A"
        set "MOD_NAME=%%B_P"
        set "MOD_README_NAME=%%B"
        set "MOD_DESC=!DESC[%%A]!"

        echo Processing Mod File: !MOD_NAME!...

        for %%E in (.utoc .ucas .pak) do (
            if exist "!SOURCE_PATH!\pakchunk!PAKCHUNK_ID!-WindowsNoEditor%%E" (
                move "!SOURCE_PATH!\pakchunk!PAKCHUNK_ID!-WindowsNoEditor%%E" "!DESTINATION_PATH!\!MOD_NAME!%%E" >nul 2>nul
                echo File moved: pakchunk!PAKCHUNK_ID!-WindowsNoEditor%%E
            ) else (
                echo WARNING: File not found -> "!SOURCE_PATH!\pakchunk!PAKCHUNK_ID!-WindowsNoEditor%%E" >nul 2>nul
            )
        )
    )
)


:: ======================================
:: Step 2.5: Create README File (Optional)
:: ======================================
if "%ENABLE_README%" == "1" (
    if "%README_MODE%" == "1" (
        echo Creating individual READMEs...
        for %%S in (%MOD_FILES%) do (
            for /f "tokens=1,2 delims=:" %%A in ("%%S") do (
                set "MOD_README_NAME=%%B"
                set "MOD_DESC=!DESC[%%A]!"

                if not exist "!DESTINATION_PATH!" (
                    echo ERROR: Destination folder does not exist for individual README creation.
                    pause
                    exit /b
                )

                echo === README for !MOD_README_NAME! === > "!DESTINATION_PATH!\ReadMe_!MOD_README_NAME!.txt"
                echo Autor: %MOD_AUTHOR% >> "!DESTINATION_PATH!\ReadMe_!MOD_README_NAME!.txt"
                echo Date Created: %MOD_DATE% >> "!DESTINATION_PATH!\ReadMe_!MOD_README_NAME!.txt"
		if not "%LINK%"=="" echo More Info: %LINK% >> "!DESTINATION_PATH!\ReadMe_!MOD_README_NAME!.txt"
                echo. >> "!DESTINATION_PATH!\ReadMe_!MOD_README_NAME!.txt"
                echo Description: !MOD_DESC! >> "!DESTINATION_PATH!\ReadMe_!MOD_README_NAME!.txt"

                if exist "!DESTINATION_PATH!\ReadMe_!MOD_README_NAME!.txt" (
                    echo SUCCESS: Individual README created for !MOD_README_NAME!.
                ) else (
                    echo ERROR: Failed to create individual README for !MOD_README_NAME!.
                )
            )
        )
    ) else if "%README_MODE%" == "2" (
        if not exist "!DESTINATION_PATH!" (
            echo ERROR: Destination folder does not exist for Summary README.
            pause
            exit /b
        )

        echo Creating Summary README...
        (
            echo === Readme ===
            echo Author: %MOD_AUTHOR%
            echo Date Created: %MOD_DATE%
	    if not "%LINK%"=="" echo More Info: %LINK%
            echo.
            echo === Mod Descriptions ===
        ) > "!DESTINATION_PATH!\%ALL_MODS_README%"

     for %%S in (%MOD_FILES%) do (
    	for /f "tokens=1,2 delims=:" %%A in ("%%S") do (
        	set "MOD_NAME=%%B"
        set "MOD_DESC=!DESC[%%A]!"
            echo !MOD_NAME!: !MOD_DESC! >> "!DESTINATION_PATH!\%ALL_MODS_README%"
    )
)


        if exist "!DESTINATION_PATH!\%ALL_MODS_README%" (
            echo SUCCESS: Summary README created at "!DESTINATION_PATH!\%ALL_MODS_README%".
        ) else (
            echo ERROR: Failed to create Summary README.
        )
    )
)


:: ======================================
:: Step 3: Create ZIP Archive (Optional, using PowerShell)
:: ======================================
if "%ENABLE_ZIP%" == "1" (
    for %%S in (%MOD_FILES%) do (
        for /f "tokens=1,2 delims=:" %%A in ("%%S") do (
            set "MOD_NAME=%%B_P"
            set "MOD_README_NAME=%%B"

            echo Creating ZIP archive for !MOD_NAME!... 
            pushd "%DESTINATION_PATH%"

            :: Reset ZIP Content
            set "ZIP_FILES="

            :: Add only existing files
            if exist "!MOD_NAME!.pak" set "ZIP_FILES=!ZIP_FILES! , '!MOD_NAME!.pak'"
            if exist "!MOD_NAME!.utoc" set "ZIP_FILES=!ZIP_FILES! , '!MOD_NAME!.utoc'"
            if exist "!MOD_NAME!.ucas" set "ZIP_FILES=!ZIP_FILES! , '!MOD_NAME!.ucas'"

            if "%ENABLE_README%" == "1" (
                if "%README_MODE%" == "1" (
                    if exist "ReadMe_!MOD_README_NAME!.txt" set "ZIP_FILES=!ZIP_FILES! , 'ReadMe_!MOD_README_NAME!.txt'"
                ) else if "%README_MODE%" == "2" (
                    if exist "%ALL_MODS_README%" set "ZIP_FILES=!ZIP_FILES! , '%ALL_MODS_README%'"
                )
            )

            :: Remove leading comma (only for correct syntax)
            set "ZIP_FILES=!ZIP_FILES:~2!"

            :: Check if we have files to zip
            if not "!ZIP_FILES!" == "" (
                powershell -Command "& { Compress-Archive -Path @(!ZIP_FILES!) -DestinationPath '!MOD_NAME!.zip' -Force }"
                if exist "!MOD_NAME!.zip" (
                    echo SUCCESS: ZIP archive created for !MOD_NAME!.
                ) else (
                    echo ERROR: ZIP archive was not created for !MOD_NAME!.
                )
            ) else (
                echo WARNING: No valid files found for !MOD_NAME!, skipping ZIP creation.
            )

            popd
        )
    )
)

color %COLOR_FINISH%
:: ======================================
:: Step 4: Start the Game
:: ======================================
if "%ENABLE_GAME_LAUNCH%" == "1" (
    echo Starting the game...
    start "" %GAME_PATH%
) else (
    echo Game launch skipped.
)



del mod_descriptions.txt

@echo off
color %COLOR_FINISH%
echo "▓█████▄  ▒█████   ███▄    █ ▓█████ 
echo "▒██▀ ██▌▒██▒  ██▒ ██ ▀█   █ ▓█   ▀ 
echo "░██   █▌▒██░  ██▒▓██  ▀█ ██▒▒███   
echo "░▓█▄   ▌▒██   ██░▓██▒  ▐▌██▒▒▓█  ▄ 
echo "░▒████▓ ░ ████▓▒░▒██░   ▓██░░▒████▒
echo " ▒▒▓  ▒ ░ ▒░▒░▒░ ░ ▒░   ▒ ▒ ░░ ▒░ ░
echo " ░ ▒  ▒   ░ ▒ ▒░ ░ ░░   ░ ▒░ ░ ░  ░
echo " ░ ░  ░ ░ ░ ░ ▒     ░   ░ ░    ░   
echo "   ░        ░ ░           ░    ░  ░
echo " ░                                 
echo.
echo.

echo Have fun
echo Press [P] to Restart or any other key to Exit.
choice /C P /N /M "Press P to Restart, any other key to Exit: "

if errorlevel 1 goto main

echo Press any key to close.
exit

pause
