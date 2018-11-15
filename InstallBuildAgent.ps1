Param
(
    [Parameter(Mandatory=$True)]
    [string]$AzureDevOpsUrl,
    [Parameter(Mandatory=$True)]
    [string]$AzureDevOpsPAT,
    [Parameter(Mandatory=$True)]
    [string]$AgentPool,
    [Parameter(Mandatory=$True)]
    [string]$AgentName,
)

New-Item -ErrorAction Ignore -ItemType directory -Path c:\agent
cd c:\agent
(New-Object System.Net.WebClient).DownloadFile("https://vstsagentpackage.azureedge.net/agent/2.141.1/vsts-agent-win-x64-2.141.1.zip", "$PWD\agent.zip")
Add-Type -AssemblyName System.IO.Compression.FileSystem ; [System.IO.Compression.ZipFile]::ExtractToDirectory("$PWD\agent.zip", "$PWD")
.\config.cmd --unattended --url $AzureDevOpsUrl --auth pat --token $AzureDevOpsPAT --pool $AgentPool --agent $AgentName --acceptTeeEula --runAsService
