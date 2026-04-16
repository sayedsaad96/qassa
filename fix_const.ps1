# Fix invalid_constant errors by removing 'const' from specific lines
$fixes = @(
    @{ File = "lib\features\auth\presentation\pages\edit_profile_page.dart"; Lines = @(186, 536, 599) },
    @{ File = "lib\features\auth\presentation\pages\help_support_page.dart"; Lines = @(26) },
    @{ File = "lib\features\auth\presentation\pages\notifications_settings_page.dart"; Lines = @(26) },
    @{ File = "lib\features\auth\presentation\pages\privacy_security_page.dart"; Lines = @(26) },
    @{ File = "lib\features\auth\presentation\pages\profile_page.dart"; Lines = @(95, 231, 274) },
    @{ File = "lib\features\auth\presentation\pages\splash_page.dart"; Lines = @(85) },
    @{ File = "lib\features\brand\presentation\pages\brand_home_page.dart"; Lines = @(73, 224) },
    @{ File = "lib\features\brand\presentation\pages\factories_list_page.dart"; Lines = @(143, 243, 346, 412, 454, 646, 1069, 1181) },
    @{ File = "lib\features\brand\presentation\pages\offers_page.dart"; Lines = @(634) },
    @{ File = "lib\features\factory\presentation\pages\factory_dashboard_page.dart"; Lines = @(78) },
    @{ File = "lib\features\factory\presentation\pages\factory_requests_page.dart"; Lines = @(122) },
    @{ File = "lib\features\factory\presentation\pages\request_detail_page.dart"; Lines = @(122, 263, 277) }
)

foreach ($fix in $fixes) {
    $filePath = Join-Path "d:\Sayed\Flutter\qassa" $fix.File
    $lines = Get-Content $filePath
    $changed = $false
    foreach ($lineNum in $fix.Lines) {
        $idx = $lineNum - 1
        if ($idx -lt $lines.Length) {
            $original = $lines[$idx]
            # Remove the first occurrence of 'const ' on this line
            if ($original -match 'const ') {
                $lines[$idx] = $original -replace 'const ', '', 1
                # PowerShell -replace replaces all, so use a different approach
                $pos = $original.IndexOf('const ')
                if ($pos -ge 0) {
                    $lines[$idx] = $original.Substring(0, $pos) + $original.Substring($pos + 6)
                    Write-Host "Fixed $($fix.File):$lineNum"
                    $changed = $true
                }
            }
        }
    }
    if ($changed) {
        $lines | Set-Content $filePath -Encoding UTF8
    }
}
Write-Host "Done!"
