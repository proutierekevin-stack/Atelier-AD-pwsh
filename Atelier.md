Atelier PowerShell & Active Directory

# 1.1 - Installation du module (si nécessaire)
# Vérifiez si le module ActiveDirectory est disponible sur votre système. Si ce n'est pas le cas, installez-le.
     Get-Module -ListAvailable ActiveDirectory                                                                # Vérifier si le Pc à le module
     Add-WindowsCapability -Online -Name Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0                         # Commande pour installer le module si nécessaire.

  # 1.2 - Exploration du module

# Listez toutes les cmdlets disponibles dans le module ActiveDirectory    
    Get-Command -Module ActiveDirectory          
# Combien de cmdlets sont disponibles ?  <span style="color: #FFD700;">**151**</span>
    Get-Command -Module ActiveDirectory | Measure-Object

# Listez uniquement les cmdlets qui commencent par Get-ADUser
    Get-Command -Module ActiveDirectory -Name Get-ADUser*

CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Cmdlet          Get-ADUser                                         1.0.1.0    ActiveDirectory
Cmdlet          Get-ADUserResultantPasswordPolicy                  1.0.1.0    ActiveDirectory

# Affichez l'aide complète de la cmdlet Get-ADUser
    Get-Help Get-ADUser -Full

    

