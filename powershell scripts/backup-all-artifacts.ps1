# Backup-FabricArtifacts.ps1

param(
  [Parameter(Mandatory)] [string] $TenantId,
  [Parameter(Mandatory)] [string] $ClientId,
  [Parameter(Mandatory)] [string] $ClientSecret,
  [Parameter(Mandatory)] [string] $SubscriptionId,
  [Parameter(Mandatory)] [string] $ResourceGroup,
  [Parameter(Mandatory)] [string] $WorkspaceName,
  [Parameter(Mandatory)] [string] $Region,
  [string] $OutputFolder = ".\fabric-backup"
)

# 1. Auth & set up
Connect-AzAccount -ServicePrincipal -Tenant $TenantId `
  -Credential (New-Object PSCredential($ClientId, (ConvertTo-SecureString $ClientSecret -AsPlainText -Force))) | Out-Null
Select-AzSubscription -SubscriptionId $SubscriptionId
$apiVer = "2024-05-01-preview"
$wsId = (Get-AzResource -ResourceType "Microsoft.Fabric/workspaces" `
  -ResourceGroupName $ResourceGroup -Name $WorkspaceName).ResourceId
$baseUri = "https://management.azure.com${wsId}"

$types = @("lakehouses","warehouses","pipelines","dataflows","notebooks","reports","taskflows")

# 2. Ensure output folder exists
New-Item -ItemType Directory -Path $OutputFolder -Force | Out-Null

foreach ($t in $types) {
  $folder = Join-Path $OutputFolder $t
  New-Item -ItemType Directory -Path $folder -Force | Out-Null

  Write-Host "Exporting all [$t]..."
  $list = Invoke-AzRestMethod -Method GET `
    -Path "$baseUri/${t}?api-version=$apiVer" `
    | Select-Object -Expand Value

  foreach ($item in $list) {
    $id   = $item.id.Split("/")[-1]
    $dest = Join-Path $folder ("{0}.json" -f $id)
    $json = Invoke-AzRestMethod -Method GET `
      -Path "$baseUri/${t}/$id?api-version=$apiVer"
    $json | ConvertTo-Json -Depth 20 | Set-Content $dest
  }

  Write-Host "`tSaved [$($list.Count)] $t artifacts"
}
