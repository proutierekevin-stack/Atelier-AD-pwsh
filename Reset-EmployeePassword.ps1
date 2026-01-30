param([Parameter(Mandatory=$true)][string]$Login)

# 1. Génération mot de passe
$NewPass = -join ((65..90) + (97..122) + (48..57) | Get-Random -Count 10 | % {[char]$_}) + "!"
$SecurePass = ConvertTo-SecureString $NewPass -AsPlainText -Force

# 2. Action AD
try {
    Set-ADAccountPassword -Identity $Login -NewPassword $SecurePass -Reset
    Set-ADUser -Identity $Login -ChangePasswordAtLogon $true
    Unlock-ADAccount -Identity $Login
    
    Write-Host "MOT DE PASSE RÉINITIALISÉ" -ForegroundColor Green
    Write-Host "Nouveau mot de passe pour $Login : $NewPass" -ForegroundColor Cyan
}
catch {
    Write-Error "Erreur lors du reset : $($_.Exception.Message)"
}