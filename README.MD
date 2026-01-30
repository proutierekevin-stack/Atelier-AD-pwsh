# Atelier PowerShell & Active Directory

## Contexte professionnel

Vous êtes administrateur système chez **TechSecure**, une entreprise de 200 employés. L'entreprise utilise Active Directory pour gérer les comptes utilisateurs, les groupes et l'organisation de son infrastructure.

Actuellement, toutes les opérations AD se font manuellement via l'interface graphique (ADUC - Active Directory Users and Computers), ce qui prend beaucoup de temps et génère des erreurs. Votre direction souhaite **automatiser** la gestion de l'Active Directory avec PowerShell.

Votre mission : maîtriser PowerShell pour gérer efficacement l'Active Directory et créer des outils d'automatisation pour les tâches courantes.

## Objectifs de l'atelier

À l'issue de cet atelier, vous serez capable de :
- Installer et utiliser le module ActiveDirectory
- Gérer les utilisateurs AD en PowerShell
- Gérer les groupes et leurs membres
- Organiser l'annuaire avec des Unités Organisationnelles
- Importer des utilisateurs en masse depuis CSV
- Créer des scripts d'automatisation pour l'onboarding/offboarding
- Générer des rapports sur l'état de l'AD

---

## Partie 1 : Découverte du module ActiveDirectory

### Objectif
Installer et découvrir le module PowerShell pour Active Directory.

### Travail à réaliser

**1.1 - Installation du module (si nécessaire)**

Vérifiez si le module ActiveDirectory est disponible sur votre système. Si ce n'est pas le cas, installez-le.

**1.2 - Exploration du module**

- Listez toutes les cmdlets disponibles dans le module ActiveDirectory
- Combien de cmdlets sont disponibles ?
- Listez uniquement les cmdlets qui commencent par `Get-ADUser`
- Affichez l'aide complète de la cmdlet `Get-ADUser`

**1.3 - Connexion à l'Active Directory**

- Testez votre connexion à l'AD en récupérant des informations sur le domaine
- Affichez le nom du domaine, le niveau fonctionnel et les contrôleurs de domaine

**1.4 - Premier utilisateur**

- Récupérez les informations de votre propre compte utilisateur AD
- Affichez toutes ses propriétés
- Affichez uniquement son nom, son email et son titre

---

## Partie 2 : Gestion des utilisateurs

### Objectif
Maîtriser les opérations CRUD (Create, Read, Update, Delete) sur les utilisateurs AD.

### Travail à réaliser

**2.1 - Créer des utilisateurs**

Créez les utilisateurs suivants dans l'OU de votre choix :

| Prénom | Nom | Login | Email | Titre |
|--------|-----|-------|-------|-------|
| Alice | Martin | amartin | alice.martin@techsecure.fr | Développeuse |
| Bob | Dubois | bdubois | bob.dubois@techsecure.fr | Administrateur Système |
| Claire | Bernard | cbernard | claire.bernard@techsecure.fr | Chef de Projet |

Pour chaque utilisateur :
- Définir un mot de passe initial (ex: "P@ssw0rd123!")
- Le compte doit être activé
- Le mot de passe doit être changé à la première connexion

**2.2 - Rechercher des utilisateurs**

- Listez tous les utilisateurs de votre domaine
- Trouvez l'utilisateur dont le login est "amartin"
- Trouvez tous les utilisateurs dont le nom commence par "B"
- Trouvez tous les utilisateurs qui ont "Administrateur" dans leur titre
- Comptez le nombre total d'utilisateurs dans votre domaine

**2.3 - Modifier des utilisateurs**

Pour l'utilisateur "amartin" :
- Changez son numéro de téléphone (ajoutez: "01 23 45 67 89")
- Ajoutez une description ("Membre de l'équipe développement")
- Changez son titre en "Développeuse Senior"

**2.4 - Désactiver et supprimer**

- Désactivez le compte "bdubois"
- Vérifiez qu'il est bien désactivé
- Supprimez le compte "cbernard" (attention : demander confirmation avant)

---

## Partie 3 : Gestion des groupes

### Objectif
Créer des groupes de sécurité et gérer les appartenances.

### Travail à réaliser

