# -------------------------------------------------------------
# Script : Configuration de l'environnement TechSecure
# Auteur : Kevin Proutiere
# -------------------------------------------------------------

# 1. Création de la structure des dossiers (OU)
Write-Host "Création des Unités Organisationnelles..." -ForegroundColor Cyan
New-ADOrganizationalUnit -Name "TechSecure" -Path "DC=formation,DC=lan"
New-ADOrganizationalUnit -Name "Users" -Path "OU=TechSecure,DC=formation,DC=lan"
New-ADOrganizationalUnit -Name "Groups" -Path "OU=TechSecure,DC=formation,DC=lan"

# 2. Paramètres communs pour les utilisateurs
$password = ConvertTo-SecureString "P@ssw0rd123!" -AsPlainText -Force
$userPath = "OU=Users,OU=TechSecure,DC=formation,DC=lan"

# 3. Création des utilisateurs
Write-Host "Création des utilisateurs..." -ForegroundColor Cyan

# Alice
New-ADUser -Name "Alice Martin" -GivenName "Alice" -Surname "Martin" -SamAccountName "amartin" `
           -UserPrincipalName "amartin@techsecure.fr" -EmailAddress "alice.martin@techsecure.fr" `
           -Title "Développeuse" -Path $userPath -AccountPassword $password -ChangePasswordAtLogon $true -Enabled $true

# Bob
New-ADUser -Name "Bob Dubois" -GivenName "Bob" -Surname "Dubois" -SamAccountName "bdubois" `
           -UserPrincipalName "bdubois@techsecure.fr" -EmailAddress "bob.dubois@techsecure.fr" `
           -Title "Administrateur Système" -Path $userPath -AccountPassword $password -ChangePasswordAtLogon $true -Enabled $true

# Claire
New-ADUser -Name "Claire Bernard" -GivenName "Claire" -Surname "Bernard" -SamAccountName "cbernard" `
           -UserPrincipalName "cbernard@techsecure.fr" -EmailAddress "claire.bernard@techsecure.fr" `
           -Title "Chef de Projet" -Path $userPath -AccountPassword $password -ChangePasswordAtLogon $true -Enabled $true

Write-Host "Déploiement terminé avec succès !" -ForegroundColor Green