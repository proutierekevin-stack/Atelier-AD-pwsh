# 1. Création de l'OU de destination
# Sans cette ligne, les commandes suivantes plantent car le dossier n'existe pas
New-ADOrganizationalUnit -Name "Groups" -Path "OU=TechSecure,DC=formation,DC=lan"

# 2. Définition du chemin dans une variable pour éviter les répétitions
$groupsPath = "OU=Groups,OU=TechSecure,DC=formation,DC=lan"

# 3. Création des 4 groupes de sécurité
New-ADGroup -Name "GRP_Developpeurs" -GroupCategory Security -GroupScope Global -Description "Équipe de développement" -Path $groupsPath
New-ADGroup -Name "GRP_Admins_Systeme" -GroupCategory Security -GroupScope Global -Description "Administrateurs système" -Path $groupsPath
New-ADGroup -Name "GRP_Chefs_Projet" -GroupCategory Security -GroupScope Global -Description "Chefs de projet" -Path $groupsPath
New-ADGroup -Name "GRP_IT" -GroupCategory Security -GroupScope Global -Description "Ensemble du département IT" -Path $groupsPath

# 4. Message de confirmation
Write-Host "Cette fois, c'est bon ! L'OU et les 4 groupes sont créés." -ForegroundColor Cyan