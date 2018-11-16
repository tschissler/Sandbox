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

    [int]$AgentCount = 1
)

$agentRootPath = "c:\agent"

# Create folder for agents
New-Item -ErrorAction Ignore -ItemType directory -Path $agentRootPath
cd $agentRootPath

# Download agent
(New-Object System.Net.WebClient).DownloadFile("https://vstsagentpackage.azureedge.net/agent/2.141.1/vsts-agent-win-x64-2.141.1.zip", "$PWD\agent.zip")


# Install Agents
for($i=1; $i -le $AgentCount; $i++)
{
    Write-Host ("Installing and configuring Build Agent " + $AgentName + $i.ToString())
    $agentpath = Join-Path -Path $agentRootPath -ChildPath ("Agent_" + $i.ToString())
    # Create new folder for agent
    New-Item -ErrorAction Ignore -ItemType directory -Path $agentpath
    cd $agentpath

    Add-Type -AssemblyName System.IO.Compression.FileSystem ; [System.IO.Compression.ZipFile]::ExtractToDirectory("$PWD\..\agent.zip", "$PWD")
    .\config.cmd --unattended --url $AzureDevOpsUrl --auth pat --token $AzureDevOpsPAT --pool $AgentPool --agent ($AgentName + $i.ToString()) --acceptTeeEula --runAsService --replace
}
