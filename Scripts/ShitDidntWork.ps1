$wshell = New-Object -ComObject Wscript.Shell
$DownloadPath = "$env:UserProfile\Downloads"
$GmodFilePath = "C:\Program Files (x86)\Steam\steamapps\common\GarrysMod\garrysmod"
$CSSTexturesURL = "http://files3.fragplays.com/CSS%20Game%20Content.zip"
$CSSTexturesOutput = "$DownloadPath\CSS Game Content.zip"
$CSSMapsURL = "http://files3.fragplays.com/CSS%20Maps.zip"
$CSSMapsOutput = "$DownloadPath\CSS Maps.zip"

$wshell.Popup("Deleting files that were put into the Gmod folder",2,"Message",0);
Remove-Item $GmodFilePath\maps\graphs -Force -Recurse
Remove-Item $GmodFilePath\maps\cs_*.bsp
Remove-Item $GmodFilePath\maps\cs_*.txt
Remove-Item $GmodFilePath\maps\de_*.bsp
Remove-Item $GmodFilePath\maps\de_*.txt
Remove-Item $GmodFilePath\maps\test_hardware.bsp
Remove-Item $GmodFilePath\maps\test_speakers.bsp
Remove-Item $GmodFilePath\addons\CSS_Game_Content -Force -Recurse
$wshell.Popup("All Done!",3,"Message",0);


