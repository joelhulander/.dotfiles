# Set PowerShell to UTF-8
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding
# Prompt
Import-Module posh-git
$omp_config = Join-Path $PSScriptRoot ".\joelhu.omp.json" # Custom
# $omp_config = Join-Path $PSScriptRoot ".\bubblesextra.omp.json" # Bubbles 
# $omp_config = Join-Path $PSScriptRoot ".\iTerm2.omp.json" # iTerm2
oh-my-posh --init --shell pwsh --config $omp_config | Invoke-Expression

Import-Module -Name Terminal-Icons

# PSReadLine
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -BellStyle None
Set-PSReadLineKeyHandler -Chord 'Ctrl+d' -Function DeleteChar
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView

# Fzf
Import-Module PSFzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'

# Modify table
# Update-FormatData -Prepend C:\Users\joelhu\.config\powershell\FileFormat.format.ps1xml

# Alias
function cdSA { 
	set-location "~\source\repos\SA" 
}
function cdHome { 
	set-location "~" 
}
function cdBack { 
	$localPath = Get-Location | Split-Path -Parent
		set-location $localPath
}
function getAll {
	Get-ChildItem -force | Format-Wide
}

# Define a script block to be executed when the current directory changes
$directoryChangedScriptBlock = {
	$Host.UI.RawUI.WindowTitle = Get-Location | Split-Path -Leaf
}

# Create a FileSystemWatcher to monitor directory changes
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = (Get-Location).Path
$watcher.IncludeSubdirectories = $false
$watcher.EnableRaisingEvents = $true

# Register the event for directory changes
$eventSubscriber = Register-ObjectEvent -InputObject $watcher -EventName Changed -Action $directoryChangedScriptBlock


Set-Alias n z
Set-Alias g git
Set-Alias grep findstr
Set-Alias tig 'C:\Program Files\Git\usr\bin\tig.exe'
Set-Alias less 'C:\Program Files\Git\usr\bin\less.exe'
Set-Alias PATH $Env:Path
Set-Alias sa cdSA
Set-Alias ~ cdHome
Set-Alias .. cdBack
Set-Alias ls getAll
Set-Alias build buildSA
Set-Alias rebuild rebuildSA
Set-Alias buildSln rebuildSln
Set-Alias gd showGitDiff
Set-Alias copydir Copy-DirectoryWithConfirmation

function showGitDiff {
	git diff -w
}

# Utilities
function which ($command) {
	Get-Command -Name $command -ErrorAction SilentlyContinue | 
		Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

# Functions
function open {
	param ($file)

		Invoke-Item $file
}

function buildSA {
	process
	{
		Write-Host "Building $(Get-Location | Split-Path -Leaf)" -foregroundcolor green
			& "msbuild" -t:Build -m:12 -p:SolutionDir=C:\Users\joelhu\source\repos\SA\Application\SweetAutomation
	}
}


function rebuildSA {
	process
	{
		Write-Host "Rebuilding $(Get-Location | Split-Path -Leaf)" -foregroundcolor green
			& "msbuild" -t:Rebuild -m:12 -p:SolutionDir=C:\Users\joelhu\source\repos\SA\Application\SweetAutomation 
	}
}

function rebuildSln {
	process
	{
		Write-Host "Rebuilding SweetAutomation" -foregroundcolor green
			& "msbuild" C:\Users\joelhu\source\repos\SA\Application\SweetAutomation -t:Rebuild -m:12 
	}
}

function Copy-DirectoryWithConfirmation {
    param(
        [string]$sourcePath,
        [string]$destinationPath
    )

    # Check if source directory exists
    if (-not (Test-Path $sourcePath -PathType Container)) {
        Write-Host "Source directory '$sourcePath' not found."
        return
    }

    # Build the full destination path including the source directory name
    $fullDestinationPath = Join-Path -Path $destinationPath -ChildPath (Split-Path $sourcePath -Leaf)

    # Check if destination directory exists
    if (Test-Path $fullDestinationPath -PathType Container) {
        # Destination directory exists, prompt for confirmation
        $confirmation = Read-Host "Destination directory '$fullDestinationPath' already exists. Do you want to overwrite? (Y/N)"
        if ($confirmation -ne 'Y') {
            Write-Host "Copy operation canceled."
            return
        }
    }

    # Copy the directory and its contents
    Copy-Item -Path $sourcePath -Destination $destinationPath -Recurse -Force

    Write-Host "Directory '$sourcePath' successfully copied to '$fullDestinationPath'."
}
