# ---------------------------------------------------------------------------
# Script : Import-ADUsersFromCSV.ps1 (Version Pro - Corrigée)
# ---------------------------------------------------------------------------

$csvPath = ".\nouveaux_employes.csv"
$logPath = ".\import.log"
$defaultPassword = ConvertTo-SecureString "P@ssw0rd2026!" -AsPlainText -Force
$countSuccess = 0
$countError = 0

function Write-Log {
    param($Message, $Color = "White")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] $Message"
    Write-Host $Message -ForegroundColor $Color
    $logEntry | Out-File -FilePath $logPath -Append
}

if (-not (Test-Path $csvPath)) {
    Write-Log "ERREUR FATALE : Le fichier CSV est introuvable." "Red"
    exit
}

$utilisateurs = Import-Csv -Path $csvPath -Encoding UTF8
Write-Log "--- Début de l'importation ---" "Cyan"

foreach ($row in $utilisateurs) {
    try {
        # 1. Vérifier si l'utilisateur existe déjà
        if (-not (Get-ADUser -Filter "SamAccountName -eq '$($row.Login)'")) {
            # CRÉATION (Si l'utilisateur n'existe PAS)
            $userParams = @{
                'Name'                  = "$($row.Prenom) $($row.Nom)"
                'SamAccountName'        = $row.Login
                'UserPrincipalName'     = $row.Email
                'Path'                  = $row.OU
                'AccountPassword'       = $defaultPassword
                'Enabled'               = $true
                'ChangePasswordAtLogon' = $true
                'Title'                 = $row.Titre
            }
            New-ADUser @userParams
            Write-Log "SUCCÈS : Utilisateur $($row.Login) créé." "Green"
            $countSuccess++
        } 
        else {
            Write-Log "INFO : L'utilisateur $($row.Login) existe déjà. Vérification des groupes..." "Yellow"
        }

        # 2. GESTION DES GROUPES (Exécuté dans TOUS les cas)
        if ($row.Groupes) {
            $groupList = $row.Groupes -split ";"
            foreach ($groupName in $groupList) {
                try {
                    # On tente d'ajouter l'utilisateur au groupe
                    Add-ADGroupMember -Identity $groupName -Members $row.Login -ErrorAction Stop
                    Write-Log "   -> Ajouté au groupe : $groupName" "Gray"
                }
                catch {
                    # Si l'erreur est juste que l'utilisateur est déjà membre, on ne dit rien
                    if ($_.Exception.Message -like "*already exists*") {
                        Write-Log "   (Déjà membre de $groupName)" "DarkGray"
                    } else {
                        Write-Log "   [!] ERREUR Groupe : Impossible d'ajouter $($row.Login) à $groupName" "Red"
                    }
                }
            }
        }
    }
    catch {
        Write-Log "ERREUR : Problème avec $($row.Login). Détail : $($_.Exception.Message)" "Red"
        $countError++
    }
}

Write-Log "--- Résumé ---" "Cyan"
Write-Log "Utilisateurs créés (nouveaux) : $countSuccess" "Green"
Write-Log "Erreurs rencontrées : $countError" "Red"