# 7.1 - Utilisateurs inactifs (MDP > 90 jours)
$90DaysAgo = (Get-Date).AddDays(-90)
$InactiveUsers = Get-ADUser -Filter 'PasswordLastSet -le $90DaysAgo' -Properties PasswordLastSet | 
    Select-Object SamAccountName, Name, PasswordLastSet, @{Name="Jours"; Expression={(New-TimeSpan -Start $_.PasswordLastSet -End (Get-Date)).Days}} |
    Sort-Object Jours -Descending

$InactiveUsers | Export-Csv -Path ".\Rapport_Inactifs.csv" -NoTypeInformation -Encoding UTF8

# 7.2 - Comptes désactivés
$DisabledUsers = Get-ADUser -Filter 'Enabled -eq $false' -Properties Description, CanonicalName | 
    Select-Object SamAccountName, Name, @{Name="OU"; Expression={$_.DistinguishedName.Split(',',2)[1]}}, Description

$DisabledUsers | Export-Csv -Path ".\Rapport_Desactives.csv" -NoTypeInformation -Encoding UTF8

Write-Host "Rapports 7.1 et 7.2 générés en CSV." -ForegroundColor Green