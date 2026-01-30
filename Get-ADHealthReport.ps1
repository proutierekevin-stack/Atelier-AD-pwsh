# ---------------------------------------------------------------------------
# Script : Get-ADHealthReport.ps1
# Description : Génère un rapport de santé complet de l'Active Directory
# ---------------------------------------------------------------------------

# --- 1. Collecte des Statistiques Globales ---
$TotalUsers = (Get-ADUser -Filter *).Count
$ActiveUsers = (Get-ADUser -Filter 'Enabled -eq $true').Count
$DisabledCount = $TotalUsers - $ActiveUsers
$TotalGroups = (Get-ADGroup -Filter *).Count
$TotalOUs = (Get-ADOrganizationalUnit -Filter *).Count

# --- 2. Top 10 des Groupes les plus peuplés ---
$TopGroups = Get-ADGroup -Filter * -Properties Members | 
    Select-Object @{Name="Nom du Groupe"; Expression={$_.Name}}, @{Name="Nombre de Membres"; Expression={$_.Members.Count}} | 
    Sort-Object "Nombre de Membres" -Descending | Select-Object -First 10 | 
    ConvertTo-Html -Fragment

# --- 3. Alertes Sécurité ---
$PassNeverExpires = Get-ADUser -Filter 'PasswordNeverExpires -eq $true' | Select-Object Name, SamAccountName
$ExpiredPass = Get-ADUser -Filter 'PasswordExpired -eq $true' | Select-Object Name, SamAccountName

# --- 4. Statistiques par Département ---
$DeptStats = Get-ADUser -Filter * -Properties Department | 
    Group-Object Department | 
    Select-Object @{Name="Departement"; Expression={$_.Name}}, @{Name="Nombre"; Expression={$_.Count}} | 
    Sort-Object Nombre -Descending | 
    ConvertTo-Html -Fragment

# --- 5. Design et Construction du HTML ---
$Header = @"
<style>
    body { font-family: 'Segoe UI', Arial, sans-serif; margin: 30px; background-color: #f8f9fa; }
    h1 { color: #2c3e50; border-bottom: 2px solid #3498db; padding-bottom: 10px; }
    h2 { color: #2980b9; margin-top: 30px; }
    .stat-box { background: white; padding: 15px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); display: inline-block; min-width: 200px; margin-right: 20px; }
    table { width: 100%; border-collapse: collapse; margin-top: 10px; background: white; }
    th { background-color: #34495e; color: white; padding: 10px; text-align: left; }
    td { padding: 8px; border-bottom: 1px solid #ddd; }
    tr:nth-child(even) { background-color: #f2f2f2; }
    .alert { color: #e74c3c; font-weight: bold; }
</style>
"@

$Content = @"
$Header
<h1>Rapport de Sante TechSecure AD</h1>
<p>Genere le : $(Get-Date -Format "dd/MM/yyyy HH:mm")</p>

<h2>Statistiques Globales</h2>
<div class="stat-box"><strong>Utilisateurs :</strong> $TotalUsers ($ActiveUsers Actifs / $DisabledCount Desactives)</div>
<div class="stat-box"><strong>Total Groupes :</strong> $TotalGroups</div>
<div class="stat-box"><strong>Total OUs :</strong> $TotalOUs</div>

<h2>Top 10 des Groupes (Plus de membres)</h2>
$TopGroups

<h2>Repartion par Departement</h2>
$DeptStats

<h2>Alertes Securite</h2>
<ul>
    <li class="alert">Utilisateurs avec MDP qui n'expire jamais : $(@($PassNeverExpires).Count)</li>
    <li>Utilisateurs avec MDP expire : $(@($ExpiredPass).Count)</li>
</ul>
"@

# --- 6. Exportation ---
$Content | Out-File ".\Get-ADHealthReport.html" -Encoding UTF8
Write-Host "Rapport de sante complet genere avec succes dans C:\Scripts\Get-ADHealthReport.html" -ForegroundColor Magenta