**3.1 - Créer des groupes**

Créez les groupes de sécurité suivants :

| Nom du groupe | Type | Portée | Description |
|---------------|------|--------|-------------|
| GRP_Developpeurs | Security | Global | Équipe de développement |
| GRP_Admins_Systeme | Security | Global | Administrateurs système |
| GRP_Chefs_Projet | Security | Global | Chefs de projet |
| GRP_IT | Security | Global | Ensemble du département IT |

**3.2 - Ajouter des membres**

- Ajoutez "amartin" dans le groupe "GRP_Developpeurs"
- Ajoutez "bdubois" dans le groupe "GRP_Admins_Systeme"
- Créez 2 nouveaux utilisateurs et ajoutez-les dans "GRP_Developpeurs"
- Ajoutez tous les membres des trois premiers groupes dans "GRP_IT"

**3.3 - Lister les appartenances**

- Affichez tous les membres du groupe "GRP_IT"
- Affichez tous les groupes dont "amartin" est membre
- Comptez combien de membres a chaque groupe

**3.4 - Retirer des membres**

- Retirez "amartin" du groupe "GRP_IT"
- Vérifiez qu'elle n'en est plus membre

**3.5 - Groupes imbriqués**

- Créez un groupe "GRP_Tous_Utilisateurs"
- Ajoutez-y les groupes "GRP_IT" (pas les membres individuels, mais le groupe lui-même)
- Listez les membres (directs et récursifs) de "GRP_Tous_Utilisateurs"

---

## Partie 4 : Organisation avec les Unités Organisationnelles (OU)

### Objectif
Structurer l'annuaire Active Directory avec des OU.

### Travail à réaliser

**4.1 - Créer une structure d'OU**

Créez la structure suivante dans votre domaine :

```
TechSecure/
├── Utilisateurs/
│   ├── Informatique/
│   │   ├── Developpement/
│   │   └── Infrastructure/
│   ├── RH/
│   └── Commercial/
├── Groupes/
└── Ordinateurs/
```

**4.2 - Déplacer des objets**

- Déplacez l'utilisateur "amartin" dans l'OU "TechSecure/Utilisateurs/Informatique/Developpement"
- Déplacez tous vos groupes créés précédemment dans l'OU "TechSecure/Groupes"
- Listez tous les utilisateurs présents dans l'OU "Informatique" (incluant les sous-OU)

**4.3 - Recherche par OU**

- Comptez le nombre d'utilisateurs dans l'OU "Informatique" uniquement (sans les sous-OU)
- Comptez le nombre d'utilisateurs dans l'OU "Informatique" en incluant tous les sous-niveaux

---

## Partie 5 : Import en masse depuis CSV

### Objectif
Automatiser la création d'utilisateurs en important les données depuis un fichier CSV.

### Travail à réaliser

**5.1 - Préparer le fichier CSV**

Créez un fichier `nouveaux_employes.csv` avec la structure suivante :

```csv
Prenom,Nom,Login,Email,Titre,Departement,OU
David,Petit,dpetit,david.petit@techsecure.fr,Développeur,Informatique,OU=Developpement,OU=Informatique,OU=Utilisateurs,OU=TechSecure
Emma,Roux,eroux,emma.roux@techsecure.fr,Administratrice Réseau,Informatique,OU=Infrastructure,OU=Informatique,OU=Utilisateurs,OU=TechSecure
François,Moreau,fmoreau,francois.moreau@techsecure.fr,Recruteur,RH,OU=RH,OU=Utilisateurs,OU=TechSecure
```

Ajoutez au moins 10 autres lignes avec des employés fictifs.

**5.2 - Script d'import basique**

Créez un script `Import-ADUsersFromCSV.ps1` qui :
- Lit le fichier CSV
- Pour chaque ligne, crée un utilisateur AD avec toutes les propriétés
- Définit un mot de passe par défaut
- Active le compte
- Affiche un message pour chaque utilisateur créé

**5.3 - Améliorer le script avec gestion d'erreurs**

