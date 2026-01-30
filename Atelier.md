Atelier PowerShell & Active Directory

#         PARTIE 1
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
-----------     ----                                               -------    ------
Cmdlet          Get-ADUser                                         1.0.1.0    ActiveDirectory
Cmdlet          Get-ADUserResultantPasswordPolicy                  1.0.1.0    ActiveDirectory

# Affichez l'aide complète de la cmdlet Get-ADUser
    Get-Help Get-ADUser -Full

# 1.3 - Connexion à l'Active Directory
# Testez votre connexion à l'AD en récupérant des informations sur le domaine    
    Get-ADDomain
# Affichez le nom du domaine, le niveau fonctionnel et les contrôleurs de domaine
    Get-ADDomain | Select-Object DNSRoot, DomainMode

     DNSRoot              DomainMode
     -------              ----------
   formation.lan           Windows2025Domain

# 1.4 - Premier utilisateur

# Récupérez les informations de votre propre compte utilisateur AD     
# Affichez toutes ses propriétés
    Get-ADUser -Identity "Administrateur" -Properties *

# Affichez uniquement son nom, son email et son titre
    Get-ADUser -Identity "Administrateur" -Properties EmailAddress, Title | Select-Object Name, EmailAddress, Title

    ------------------------------------------------------------------------------------------------

#        PARTIE 2 
# GESTION DES UTILISATEURS

# 2.1 - Créer des utilisateurs
# Créez les utilisateurs suivants dans l'OU de votre choix :

Prénom  	Nom	    Login	     Email	                           Titre
Alice    	Martin	 amartin	alice.martin@techsecure.fr  	 Développeuse
Bob     	Dubois   bdubois    bob.dubois@techsecure.fr	     Administrateur Système
Claire	    Bernard	 cbernard	claire.bernard@techsecure.fr	 Chef de Projet

# Création du OU (TechSecure)
    New-ADOrganizationalUnit -Name "TechSecure" -Path "DC=formation,DC=lan"
# Création du OU (Users)
    New-ADOrganizationalUnit -Name "Users" -Path "OU=TechSecure,DC=formation,DC=lan"

# Création des utilisateurs    (Définir un mot de passe initial (ex: "P@ssw0rd123!", Le compte doit être activé, Le mot de passe doit être changé à la première connexion)

![alt text](<carbon (7).png>)


# 2.2 Rechercher des utilisateurs
# Lister tous les utilisateur de votre domaine
    Get-ADUser -Filter *

# Trouver l'utilisateur dont le login est "amartin"
    Get-ADUser -Identity "amartin"

# Trouver les utilisateurs dont le nom commence par un "B"
    Get-ADUser -Filter 'Surname -like "B*"' | Select-Object Name, SamAccountName

# Trouvez tous les utilisateurs qui ont "Administrateur" dans leur titre
    


