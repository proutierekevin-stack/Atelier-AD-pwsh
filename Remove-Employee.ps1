param(
    [Parameter(Mandatory=$true)][string]$Login
)

# 1. Définition de l'OU de quarantaine
$DisabledOU = "OU=Comptes Desactives,OU=TechSecure,DC=formation,DC=lan"

# 2. Vérification si l'utilisateur existe
try {
    $User = Get-ADUser -Identity $Login -Properties MemberOf
    
    # 3. Demande de confirmation (Sécurité !)
    $Confirm = Read-Host "Voulez-vous vraiment désactiver $Login ? (O/N)"
    if ($Confirm -ne "O") { return }

    # 4. Désactivation et ajout d'une note dans la description
    $Date = Get-Date -Format "dd/MM/yyyy"
    Set-ADUser -Identity $Login -Enabled $false -Description "Compte désactivé le $Date"

    # 5. Retrait de tous les groupes (pour la sécurité)
    $Groups = Get-ADPrincipalGroupMembership -Identity $Login | Where-Object { $_.Name -ne "Domain Users" }
    if ($Groups) {
        Remove-ADGroupMember -Identity $Groups -Members $Login -Confirm:$false
    }

    # 6. Déplacement vers l'OU "Comptes Désactivés"
    Move-ADObject -Identity $User.DistinguishedName -TargetPath $DisabledOU

    Write-Host "L'utilisateur $Login a été désactivé, nettoyé et déplacé." -ForegroundColor Yellow
}
catch {
    Write-Host "Erreur : Utilisateur $Login introuvable." -ForegroundColor Red
}