Modifiez votre script pour :
- Vérifier que le CSV existe avant de commencer
- Utiliser `try-catch` pour gérer les erreurs de création
- Vérifier si l'utilisateur existe déjà avant de le créer
- Logger les succès et les erreurs dans un fichier `import.log`
- Afficher un résumé à la fin (X créés, Y erreurs)

**5.4 - Ajouter les groupes lors de l'import**

Ajoutez une colonne "Groupes" dans votre CSV (plusieurs groupes séparés par des points-virgules).

Modifiez votre script pour ajouter automatiquement les utilisateurs dans les groupes spécifiés.

---

## Partie 6 : Scripts d'automatisation

### Objectif
Créer des scripts réutilisables pour les tâches courantes.

### Travail à réaliser

**6.1 - Script d'onboarding**

Créez un script `New-Employee.ps1` qui prend des paramètres et effectue un onboarding complet :

Le script doit :
- Accepter en paramètres : Prénom, Nom, Titre, Département, Manager
- Générer automatiquement le login (première lettre prénom + nom)
- Générer l'email (@techsecure.fr)
- Créer l'utilisateur dans la bonne OU selon le département
- Générer un mot de passe aléatoire sécurisé
- Ajouter l'utilisateur dans les groupes appropriés selon son département
- Envoyer un email de bienvenue (simulation avec Write-Host)
- Logger toutes les opérations

**6.2 - Script d'offboarding**

Créez un script `Remove-Employee.ps1` qui :
- Prend en paramètre le login de l'utilisateur
- Désactive le compte
- Retire l'utilisateur de tous ses groupes
- Déplace l'utilisateur vers une OU "Comptes Désactivés"
- Réinitialise son mot de passe
- Ajoute une note dans la description avec la date de désactivation
- Logger toutes les opérations
- Demande confirmation avant chaque action critique

**6.3 - Script de modification de mot de passe**

Créez un script `Reset-EmployeePassword.ps1` qui :
- Prend en paramètre le login
- Génère un nouveau mot de passe aléatoire sécurisé
- Change le mot de passe de l'utilisateur
- Force le changement à la prochaine connexion
- Affiche le nouveau mot de passe (pour transmission sécurisée)
- Déverrouille le compte si nécessaire

---

## Partie 7 : Rapports et audits

### Objectif
Créer des scripts de reporting pour auditer l'Active Directory.

### Travail à réaliser

**7.1 - Rapport des utilisateurs inactifs**

Créez un script `Get-InactiveUsers.ps1` qui :
- Liste tous les utilisateurs n'ayant pas changé leur mot de passe depuis plus de 90 jours
- Affiche : Login, Nom, Dernière modification du mot de passe, Jours depuis modification
- Trie par nombre de jours décroissant
- Exporte le résultat en CSV

**7.2 - Rapport des comptes désactivés**

Créez un script qui :
- Liste tous les comptes utilisateurs désactivés
- Affiche : Login, Nom, OU, Date de désactivation (si dans description)
- Compte le nombre total
- Exporte en CSV

**7.3 - Rapport des groupes et membres**

Créez un script qui :
- Liste tous les groupes de sécurité
- Pour chaque groupe, affiche le nombre de membres
- Identifie les groupes vides
- Exporte un rapport détaillé en HTML avec :
  - Nom du groupe
  - Description
  - Nombre de membres
  - Liste des membres

**7.4 - Rapport d'audit complet**

Créez un script `Get-ADHealthReport.ps1` qui génère un rapport HTML complet avec :
- Nombre total d'utilisateurs (actifs/désactifs)
- Nombre total de groupes
- Nombre d'OU
- Top 10 des groupes avec le plus de membres
- Liste des utilisateurs dont le mot de passe n'expire jamais
- Liste des utilisateurs avec des mots de passe expirés
- Statistiques par département

---

## Partie 8 : Projet final - Outil de gestion AD complet

### Objectif
Créer un outil interactif complet de gestion Active Directory.

### Travail à réaliser

**8.1 - Menu principal**

Créez un script `AD-Manager.ps1` avec un menu interactif proposant :

