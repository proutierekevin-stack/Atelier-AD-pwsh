# ---------------------------------------------------------------------------
# Script : AD-Manager.ps1 - Console d'administration TechSecure
# ---------------------------------------------------------------------------

# --- FONCTION DE LOGGING ---
function Write-Log {
    param($Message, $Color = "White")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "[$timestamp] $Message" | Out-File -FilePath ".\ad_manager.log" -Append
    Write-Host $Message -ForegroundColor $Color
}

# --- FONCTION MENU PRINCIPAL ---
function Show-Menu {
    Clear-Host
    Write-Host "==============================================" -ForegroundColor Cyan
    Write-Host "        GESTIONNAIRE ACTIVE DIRECTORY         " -ForegroundColor Cyan
    Write-Host "==============================================" -ForegroundColor Cyan
    Write-Host " UTILISATEURS :"
    Write-Host "  1. Creer un utilisateur"
    Write-Host "  2. Rechercher un utilisateur"
    Write-Host "  3. Modifier un utilisateur (Titre/Dept)"
    Write-Host "  4. Desactiver un utilisateur"
    Write-Host "  5. Supprimer un utilisateur"
    Write-Host " GROUPES :"
    Write-Host "  6. Creer un groupe"
    Write-Host "  7. Ajouter un membre a un groupe"
    Write-Host "  8. Retirer un membre d'un groupe"
    Write-Host "  9. Lister les membres d'un groupe"
    Write-Host " IMPORT/EXPORT :"
    Write-Host "  10. Importer des utilisateurs depuis CSV"
    Write-Host "  11. Exporter tous les utilisateurs en CSV"
    Write-Host " RAPPORTS :"
    Write-Host "  12. Rapport des utilisateurs inactifs"
    Write-Host "  13. Rapport des groupes"
    Write-Host "  14. Audit complet"
    Write-Host " AUTRES :"
    Write-Host "  15. Reinitaliser un mot de passe"
    Write-Host "  16. Quitter"
    Write-Host "==============================================" -ForegroundColor Cyan
}

# --- BOUCLE PRINCIPALE ---
do {
    Show-Menu
    $choice = Read-Host "Choisissez une option (1-16)"

    switch ($choice) {
        "1" { 
            $p = Read-Host "Prenom" ; $n = Read-Host "Nom" ; $d = Read-Host "Departement"
            .\New-Employee.ps1 -Prenom $p -Nom $n -Titre "Nouvel Employe" -Departement $d
        }
        "2" {
            $name = Read-Host "Nom ou Login a rechercher"
            Get-ADUser -Filter "Name -like '*$name*' -or SamAccountName -like '*$name*'" | Select-Object Name, SamAccountName, Enabled | Format-Table
        }
        "3" {
            $log = Read-Host "Login de l'utilisateur"
            $titre = Read-Host "Nouveau Titre"
            Set-ADUser -Identity $log -Title $titre
            Write-Log "Utilisateur $log mis a jour." "Green"
        }
        "4" { 
            $log = Read-Host "Login de l'utilisateur"
            .\Remove-Employee.ps1 -Login $log
        }
        "5" { 
            $log = Read-Host "Login de l'utilisateur a SUPPRIMER"
            $confirm = Read-Host "Etes-vous SUR ? (O/N)"
            if ($confirm -eq "O") { 
                Remove-ADUser -Identity $log -Confirm:$false
                Write-Log "Utilisateur $log supprime." "Yellow"
            }
        }
        "6" {
            $gname = Read-Host "Nom du nouveau groupe"
            New-ADGroup -Name $gname -GroupCategory Security -GroupScope Global -Path "OU=Groupes,OU=TechSecure,DC=formation,DC=lan"
            Write-Log "Groupe $gname cree." "Green"
        }
        "7" {
            $user = Read-Host "Login utilisateur"
            $group = Read-Host "Nom du groupe"
            Add-ADGroupMember -Identity $group -Members $user
            Write-Log "$user ajoute a $group." "Green"
        }
        "9" {
            $group = Read-Host "Nom du groupe"
            Get-ADGroupMember -Identity $group | Select-Object Name, SamAccountName | Format-Table
        }
        "10" { .\Import-ADUsersFromCSV.ps1 }
        "11" { 
            Get-ADUser -Filter * -Properties * | Export-Csv "Export_Users.csv" -NoTypeInformation
            Write-Log "Export termine : Export_Users.csv" "Green"
        }
        "12" { .\Get-ADAccountsAudit.ps1 }
        "13" { .\Get-ADGroupsReport.ps1 }
        "14" { 
            .\Get-ADHealthReport.ps1
            Write-Log "Rapport d'audit genere avec succes !" "Green"
        }
        "15" { 
            $log = Read-Host "Login de l'utilisateur"
            .\Reset-EmployeePassword.ps1 -Login $log
        }
        "16" { Write-Log "Sortie du programme." "Yellow" ; break }
        
        Default { Write-Host "Option invalide." -ForegroundColor Red }
    }
    
    if ($choice -ne "16") {
        Read-Host "`nAppuyez sur Entree pour revenir au menu..."
    }

} while ($choice -ne "16")