# Restore-FabricArtifacts.ps1

param(
  [Parameter(Mandatory)] [string] $TenantId,
  [Parameter(Mandatory)] [string] $ClientId,
  [Parameter(Mandatory)] [string] $ClientSecret,
  [Parameter(Mandatory)] [string] $SubscriptionId,
  [Parameter(Mandatory)] [string] $ResourceGroupEast,
  [Parameter(Mandatory)] [string] $WorkspaceNameEast,
  [string] $InputFolder = ".\fabric-backup"
)

Connect-AzAccount -ServicePrincipal -Tenant $TenantId `
  -Credential (New-Object PSCredential($ClientId, (ConvertTo-SecureString $ClientSecret -AsPlainText -Force))) | Out-Null
Select-AzSubscription -SubscriptionId $SubscriptionId

$wsIdEast = (Get-AzResource -ResourceType "Microsoft.Fabric/workspaces" `
  -ResourceGroupName $ResourceGroupEast -Name $WorkspaceNameEast).ResourceId
$baseUri = "https://management.azure.com${wsIdEast}"
$apiVer = "2024-05-01-preview"

foreach ($folder in Get-ChildItem -Directory $InputFolder) {
  $t = $folder.Name
  foreach ($file in Get-ChildItem $folder.FullName -Filter "*.json") {
    $json = Get-Content $file.FullName -Raw | ConvertFrom-Json
    $id   = $json.id
    $name = $json.name
    Write-Host "Restoring $t / $name"
    $uri = "$baseUri/$t/$name?api-version=$apiVer"
    Invoke-AzRestMethod -Method PUT -Path $uri -Body ($json | ConvertTo-Json -Depth 20)
  }
}
