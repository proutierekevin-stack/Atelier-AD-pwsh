$Groups = Get-ADGroup -Filter 'GroupCategory -eq "Security"' -Properties Description, Members

$GroupData = foreach ($Group in $Groups) {
    $Members = Get-ADGroupMember -Identity $Group
    [PSCustomObject]@{
        Nom         = $Group.Name
        Description = $Group.Description
        NbMembres   = $Members.Count
        Membres     = ($Members.Name -join ", ")
        Statut      = if ($Members.Count -eq 0) { "VIDE" } else { "Actif" }
    }
}

$Header = "<style>table {border-collapse: collapse; width: 100%;} th, td {border: 1px solid #ddd; padding: 8px; font-family: sans-serif;} th {background-color: #4CAF50; color: white;}</style>"
$GroupData | ConvertTo-Html -Head $Header -Title "Audit des Groupes" | Out-File ".\Rapport_Groupes.html"

Write-Host "Rapport HTML des groupes généré." -ForegroundColor Cyan