## About

This script function is to recover executable (.exe) files on computer that got infected by [Ground.exe, trojan.renamer/grenam or Win32.Grenam.G](https://www.virustotal.com/gui/file/14d875b242fba6b740b407557bca98fd86c59bda7aa0163c5401cef432b2795e)
Please make sure computer that got infected by the trojan/virus/worm is completely disinfected (no Ground.exe or its drop files running) before running this script.
Also **make sure the grenamer trojan you got infected by is the variant that only rename original file and not also infect it** since this script can't handle that.
This script works by renaming back executable (.exe) files that got renamed into g(filename).exe file name pattern.

## Step-by-step on cleaning Ground.exe

These tasks should be executed on clean separate computer:
- download [Kaspersky Rescue Disk iso](https://www.kaspersky.com/downloads/free-rescue-disk)
- burn the .iso into any available thumbdrive you have using programs like [balenaEtcher](https://etcher.balena.io/) or [rufus](https://rufus.ie/en/)

These tasks should be executed on infected computer:
- [fully shut down the computer if you are running windows 8-windows 11](https://www.grenfellinternetcentre.com.au/how-to-fully-shutdown-windows-11/)
- turn on the computer and boot to thumbdrive
- do full scan on the infected computer drive
- shut down then turn on the computer
- after it boots into windows, run this on elevated privilege command prompt (run as administrator): [attrib -s -h *.exe /D /S](https://github.com/mohammed20033/G_rename_fix/blob/main/G_Fix_Renamer.bat)
- run this script

## How To Run

- clone this repository or Download ZIP, then extract or place the script with its folder on easily accessible place like Desktop.
- run command prompt as administrator
- navigate to the script folder (e.g., cd C:\Users\yourusername\Desktop\grenamer-exe-renamer-fix)
- to run the python version, type "python renamer_recovery.py" (without quotation mark) and press enter
- to run the powershell version, type "powershell -executionpolicy bypass -File renamer_recovery.ps1" (without quotation mark) and press enter
- type 1 to find and auto rename all g(filename).exe files thats also having g(filename).ico file in the same folder
- type 2 to list all possible g(filename).exe files and save the results to output_file.txt
- type 3 to rename g(filename).exe from file listed on output_file.txt

## Important Note

- Only run option 3 after you run option 2.
- **After running option 2 you will need to manually take out any potentially original file names from output_file.txt file list by yourself. To do this, open output_file.txt in notepad, delete the original file name row (for example, C:\laragon\bin\git\mingw64\bin\git.exe, C:\laragon\bin\git\usr\bin\gkill.exe), then save.** This is to prevent script accidentally removing letter g from untouched .exe file name. Guide on how to find whether file listed is having its original name or not is shown after option 2 is done running.
- Scripts tested on python version 3.10 and powershell 5.1. Script might work on python 2.7 and 3.x but untested on powershell 2.0.
- Its preferred to run the powershell script version, but you can always try running each version (not simultaneously).
