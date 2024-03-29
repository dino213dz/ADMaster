
function Get-Domain-name () {
    #$domaine_infos = Get-WmiObject Win32_NTDomain -Filter "DnsForestName = '$( (Get-WmiObject Win32_ComputerSystem).Domain)'"
    #$nom_domaine = $wmiDomain.DomainName

    $domaine_infos=Get-ADDomain
    $domaine_nom=$domaine_infos.name

    return $domaine_nom
} #fucntion

function CN-Format ([string] $chaine) {
    [string] $domaine=$(Get-Domain-name)
    [string] $fulldomaine=$chaine -replace ".*$domaine,DC=","$domaine."

    
    $chaine=$chaine -replace "DC=.*",""

    [array] $tableau=$chaine.split(',')
    [array]::Reverse($tableau)
    [string] $chaine_formattee="$fulldomaine"

    foreach ($element in $tableau){
        $chaine_formattee="$chaine_formattee$element"
        $chaine_formattee=$chaine_formattee -replace "OU=","\"
        $chaine_formattee=$chaine_formattee -replace "CN=","\"
        }

    return $chaine_formattee
} #fucntion

function Show-Infos-AD  () {
    
    $domaine_infos=Get-ADDomain
    $res_req_csv=$domaine_infos

    $domaine_nom=$domaine_infos.name
    $domaine_foret=$domaine_infos.Forest
    $domaine_master=$domaine_infos.InfrastructureMaster
    $domaine_os=$domaine_infos.DomainMode
    $domaine_replica=$domaine_infos.ReplicaDirectoryServers
    $domaine_ou_users=$(CN-Format $domaine_infos.UsersContainer)
    $domaine_ou_computers=$(CN-Format $domaine_infos.ComputersContainer)
    $domaine_ou_suppr=$(CN-Format $domaine_infos.DeletedObjectsContainer)
    $domaine_ou_dc=$(CN-Format $domaine_infos.DomainControllersContainer)
    $domaine_ou_secu=$(CN-Format $domaine_infos.ForeignSecurityPrincipalsContainer)
    $domaine_ou_lost=$(CN-Format $domaine_infos.LostAndFoundContainer)
    $domaine_ou_quotas=$(CN-Format $domaine_infos.QuotasContainer)
    $domaine_ou_sys=$(CN-Format $domaine_infos.SystemsContainer)
    
    
    Write-host "$p_titre Domaine : " -ForegroundColor $col_titre -BackgroundColor $fnd_titre -NoNewline
    Write-host "$domaine_nom" -ForegroundColor $col_warning -BackgroundColor $fnd_default
    
    Write-host "$p_titre Foret : " -ForegroundColor $col_titre -BackgroundColor $fnd_titre -NoNewline
    Write-host "$domaine_foret" -ForegroundColor $col_warning -BackgroundColor $fnd_default
    
    #Write-host "$p_titre Serveur Maitre : " -ForegroundColor $col_titre -BackgroundColor $fnd_titre -NoNewline
    #Write-host "$domaine_master ($domaine_os)" -ForegroundColor $col_warning -BackgroundColor $fnd_default
    
    Write-host "$p_titre Serveurs de réplication : " -ForegroundColor $col_titre -BackgroundColor $fnd_titre
    foreach ($srvreplica in $domaine_replica){
        Write-host " |_$p_soustitre " -ForegroundColor $col_soustitre -BackgroundColor $fnd_soustitre -NoNewline
        if ($srvreplica -eq $domaine_master){
            Write-host "$srvreplica (Master)" -ForegroundColor $col_warning -BackgroundColor $fnd_soustitre
            }
        else {
            Write-host "$srvreplica" -ForegroundColor $col_warning -BackgroundColor $fnd_soustitre
            }
        }
    
    Write-host "$p_titre Unités Organisationnelles : " -ForegroundColor $col_titre -BackgroundColor $fnd_titre
    Write-host " |_$p_soustitre Users : " -ForegroundColor $col_soustitre -BackgroundColor $fnd_soustitre -NoNewline
    Write-host "$domaine_ou_users" -ForegroundColor $col_warning -BackgroundColor $fnd_soustitre
    Write-host " |_$p_soustitre Computers : " -ForegroundColor $col_soustitre -BackgroundColor $fnd_soustitre -NoNewline
    Write-host "$domaine_ou_computers" -ForegroundColor $col_warning -BackgroundColor $fnd_soustitre
    Write-host " |_$p_soustitre Objets Supprimés : " -ForegroundColor $col_soustitre -BackgroundColor $fnd_soustitre -NoNewline
    Write-host "$domaine_ou_suppr" -ForegroundColor $col_warning -BackgroundColor $fnd_soustitre
    Write-host " |_$p_soustitre Domain Cotrollers : " -ForegroundColor $col_soustitre -BackgroundColor $fnd_soustitre -NoNewline
    Write-host "$domaine_ou_dc" -ForegroundColor $col_warning -BackgroundColor $fnd_soustitre
    Write-host " |_$p_soustitre Sécurité " -ForegroundColor $col_soustitre -BackgroundColor $fnd_soustitre -NoNewline
    Write-host "$domaine_ou_secu" -ForegroundColor $col_warning -BackgroundColor $fnd_soustitre
    Write-host " |_$p_soustitre Objets perdus et trouvés : " -ForegroundColor $col_soustitre -BackgroundColor $fnd_soustitre -NoNewline
    Write-host "$domaine_ou_lost" -ForegroundColor $col_warning -BackgroundColor $fnd_soustitre
    Write-host " |_$p_soustitre Quotas : " -ForegroundColor $col_soustitre -BackgroundColor $fnd_soustitre -NoNewline
    Write-host "$domaine_ou_quotas" -ForegroundColor $col_warning -BackgroundColor $fnd_soustitre
    Write-host " |_$p_soustitre Système : " -ForegroundColor $col_soustitre -BackgroundColor $fnd_soustitre -NoNewline
    Write-host "$domaine_ou_sys" -ForegroundColor $col_warning -BackgroundColor $fnd_soustitre
    
    #Ask-Export-CSV $res_req_csv

} #fucntion