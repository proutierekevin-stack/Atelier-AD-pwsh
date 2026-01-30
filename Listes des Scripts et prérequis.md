
# 🚀 TechSecure AD Management Tool
## 🛠️ Prérequis
Avant d'utiliser ces scripts, assurez-vous que les conditions suivantes sont remplies :
* **Système d'exploitation** : Windows Server 2016 ou version ultérieure.
* **Rôle AD DS** : Le rôle Active Directory Domain Services doit être installé et configuré.
* **Module PowerShell** : Le module `ActiveDirectory` doit être installé.
* **Permissions** : Le script doit être exécuté avec des privilèges d' **Administrateur du domaine**.
* **Emplacement** : Tous les scripts doivent être situés dans le même répertoire (ex: `C:\Scripts`).

## 📂 Liste des Scripts
* `AD-Manager.ps1` : **Le script principal**. Lance la console d'administration interactive.
* `New-Employee.ps1` : Automatise l'onboarding (création de compte, login auto, email et placement en OU).
* `Import-ADUsersFromCSV.ps1` : Permet l'importation massive d'utilisateurs à partir d'un fichier CSV.
* `Reset-EmployeePassword.ps1` : Réinitialise le mot de passe de manière sécurisée et déverrouille le compte.
* `Remove-Employee.ps1` : Gère l'offboarding en désactivant le compte et en le déplaçant en quarantaine.
* `Get-InactiveUsers.ps1` : Audite les comptes dont le mot de passe n'a pas été changé depuis plus de 90 jours.
* `Get-ADGroupsReport.ps1` : Génère un rapport HTML détaillé sur les groupes de sécurité et leurs membres.
* `Get-ADHealthReport.ps1` : Produit un tableau de bord complet de l'état de santé de l'Active Directory (HTML).

## 🚀 Comment les utiliser ?

### 1. Lancement de la console
Ouvrez une console PowerShell en tant qu'administrateur, placez-vous dans le dossier et lancez le gestionnaire :
```powershell
cd C:\Scripts
.\AD-Manager.ps1
