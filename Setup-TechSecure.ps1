# 1. --- STRUCTURE DES OU (HIÉRARCHIE COMPLÈTE) ---
# On crée d'abord la racine, puis les parents, puis les enfants
New-ADOrganizationalUnit -Name "TechSecure" -Path "DC=formation,DC=lan"

# Sous TechSecure
New-ADOrganizationalUnit -Name "Utilisateurs" -Path "OU=TechSecure,DC=formation,DC=lan"
New-ADOrganizationalUnit -Name "Groupes" -Path "OU=TechSecure,DC=formation,DC=lan"
New-ADOrganizationalUnit -Name "Ordinateurs" -Path "OU=TechSecure,DC=formation,DC=lan"

# Sous Utilisateurs
New-ADOrganizationalUnit -Name "Informatique" -Path "OU=Utilisateurs,OU=TechSecure,DC=formation,DC=lan"
New-ADOrganizationalUnit -Name "RH" -Path "OU=Utilisateurs,OU=TechSecure,DC=formation,DC=lan"
New-ADOrganizationalUnit -Name "Commercial" -Path "OU=Utilisateurs,OU=TechSecure,DC=formation,DC=lan"

# Sous Informatique
New-ADOrganizationalUnit -Name "Developpement" -Path "OU=Informatique,OU=Utilisateurs,OU=TechSecure,DC=formation,DC=lan"
New-ADOrganizationalUnit -Name "Infrastructure" -Path "OU=Informatique,OU=Utilisateurs,OU=TechSecure,DC=formation,DC=lan"

# 2. --- VARIABLES DE CHEMINS (Pour simplifier) ---
$pathDev = "OU=Developpement,OU=Informatique,OU=Utilisateurs,OU=TechSecure,DC=formation,DC=lan"
$pathInfra = "OU=Infrastructure,OU=Informatique,OU=Utilisateurs,OU=TechSecure,DC=formation,DC=lan"
$pathGroups = "OU=Groupes,OU=TechSecure,DC=formation,DC=lan"
$password = ConvertTo-SecureString "P@ssw0rd123!" -AsPlainText -Force

# 3. --- CRÉATION DES UTILISATEURS DANS LES BONNES OU ---
# Alice va en Développement
New-ADUser -Name "Alice Martin" -SamAccountName "amartin" -Title "Développeuse" -Path $pathDev -AccountPassword $password -Enabled $true
# Bob va en Infrastructure
New-ADUser -Name "Bob Dubois" -SamAccountName "bdubois" -Title "Administrateur Système" -Path $pathInfra -AccountPassword $password -Enabled $true
# Bonus : Jean et Marie en Développement
New-ADUser -Name "Jean Bon" -SamAccountName "jbon" -Path $pathDev -AccountPassword $password -Enabled $true
New-ADUser -Name "Marie Dupont" -SamAccountName "mdupont" -Path $pathDev -AccountPassword $password -Enabled $true

# 4. --- CRÉATION DES GROUPES (Dans l'OU Groupes) ---
New-ADGroup -Name "GRP_Developpeurs" -GroupCategory Security -GroupScope Global -Path $pathGroups
New-ADGroup -Name "GRP_Admins_Systeme" -GroupCategory Security -GroupScope Global -Path $pathGroups
New-ADGroup -Name "GRP_IT" -GroupCategory Security -GroupScope Global -Path $pathGroups

# 5. --- ADHÉSIONS ---
Add-ADGroupMember -Identity "GRP_Developpeurs" -Members "amartin", "jbon", "mdupont"
Add-ADGroupMember -Identity "GRP_Admins_Systeme" -Members "bdubois"
Add-ADGroupMember -Identity "GRP_IT" -Members "GRP_Developpeurs", "GRP_Admins_Systeme"