param(
    [Parameter(Mandatory=$true)][string]$Prenom,
    [Parameter(Mandatory=$true)][string]$Nom,
    [Parameter(Mandatory=$true)][string]$Titre,
    [Parameter(Mandatory=$true)][string]$Departement
)

# 1. Génération automatique des identifiants
$Login = ($Prenom.Substring(0,1) + $Nom).ToLower()
$Email = "$Login@techsecure.fr"

# Génération d'un mot de passe aléatoire (plus pro que "P@ssw0rd123!")
$Password = -join ((65..90) + (97..122) + (48..57) | Get-Random -Count 10 | % {[char]$_}) + "!"
$SecurePassword = ConvertTo-SecureString $Password -AsPlainText -Force

# 2. Mapping automatique des OU selon le département
$BaseOU = "OU=Utilisateurs,OU=TechSecure,DC=formation,DC=lan"
$TargetOU = switch ($Departement) {
    "Informatique" { "OU=Developpement,OU=Informatique,$BaseOU" }
    "RH"           { "OU=RH,$BaseOU" }
    "Commercial"   { "OU=Commercial,$BaseOU" }
    Default        { $BaseOU }
}

# 3. Création de l'utilisateur
try {
    Write-Host "Création de l'utilisateur $Login..." -ForegroundColor Cyan
    New-ADUser -Name "$Prenom $Nom" `
               -SamAccountName $Login `
               -UserPrincipalName "$Login@formation.lan" `
               -EmailAddress $Email `
               -Title $Titre `
               -Department $Departement `
               -Path $TargetOU `
               -AccountPassword $SecurePassword `
               -Enabled $true `
               -ChangePasswordAtLogon $true
    
    # 4. Ajout au groupe IT par défaut
    Add-ADGroupMember -Identity "GRP_IT" -Members $Login
    
    Write-Host "SUCCÈS : Utilisateur créé dans $TargetOU" -ForegroundColor Green
    Write-Host "MOT DE PASSE TEMPORAIRE : $Password" -ForegroundColor Yellow
}
catch {
    Write-Error "ERREUR : Impossible de créer l'utilisateur. $($_.Exception.Message)"
}