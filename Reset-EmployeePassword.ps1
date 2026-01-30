param([Parameter(Mandatory=$true)][string]$Login)

# 1. Génération d'un nouveau MDP aléatoire
$NewPass = -join ((65..90) + (97..122) + (48..57) | Get-Random -Count 10 | % {[char]$_}) + "!"
$SecurePass = ConvertTo-SecureString $NewPass -AsPlainText -Force

try {
    # 2. Changement du MDP et forçage au prochain logon
    Set-ADAccountPassword -Identity $Login -NewPassword $SecurePass -Reset
    Set-ADUser -Identity $Login -ChangePasswordAtLogon $true
    
    # 3. Déverrouillage du compte (si l'utilisateur s'est trompé trop de fois)
    Unlock-ADAccount -Identity $Login
    
    Write-Host "Le mot de passe de $Login a été réinitialisé." -ForegroundColor Green
    Write-Host "Nouveau MDP : $NewPass" -ForegroundColor Cyan
}
catch {
    Write-Host "Erreur lors de la réinitialisation." -ForegroundColor Red
}