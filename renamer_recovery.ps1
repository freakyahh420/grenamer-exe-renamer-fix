function Rename-ExeFiles {
    param (
        [string]$directory = "C:\"
    )

    function Process-Directory {
        param (
            [string]$dir
        )

        try {
            Get-ChildItem -Path $dir -Filter "g*.exe" -ErrorAction Stop | ForEach-Object {
                $exePath = $_.FullName
                $originalName = $_.Name.Substring(1)  # Remove the leading 'g'
                $icoPath = Join-Path -Path $_.DirectoryName -ChildPath ("g" + $originalName.Substring(0, $originalName.Length - 4) + ".ico")

                if (Test-Path $icoPath) {
                    $newExePath = Join-Path -Path $_.DirectoryName -ChildPath $originalName
                    try {
                        if (Test-Path $newExePath) {
                            Remove-Item -Path $newExePath -Force
                        }
                        Rename-Item -Path $exePath -NewName $originalName
                        Remove-Item -Path $icoPath -Force
                        Write-Host "Renamed: $exePath to $newExePath and deleted $icoPath"
                    } catch {
                        Write-Host "Error: $_.Exception.Message. Skipping file: $exePath"
                    }
                }
            }
        } catch {
            Write-Host "Access denied to path: $dir. Skipping."
        }

        Get-ChildItem -Path $dir -Directory -ErrorAction SilentlyContinue | ForEach-Object {
            Process-Directory -dir $_.FullName
        }
    }

    Process-Directory -dir $directory
}

function List-ExeFiles {
    param (
        [string]$directory = "C:\",
        [string]$outputFile = "output_file.txt"
    )

    function Process-Directory {
        param (
            [string]$dir
        )

        try {
            Get-ChildItem -Path $dir -Filter "g*.exe" -ErrorAction Stop | ForEach-Object {
                $exePath = $_.FullName
                Add-Content -Path $outputFile -Value $exePath
                Write-Host $exePath
            }
        } catch {
            Write-Host "Access denied to path: $dir. Skipping."
        }

        Get-ChildItem -Path $dir -Directory -ErrorAction SilentlyContinue | ForEach-Object {
            Process-Directory -dir $_.FullName
        }
    }

    Process-Directory -dir $directory
    Write-Host "Files listed in $outputFile."
}

function Rename-FilesFromList {
    param (
        [string]$fileListPath = "output_file.txt"
    )

    if (-Not (Test-Path $fileListPath)) {
        Write-Host "File $fileListPath does not exist. Please list the files first."
        return
    }

    Get-Content -Path $fileListPath | ForEach-Object {
        $exePath = $_.Trim()
        Write-Host "Processing: $exePath"
        if (-Not (Test-Path $exePath)) {
            Write-Host "File not found: $exePath. Skipping."
            return
        }
        $directory = [System.IO.Path]::GetDirectoryName($exePath)
        $file = [System.IO.Path]::GetFileName($exePath)
        Write-Host "Directory: $directory"
        Write-Host "File: $file"
        if ($file -match "^g.+\.exe$") {
            $originalName = $file.Substring(1)  # Remove the leading 'g'
            $newExePath = Join-Path -Path $directory -ChildPath $originalName
            try {
                if (Test-Path $newExePath) {
                    Remove-Item -Path $newExePath -Force
                }
                Rename-Item -Path $exePath -NewName $originalName
                Write-Host "Renamed: $exePath to $newExePath"
            } catch {
                Write-Host "Error: $($_.Exception.Message). Skipping file: $exePath"
            }
        } else {
            Write-Host "File $exePath does not match the pattern. Skipping."
        }
    }
    Write-Host "Renaming completed."
}

function Main {
    while ($true) {
        Write-Host "=========="
        Write-Host "Trojan.Renamer/GRenam Executable File Batch Renamer"
        Write-Host "Please run this script with escalated administrator privilege!"
        Write-Host "=========="
        Write-Host "This script renames back executable files to filename.exe"
        Write-Host "that got renamed into g(filename).exe by the trojan."
        Write-Host "Before running this, please make sure the trojan is removed from the system."
        Write-Host "=========="
        Write-Host "Choose an option:"
        Write-Host "1. Fix renamed files with g(filename).exe pattern and has g(filename).ico in the same folder"
        Write-Host "2. List .exe files and save to output_file.txt"
        Write-Host "3. Rename files from output_file.txt"
        Write-Host "4. Quit"

        $choice = Read-Host "Enter your choice (1/2/3/4)"

        switch ($choice) {
            '1' {
                $directoryToScan = Read-Host "Enter the directory to scan (e.g., C:\) (default: C:\)"
                if (-not $directoryToScan) {
                    $directoryToScan = "C:\"
                }
                Rename-ExeFiles -directory $directoryToScan
                Write-Host "Scan completed."
            }
            '2' {
                $directoryToScan = Read-Host "Enter the directory to scan (e.g., C:\) (default: C:\)"
                if (-not $directoryToScan) {
                    $directoryToScan = "C:\"
                }
                $outputFile = "output_file.txt"
                List-ExeFiles -directory $directoryToScan -outputFile $outputFile
                Write-Host "BEFORE PUTTING THE LIST BACK TO OPTION NUMBER 3, PLEASE MAKE SURE FILES LISTED ON output_file.txt ARE ACTUALLY RENAMED BY TROJAN AND NOT LEGIT FILES STARTING WITH g!"
                Write-Host "YOU HAVE TO CHECK THIS MANUALLY BY LOOKING UP THE FILE NAME ON GOOGLE FOLLOWED BY ITS PARENT DIRECTORY / OPENING ITS PROPERTIES AND GO TO DETAILS TAB AND CHECK ORIGINAL FILENAME!!"
            }
            '3' {
                $fileListPath = Read-Host "Enter file name in current directory (e.g., output_file.txt) (default: output_file.txt)"
                if (-not $fileListPath) {
                    $fileListPath = "output_file.txt"
                }
                Rename-FilesFromList -fileListPath $fileListPath
            }
            '4' {
                Write-Host "Quitting the script."
                exit
            }
            default {
                Write-Host "Invalid choice. Please try again."
            }
        }
    }
}

Main