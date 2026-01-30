param([Parameter(Mandatory=$true)][string]$Login)

$DisabledOU = "OU=Comptes Desactives,OU=TechSecure,DC=formation,DC=lan"
if (-not (Get-ADOrganizationalUnit -Filter "Name -eq 'Comptes Desactives'")) {
     New-ADOrganizationalUnit -Name "Comptes Desactives" -Path "OU=TechSecure,DC=formation,DC=lan"
}

try {
     $title = "Offboarding de $Login"
     $message = "Voulez-vous vraiment désactiver et déplacer le compte $Login ?"
     $choices = [System.Management.Automation.Host.ChoiceDescription[]] @("&Oui", "&Non")
     $decision = $Host.UI.PromptForChoice($title, $message, $choices, 1)

     if ($decision -eq 0) {
         $date = Get-Date -Format "dd/MM/yyyy"
         # --- CETTE LIGNE DOIT ÊTRE ICI ---
         Set-ADUser -Identity $Login -Enabled $false -Description "Désactivé le $date"
         
         $groups = Get-ADPrincipalGroupMembership -Identity $Login | Where-Object { $_.Name -ne "Domain Users" }
         if ($groups) { Remove-ADGroupMember -Identity $groups -Members $Login -Confirm:$false }

         Move-ADObject -Identity (Get-ADUser $Login).DistinguishedName -TargetPath $DisabledOU
         Write-Host "L'employé $Login a été traité avec succès." -ForegroundColor Yellow
     }
}
catch { Write-Host "Erreur : $($_.Exception.Message)" -ForegroundColor Red }