function Get-RandomString {
    param (
        [int]$Length,
        [string]$AllowedChars
    )
    $result = ""
    for ($i = 0; $i -lt $Length; $i++) {
        $index = Get-Random -Minimum 0 -Maximum $AllowedChars.Length
        $result += $AllowedChars[$index]
    }
    return $result
}

while ($true) {
    $templateInput = Read-Host "Enter code template (e.g., '%%%%%-%%%%%-%%%' or '5%-3%-3%')"
    
    $style = Read-Host "Enter style ('alphanumeric' or 'symbols', default to alphanumeric)"

    switch ($style.ToLower()) {
        "alphanumeric" {
            $allowedChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
        }
        "symbols" {
            $allowedChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()-_=+[]{};:,.<>/?"
        }
        default {
            Write-Host "Defaulting to alphanumeric"
            $allowedChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
        }
    }
    
    $templateProcessed = [regex]::Replace($templateInput, "(\d+)%", {
        param($match)
        $count = [int]$match.Groups[1].Value
        return Get-RandomString -Length $count -AllowedChars $allowedChars
    })
    
    $templateProcessed = [regex]::Replace($templateProcessed, "%", {
        param($match)
        return Get-RandomString -Length 1 -AllowedChars $allowedChars
    })
    
    Write-Host "Generated password: $templateProcessed"
    Write-Host "-------------------------------"

    $exitInput = Read-Host "Enter anything to continue or 'exit' to quit"
    if ($exitInput.ToLower() -eq 'exit') {
        break
    }
}
