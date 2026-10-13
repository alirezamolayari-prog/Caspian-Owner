<#
.SYNOPSIS
  Raises the app version in pubspec.yaml and adds a CHANGELOG section.

.DESCRIPTION
  version: X.Y.Z+BUILD
  -Part patch  0.1.0+1 -> 0.1.1+2
  -Part minor  0.1.0+1 -> 0.2.0+2
  -Part major  0.1.0+1 -> 1.0.0+2
  BUILD always goes up by one: Android refuses an update with a lower or
  equal build number.

.EXAMPLE
  powershell -File tool/bump_version.ps1 -Part patch
#>
param(
  [Parameter(Mandatory = $true)]
  [ValidateSet('patch', 'minor', 'major')]
  [string]$Part
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$utf8 = New-Object System.Text.UTF8Encoding($false)

$pubspecPath = Join-Path $root 'pubspec.yaml'
$pubspec = [IO.File]::ReadAllText($pubspecPath, $utf8)
$pattern = '(?m)^version:\s*(\d+)\.(\d+)\.(\d+)\+(\d+)\s*$'
$m = [regex]::Match($pubspec, $pattern)
if (-not $m.Success) { throw 'pubspec.yaml has no "version: X.Y.Z+BUILD" line.' }

$major = [int]$m.Groups[1].Value
$minor = [int]$m.Groups[2].Value
$patch = [int]$m.Groups[3].Value
$build = [int]$m.Groups[4].Value + 1
switch ($Part) {
  'major' { $major++; $minor = 0; $patch = 0 }
  'minor' { $minor++; $patch = 0 }
  'patch' { $patch++ }
}
$version = "$major.$minor.$patch"

$pubspec = [regex]::Replace($pubspec, $pattern, "version: $version+$build")
[IO.File]::WriteAllText($pubspecPath, $pubspec, $utf8)

$changelogPath = Join-Path $root 'docs/CHANGELOG.md'
$changelog = [IO.File]::ReadAllText($changelogPath, $utf8)
$date = Get-Date -Format 'yyyy-MM-dd'
$section = "## $version ($date)`n- (تغییرات این نسخه را برای مالکان، ساده و کوتاه بنویسید)`n`n"
# New sections go above the first existing "## " heading.
$first = $changelog.IndexOf("`n## ")
if ($first -lt 0) { $changelog = $changelog.TrimEnd() + "`n`n" + $section }
else { $changelog = $changelog.Insert($first + 1, $section) }
[IO.File]::WriteAllText($changelogPath, $changelog, $utf8)

Write-Host "Version is now $version+$build."
Write-Host "Next: write the changes in docs/CHANGELOG.md, then:"
Write-Host "  git commit -am `"Release $version`""
Write-Host "  git tag v$version"
Write-Host "  git push; git push --tags"
