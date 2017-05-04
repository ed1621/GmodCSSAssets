$wshell = New-Object -ComObject Wscript.Shell
$DesktopPath = [Environment]::GetFolderPath("Desktop")
$DownloadPath = "$env:UserProfile\Downloads"
$GmodFilePath = "C:\Program Files (x86)\Steam\steamapps\common\GarrysMod\garrysmod"
$CSSTexturesURL = "http://files3.fragplays.com/CSS%20Game%20Content.zip"
$CSSTexturesOutput = "$DownloadPath\CSS Game Content.zip"
$CSSMapsURL = "http://files3.fragplays.com/CSS%20Maps.zip"
$CSSMapsOutput = "$DownloadPath\CSS Maps.zip"

Add-Type -AssemblyName System.IO.Compression.FileSystem
function Unzip
{
    param([string]$zipfile, [string]$outpath)

    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}

$wshell.Popup("Downloading CSS Textures",2,"Message",0);
(New-Object System.Net.WebClient).DownloadFile($CSSTexturesURL, $CSSTexturesOutput)
$wshell.Popup("Downloading CSS Maps",2,"Message",0);
(New-Object System.Net.WebClient).DownloadFile($CSSMapsURL, $CSSMapsOutput)

$wshell.Popup("Unzipping the files",2,"Message",0);
Unzip $CSSMapsOutput $DownloadPath
Unzip $CSSTexturesOutput $DownloadPath

$wshell.Popup("Moving the files to the right folders",3,"Message",0);
Move-Item $DownloadPath\CSS_Game_Content $GmodFilePath\addons
Move-Item $DownloadPath\CSS_Maps\maps\graphs $GmodFilePath\maps
Move-Item $DownloadPath\CSS_Maps\maps\*.bsp $GmodFilePath\maps
Move-Item $DownloadPath\CSS_Maps\maps\*.txt $GmodFilePath\maps

Remove-Item $CSSTexturesOutput
Remove-Item $CSSMapsOutput
Remove-Item $DownloadPath\CSS_Maps -Force -Recurse

$wshell.Popup("All done! Have a good day!",5,"Message",0);
