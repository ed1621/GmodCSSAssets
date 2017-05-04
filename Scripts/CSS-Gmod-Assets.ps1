$wshell = New-Object -ComObject Wscript.Shell
$errorPath = [Environment]::GetFolderPath("Desktop") + "\errors.txt"
$DownloadPath = "$env:UserProfile\Downloads"
$GmodFilePath = "C:\Program Files (x86)\Steam\steamapps\common\GarrysMod\garrysmod"
$CSSTexturesURL = "http://files3.fragplays.com/CSS%20Game%20Content.zip"
$CSSTexturesOutput = "$DownloadPath\CSS_Game_Content.zip"
$CSSMapsURL = "http://files3.fragplays.com/CSS%20Maps.zip"
$CSSMapsOutput = "$DownloadPath\CSS_Maps.zip"

Add-Type -AssemblyName System.IO.Compression.FileSystem
function Unzip
{
    param([string]$zipfile, [string]$outpath)

    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}

function DownloadFile($url, $targetFile)
{
   $uri = New-Object "System.Uri" "$url"
   $request = [System.Net.HttpWebRequest]::Create($uri)
   $request.set_Timeout(15000) #15 second timeout
   $response = $request.GetResponse()
   $totalLength = [System.Math]::Floor($response.get_ContentLength()/1024)
   $responseStream = $response.GetResponseStream()
   $targetStream = New-Object -TypeName System.IO.FileStream -ArgumentList $targetFile, Create
   $buffer = new-object byte[] 10KB
   $count = $responseStream.Read($buffer,0,$buffer.length)
   $downloadedBytes = $count

   while ($count -gt 0)
   {
       $targetStream.Write($buffer, 0, $count)
       $count = $responseStream.Read($buffer,0,$buffer.length)
       $downloadedBytes = $downloadedBytes + $count
       Write-Progress -activity "Downloading file '$($url.split('/') | Select -Last 1)'" -status "Downloaded ($([System.Math]::Floor($downloadedBytes/1024))K of $($totalLength)K): " -PercentComplete ((([System.Math]::Floor($downloadedBytes/1024)) / $totalLength)  * 100)
   }

   Write-Progress -activity "Finished downloading file '$($url.split('/') | Select -Last 1)'"
   $targetStream.Flush()
   $targetStream.Close()
   $targetStream.Dispose()
   $responseStream.Dispose()
}


try
{
    $wshell.Popup("Downloading CSS Textures",2,"Message",0);
    DownloadFile $CSSTexturesURL $CSSTexturesOutput
    $wshell.Popup("Downloading CSS Maps",2,"Message",0);
    DownloadFile $CSSMapsURL $CSSMapsOutput 

    $wshell.Popup("Unzipping the files",2,"Message",0);
    Unzip $CSSMapsOutput $DownloadPath
    Unzip $CSSTexturesOutput $DownloadPath  

}
catch
{
    $ErrorMessage = $_.Exception.Message
    $FailedItem = "Downloading files"
    $ErrorMessage | Out-File -Encoding Ascii -Append $errorPath
    $wshell.Popup("Something failed. Check the error log at $($errorPath)",5,"Message",0);
    Break   
}
$wshell.Popup("Moving the files to the right folders",3,"Message",0);
Move-Item $DownloadPath\CSS_Game_Content $GmodFilePath\addons
Move-Item $DownloadPath\CSS_Maps\maps\graphs $GmodFilePath\maps
Move-Item $DownloadPath\CSS_Maps\maps\*.bsp $GmodFilePath\maps
Move-Item $DownloadPath\CSS_Maps\maps\*.txt $GmodFilePath\maps

Remove-Item $CSSTexturesOutput
Remove-Item $CSSMapsOutput
Remove-Item $DownloadPath\CSS_Maps -Force -Recurse


if($Error)
{
    $Error | Out-File -Encoding Ascii -Append $errorPath
    $wshell.Popup("Something failed. Check the error log at $($errorPath)",5,"Message",0);
    Break   
}
else 
{
    $wshell.Popup("All done! Have a good day!",5,"Message",0);      
}


