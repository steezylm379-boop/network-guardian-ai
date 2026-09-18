$ErrorActionPreference = 'Stop'
$root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
Set-Location $root

function Invoke-Checked {
  param(
    [Parameter(Mandatory=$true)][string]$Executable,
    [Parameter(ValueFromRemainingArguments=$true)][string[]]$Arguments
  )
  & $Executable @Arguments
  if ($LASTEXITCODE -ne 0) {
    throw "$Executable $($Arguments -join ' ') failed (exit $LASTEXITCODE). Verification stopped."
  }
}

function Resolve-JavaHome {
  if ($env:JAVA_HOME -and (Test-Path (Join-Path $env:JAVA_HOME 'bin\java.exe'))) {
    return $env:JAVA_HOME
  }
  $candidatePaths = @(
    'C:\Program Files\Android\Android Studio\jbr',
    'C:\Program Files\Android\Android Studio\jre',
    (Join-Path $env:LOCALAPPDATA 'Programs\Android Studio\jbr')
  )
  $candidates = @($candidatePaths | Where-Object { $_ -and (Test-Path (Join-Path $_ 'bin\java.exe')) })
  if ($candidates.Length -gt 0) { return [string]$candidates[0] }
  return $null
}

function Resolve-AndroidSdk {
  foreach ($candidate in @($env:ANDROID_SDK_ROOT, $env:ANDROID_HOME, (Join-Path $env:LOCALAPPDATA 'Android\Sdk'))) {
    if ($candidate -and (Test-Path $candidate)) { return $candidate }
  }
  $props = Join-Path $root 'android\local.properties'
  if (Test-Path $props) {
    $line = Get-Content $props | Where-Object { $_ -match '^sdk\.dir=' } | Select-Object -First 1
    if ($line) {
      $value = ($line -replace '^sdk\.dir=', '').Replace('\\:', ':').Replace('\\\\', '\')
      if (Test-Path $value) { return $value }
    }
  }
  return $null
}

Write-Host '== Network Guardian AI Phase 3 v1.3.0+8 verification ==' -ForegroundColor Cyan

$javaHome = Resolve-JavaHome
if (-not $javaHome) {
  throw 'Java was not found. Open Android Studio once or set JAVA_HOME to Android Studio\jbr, then rerun.'
}
$env:JAVA_HOME = $javaHome
if (($env:Path -split ';') -notcontains (Join-Path $javaHome 'bin')) {
  $env:Path = "$(Join-Path $javaHome 'bin');$env:Path"
}
Write-Host "JAVA_HOME: $javaHome" -ForegroundColor DarkGray
Invoke-Checked (Join-Path $javaHome 'bin\java.exe') '-version'

$androidSdk = Resolve-AndroidSdk
if (-not $androidSdk) {
  throw 'Android SDK was not found. Run flutter doctor and configure the SDK before verification.'
}
$env:ANDROID_SDK_ROOT = $androidSdk
$env:ANDROID_HOME = $androidSdk
Write-Host "Android SDK: $androidSdk" -ForegroundColor DarkGray

$requiredNdk = '28.2.13676358'
$ndkPath = Join-Path $androidSdk "ndk\$requiredNdk"
if (-not (Test-Path $ndkPath)) {
  Write-Host ''
  Write-Host "Required NDK $requiredNdk is not installed." -ForegroundColor Yellow
  Write-Host 'Install it once in Android Studio:' -ForegroundColor Yellow
  Write-Host '  Tools > SDK Manager > SDK Tools > Show Package Details' -ForegroundColor Yellow
  Write-Host "  NDK (Side by side) > $requiredNdk > Apply" -ForegroundColor Yellow
  Write-Host ''
  throw "Missing Android NDK $requiredNdk at $ndkPath. Verification stopped before the build."
}
Write-Host "Android NDK: $ndkPath" -ForegroundColor DarkGray

Invoke-Checked 'flutter' '--version'
Invoke-Checked 'flutter' 'pub' 'get'
Invoke-Checked 'dart' 'run' 'build_runner' 'build'
Invoke-Checked 'flutter' 'analyze'
Invoke-Checked 'flutter' 'test' '--concurrency=1'

Push-Location android
try {
  Invoke-Checked '.\gradlew.bat' ':app:testDebugUnitTest' '--max-workers=1'
} finally {
  Pop-Location
}

Invoke-Checked 'flutter' 'build' 'apk' '--debug'
$apk = Join-Path $root 'build\app\outputs\flutter-apk\app-debug.apk'
if (!(Test-Path $apk)) { throw "APK was not produced at $apk" }
$hash = (Get-FileHash -Algorithm SHA256 $apk).Hash
$hash | Set-Content -Encoding ascii (Join-Path $root 'APK_SHA256_V1_3_0_8.txt')
Write-Host "APK: $apk" -ForegroundColor Green
Write-Host "SHA-256: $hash" -ForegroundColor Green
Write-Host 'Automated Phase 3 verification finished. Emulator and real-LAN acceptance remain separate.' -ForegroundColor Yellow