```
=== GESTIONNAIRE ACTIVE DIRECTORY ===

UTILISATEURS
1. Créer un utilisateur
2. Rechercher un utilisateur
3. Modifier un utilisateur
4. Désactiver un utilisateur
5. Supprimer un utilisateur

GROUPES
6. Créer un groupe
7. Ajouter un membre à un groupe
8. Retirer un membre d'un groupe
9. Lister les membres d'un groupe

IMPORT/EXPORT
10. Importer des utilisateurs depuis CSV
11. Exporter tous les utilisateurs en CSV

RAPPORTS
12. Rapport des utilisateurs inactifs
13. Rapport des groupes
14. Audit complet

AUTRES
15. Réinitialiser un mot de passe
16. Quitter
```

**8.2 - Fonctionnalités avancées**

Ajoutez à votre outil :
- Validation des entrées utilisateur
- Gestion d'erreurs robuste avec try-catch
- Messages colorés (succès en vert, erreurs en rouge, avertissements en jaune)
- Confirmation avant les actions destructives
- Logging de toutes les opérations dans un fichier
- Possibilité de revenir au menu après chaque action

**8.3 - Tests**

Testez votre outil en effectuant :
- La création de 5 nouveaux utilisateurs
- L'import d'un CSV de 10 utilisateurs
- La création de 3 groupes et l'ajout de membres
- La génération d'un rapport complet
- La désactivation d'un utilisateur

---

## Partie 9 : Synthèse et bonnes pratiques

### Objectif
Réfléchir aux apprentissages et aux bonnes pratiques.

### Travail à réaliser

**9.1 - Documentation**

Créez un fichier `README.md` qui documente :
- Tous les scripts que vous avez créés
- Comment les utiliser
- Les prérequis nécessaires
- Des exemples d'utilisation

**9.2 - Réflexion**

Créez un fichier `RETOUR_EXPERIENCE.txt` répondant aux questions :

1. Quelles sont les 3 cmdlets AD que vous utilisez le plus souvent ?
2. Quelle est la différence entre `-Filter` et `-LDAPFilter` ?
3. Pourquoi est-il important de toujours utiliser `try-catch` avec les opérations AD ?
4. Comment feriez-vous pour gérer l'AD de plusieurs domaines différents ?
5. Quels sont les risques de sécurité à considérer lors de l'automatisation AD ?
6. Comment pourriez-vous améliorer vos scripts pour une utilisation en production ?

**9.3 - Améliorations futures**

Listez 5 fonctionnalités que vous pourriez ajouter à votre outil de gestion AD pour le rendre encore plus utile en production.

---

## Ressources utiles

**Documentation Microsoft** :
- Module ActiveDirectory : https://docs.microsoft.com/powershell/module/activedirectory/
- Gestion des utilisateurs AD : https://docs.microsoft.com/windows-server/identity/ad-ds/

**Cmdlets essentielles** :
- Utilisateurs : `Get-ADUser`, `New-ADUser`, `Set-ADUser`, `Remove-ADUser`
- Groupes : `Get-ADGroup`, `New-ADGroup`, `Add-ADGroupMember`, `Get-ADGroupMember`
- OU : `Get-ADOrganizationalUnit`, `New-ADOrganizationalUnit`, `Move-ADObject`
- Domaine : `Get-ADDomain`, `Get-ADForest`, `Get-ADDomainController`

---

## Conseils pour réussir 💡

**Organisation** :
- Créez un dossier `C:\Scripts\AD` pour tous vos scripts
- Nommez vos scripts de manière explicite (verbe-nom)
- Commentez votre code au fur et à mesure

**Sécurité** :
- Ne stockez jamais de mots de passe en clair dans vos scripts
- Testez toujours dans un environnement de test avant la production
- Utilisez `-WhatIf` pour simuler les actions destructives
- Demandez confirmation pour les suppressions

**Debugging** :
- Utilisez `Write-Host` ou `Write-Verbose` pour tracer l'exécution
- Testez vos filtres avec `Get-ADUser` avant de créer/modifier
- Vérifiez les propriétés disponibles avec `Get-ADUser | Get-Member`

**Performance** :
- Utilisez `-Filter` plutôt que `Where-Object` pour filtrer côté serveur
- Limitez les propriétés récupérées avec `-Properties` uniquement si nécessaire
- Pour de gros volumes, utilisez `-ResultSetSize` pour limiter les résultats

---