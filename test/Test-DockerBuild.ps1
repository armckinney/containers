[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string]
    $ImageName
)

$TargetDirectory=(Split-Path -Parent $PSScriptRoot)

$DockerfilePath = (Get-ChildItem -Path $TargetDirectory -Recurse -Filter "*Dockerfile.$ImageName").FullName

Write-Output "`nTest Building $DockerfilePath"

Get-Content $DockerfilePath | docker build -
