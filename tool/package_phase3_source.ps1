$ErrorActionPreference = 'Stop'
$project = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$output = Join-Path $project '.artifacts\network-guardian-ai-phase3-v1.3.0+5-source.zip'
New-Item -ItemType Directory -Force (Split-Path $output) | Out-Null
$skipDirectories = @('.artifacts', '.dart_tool', '.idea', '.gradle', '.kotlin', '.cxx', 'build', '.git')
$skipFiles = @('local.properties', '.flutter-plugins-dependencies')
function Get-SourceFiles([string] $directory) {
  foreach ($entry in Get-ChildItem -LiteralPath $directory -Force) {
    if ($entry.PSIsContainer) {
      if ($entry.Name -notin $skipDirectories) { Get-SourceFiles $entry.FullName }
    } elseif ($entry.Name -notin $skipFiles -and $entry.Extension -notin @('.iml', '.log')) {
      $entry
    }
  }
}
Add-Type -AssemblyName System.IO.Compression
$stream = [IO.File]::Open($output, [IO.FileMode]::Create)
$zip = [IO.Compression.ZipArchive]::new($stream, [IO.Compression.ZipArchiveMode]::Create)
try {
  foreach ($entry in Get-SourceFiles $project) {
    $relative = $entry.FullName.Substring($project.Length + 1).Replace('\', '/')
    [IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip, $entry.FullName, "network_guardian_ai/$relative") | Out-Null
  }
} finally { $zip.Dispose(); $stream.Dispose() }
Write-Output $output
