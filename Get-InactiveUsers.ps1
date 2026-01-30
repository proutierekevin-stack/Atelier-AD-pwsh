# ---------------------------------------------------------------------------
# Script : Get-InactiveUsers.ps1
# Description : Liste les utilisateurs dont le MDP n'a pas changé depuis 90j
# ---------------------------------------------------------------------------

# 1. Définition du seuil (90 jours en arrière)
$SeuilJours = 90
$DateLimite = (Get-Date).AddDays(-$SeuilJours)

Write-Host "Recherche des utilisateurs inactifs (MDP > 90 jours)..." -ForegroundColor Cyan

# 2. Récupération des utilisateurs avec la propriété PasswordLastSet
$UtilisateursInactifs = Get-ADUser -Filter 'PasswordLastSet -le $DateLimite' -Properties PasswordLastSet | ForEach-Object {
    
    # Calcul du nombre de jours depuis la dernière modification
    $JoursDepuisModif = (New-TimeSpan -Start $_.PasswordLastSet -End (Get-Date)).Days
    
    # Création d'un objet personnalisé pour le rapport
    [PSCustomObject]@{
        Login                       = $_.SamAccountName
        Nom                         = $_.Name
        DerniereModificationMDP     = $_.PasswordLastSet
        JoursDepuisModification      = $JoursDepuisModif
    }
}

# 3. Tri par nombre de jours décroissant
$RapportTrie = $UtilisateursInactifs | Sort-Object JoursDepuisModification -Descending

# 4. Affichage dans la console (pour vérification)
$RapportTrie | Format-Table -AutoSize

# 5. Exportation en CSV
$CheminCSV = ".\Rapport_Utilisateurs_Inactifs.csv"
$RapportTrie | Export-Csv -Path $CheminCSV -NoTypeInformation -Encoding UTF8 -Delimiter ";"

Write-Host "`nRapport généré avec succès : $CheminCSV" -ForegroundColor Green