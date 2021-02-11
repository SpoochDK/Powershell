#Get Graph API Intune Module
Install-Module -Name Microsoft.Graph.Intune
Import-Module Microsoft.Graph.Intune -Global

#Set path where script will be downloaded
$Path = "C:\Temp"

#The Connection to Azure Graph
Connect-MSGraph


#Get Graph scripts
$ScriptsData = Invoke-MSGraphRequest -Url "https://graph.microsoft.com/beta/deviceManagement/deviceManagementScripts" -HttpMethod GET
 
$ScriptsInfos = $ScriptsData.value | select id,fileName,displayname
$NBScripts = ($ScriptsInfos).count
 
if ($NBScripts -gt 0){
    Write-Host "Found $NBScripts scripts :" -ForegroundColor Yellow
    $ScriptsInfos | FT DisplayName,filename
    Write-Host "Downloading Scripts..." -ForegroundColor Yellow
    foreach($ScriptInfo in $ScriptsInfos){
        #Get the script
        $script = Invoke-MSGraphRequest -Url "https://graph.microsoft.com/beta/deviceManagement/deviceManagementScripts/$($scriptInfo.id)" -HttpMethod GET
        #Save the script
        [System.Text.Encoding]::ASCII.GetString([System.Convert]::FromBase64String($($script.scriptContent))) | Out-File -FilePath $(Join-Path $Path $($script.fileName))  -Encoding ASCII 
    }
    Write-Host "All scripts downloaded!" -ForegroundColor Yellow    
}
