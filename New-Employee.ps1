param(
    [Parameter(Mandatory=$true)][string]$Prenom,
    [Parameter(Mandatory=$true)][string]$Nom,
    [Parameter(Mandatory=$true)][string]$Titre,
    [Parameter(Mandatory=$true)][string]$Departement,
    [string]$Manager
)

# 1. Génération auto des identifiants
$Login = ($Prenom.Substring(0,1) + $Nom).ToLower()
$Email = "$Login@techsecure.fr"
$Password = -join ((65..90) + (97..122) + (48..57) | Get-Random -Count 12 | % {[char]$_}) + "!"
$SecurePassword = ConvertTo-SecureString $Password -AsPlainText -Force

# 2. Détermination de l'OU (Mapping)
$OUPath = switch ($Departement) {
    "Informatique" { "OU=Developpement,OU=Informatique,OU=Utilisateurs,OU=TechSecure,DC=formation,DC=lan" }
    "RH"           { "OU=RH,OU=Utilisateurs,OU=TechSecure,DC=formation,DC=lan" }
    "Commercial"   { "OU=Commercial,OU=Utilisateurs,OU=TechSecure,DC=formation,DC=lan" }
    Default        { "OU=Utilisateurs,OU=TechSecure,DC=formation,DC=lan" }
}

# 3. Création de l'utilisateur
Write-Host "--- Création de $Login ---" -ForegroundColor Cyan
New-ADUser -Name "$Prenom $Nom" -SamAccountName $Login -EmailAddress $Email -Title $Titre -Department $Departement -Path $OUPath -AccountPassword $SecurePassword -Enabled $true -ChangePasswordAtLogon $true

# 4. Ajout aux groupes (Logique métier)
Add-ADGroupMember -Identity "GRP_IT" -Members $Login
if ($Departement -eq "Informatique") { Add-ADGroupMember -Identity "GRP_Developpeurs" -Members $Login }

# 5. Simulation Email
Write-Host "EMAIL ENVOYÉ À $Email : Bienvenue ! Votre mot de passe est $Password" -ForegroundColor Green