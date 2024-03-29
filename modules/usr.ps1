
function Get-Users-desactives () {
    Show-Messages "Utilisateurs désactivés :" "titre" $true

    $res_req=Search-ADAccount –AccountDisabled –UsersOnly –ResultPageSize 2000 –ResultSetSize $null | Select-Object Name, SamAccountName, LastLogonDate | Sort-Object SamAccountName
    $res_req_csv=Search-ADAccount –AccountDisabled –UsersOnly –ResultPageSize 2000 –ResultSetSize $null
    $total=$res_req.count
    

    write-host " |_$p_soustitre Total : " -ForegroundColor $col_soustitre -BackgroundColor $fnd_soustitre -NoNewline
    write-host "$total " -ForegroundColor $col_ok -BackgroundColor $fnd_titre

    Show-Messages "Liste par nom d'utilisateur dans ordre ascendant :" "titre" $true

    $compteur=0
    foreach ($compte in $res_req){
        $compteur++        
        $compteur_txt=$(Calcul-Zeros $compteur $total)

        $login=$compte.SamAccountName
        $nom_affichage=$compte.Name
        $date_derniere_co=$compte.LastLogonDate
        $ou=$compte.DistinguishedName
        
        $tabulations=$(Calcul-Tabulations "|_[$compteur_txt] $login")

        write-host " |_[$compteur_txt] $login : $tabulations " -ForegroundColor $col_soustitre -BackgroundColor $fnd_soustitre -NoNewline
        write-host "$nom_affichage " -ForegroundColor $col_ok -BackgroundColor $fnd_titre -NoNewline

        if($date_derniere_co.length -eq 0 ) {
            $date_derniere_co="jamais connecté(e)"
            write-host "$date_derniere_co" -ForegroundColor $col_erreur -BackgroundColor $fnd_default
            }
        else {
            write-host "inactif depuis le " -ForegroundColor $col_default -BackgroundColor $fnd_default -NoNewline
            write-host "$date_derniere_co" -ForegroundColor $col_warning -BackgroundColor $fnd_default
            }
        }
    Ask-Export-CSV $res_req_csv

} #fucntion

function Get-Users-inactifs () {
    #write-host "Utilisateurs inactifs..."
    Show-Messages "Utilisateurs inactifs :" "titre" $true

    
    write-host " |_[?] Depuis combien de jours svp? (laisser vide pour annuler)" -ForegroundColor $col_soustitre -BackgroundColor $fnd_soustitre -NoNewline
    $nb_jours=read-host " "
    if ($nb_jours.length -eq 0) {return}

    
    $res_req=Search-ADAccount –AccountInActive –TimeSpan ${nb_jours}:00:00:00 –ResultPageSize 2000 –ResultSetSize $null | ?{ ($_.Enabled –eq $True) -or ($_.Enabled –eq 'SamAccountName')} | Select-Object Name, SamAccountName, LastLogonDate, DistinguishedName| Sort-Object LastLogonDate, SamAccountName
    $res_req_csv=Search-ADAccount –AccountInActive –TimeSpan ${nb_jours}:00:00:00 –ResultPageSize 2000 –ResultSetSize $null | ?{ ($_.Enabled –eq $True) -or ($_.Enabled –eq 'SamAccountName')} 
    $total=$res_req.count
    
    
    write-host " |_$p_soustitre Total : " -ForegroundColor $col_soustitre -BackgroundColor $fnd_soustitre -NoNewline
    write-host "$total " -ForegroundColor $col_ok -BackgroundColor $fnd_titre

    Show-Messages "Liste par date de la derniere connexion. Les plus anciens d'abord :" "titre" $true



    $compteur=0
    foreach ($compte in $res_req){
        $compteur++
        $compteur_txt=$(Calcul-Zeros $compteur $total)

        $login=$compte.SamAccountName
        $nom_affichage=$compte.Name
        $date_derniere_co=$compte.LastLogonDate
        $ou=$compte.DistinguishedName
        
        $tabulations=$(Calcul-Tabulations "|_[$compteur_txt] $login")

        write-host " |_[$compteur_txt] $login : $tabulations " -ForegroundColor $col_soustitre -BackgroundColor $fnd_soustitre -NoNewline
        
        
        if($date_derniere_co.length -eq 0 ) {
            $date_derniere_co="jamais connecté(e)"
            write-host "$date_derniere_co" -ForegroundColor $col_erreur -BackgroundColor $fnd_default
            }
        else {
            write-host "inactif depuis le " -ForegroundColor $col_default -BackgroundColor $fnd_default -NoNewline
            write-host "$date_derniere_co" -ForegroundColor $col_warning -BackgroundColor $fnd_default
            }
        }
    Ask-Export-CSV $res_req_csv

} #fucntion

function Get-Users-jamaisCo () {
    #Show-Messages "Utilisateurs jamais connectés : Développement en cours..." "titre" $true
    #return
    #---------


    Show-Messages "Utilisateurs jamais connectés :" "titre" $true

    #$res_req=Get-ADUser -filter * –ResultPageSize 2000 –ResultSetSize $null | Select-Object Name, SamAccountName| Sort-Object SamAccountName
    $res_req=Search-ADAccount –AccountInActive –TimeSpan 99999:00:00:00 –ResultPageSize 2000 –ResultSetSize $null | ?{ ($_.Enabled –eq $True) -or ($_.Enabled –eq 'SamAccountName')} | Select-Object Name, SamAccountName, LastLogonDate, DistinguishedName| Sort-Object LastLogonDate, SamAccountName
    $res_req_csv=Search-ADAccount –AccountInActive –TimeSpan 99999:00:00:00 –ResultPageSize 2000 –ResultSetSize $null | ?{ ($_.Enabled –eq $True) -or ($_.Enabled –eq 'SamAccountName')} 
    $total=$res_req.count
    
    write-host " |_$p_soustitre Total : " -ForegroundColor $col_soustitre -BackgroundColor $fnd_soustitre -NoNewline
    write-host "$total " -ForegroundColor $col_ok -BackgroundColor $fnd_titre

    Show-Messages "Liste par nom d'utilisateur dans ordre ascendant :" "titre" $true

    $compteur=0
    foreach ($compte in $res_req){
        $compteur++        
        $compteur_txt=$(Calcul-Zeros $compteur $total)

        $login=$compte.SamAccountName
        $nom_affichage=$compte.Name
        #$date_derniere_co=$(Get-ADObject -Properties lastLogon -Identity "$login")
        
        $tabulations=$(Calcul-Tabulations "|_[$compteur_txt] $login")

        write-host " |_[$compteur_txt] $login : $tabulations " -ForegroundColor $col_soustitre -BackgroundColor $fnd_soustitre -NoNewline
        write-host " $nom_affichage" -ForegroundColor $col_warning -BackgroundColor $fnd_default
        }
    Ask-Export-CSV $res_req_csv

} #fucntion

function Get-Users-test () {
    #write-host "Utilisateurs inactifs..."
    Show-Messages "Utilisateurs test actifs :" "titre" $true

    $res_req=Search-ADAccount –AccountInActive –ResultPageSize 2000 –ResultSetSize $null | ?{ ($_.Enabled –eq $True) -and (($_.Name –match 'test') -or ($_.SamAccountName –like 'tst'))} | Select-Object Name, SamAccountName, LastLogonDate, DistinguishedName| Sort-Object LastLogonDate
    $res_req_csv=Search-ADAccount –AccountInActive –ResultPageSize 2000 –ResultSetSize $null | ?{ ($_.Enabled –eq $True) -and (($_.Name –match 'test') -or ($_.SamAccountName –like 'tst'))}  #|format-table
    $total=$res_req.count
    
    write-host " |_$p_soustitre Total : " -ForegroundColor $col_soustitre -BackgroundColor $fnd_soustitre -NoNewline
    write-host "$total " -ForegroundColor $col_ok -BackgroundColor $fnd_soustitre

    Show-Messages "Liste par date de derniere connexion. les plus anciens d'abord :" "titre" $true

    $compteur=0
    foreach ($compte in $res_req){
        $compteur++
        $compteur_txt=$(Calcul-Zeros $compteur $total)

        $login=$compte.SamAccountName
        $nom_affichage=$compte.Name
        $date_derniere_co=$compte.LastLogonDate
        $ou=$compte.DistinguishedName
        
        $tabulations=$(Calcul-Tabulations "|_[$compteur_txt] $login")

        write-host " |_[$compteur_txt] $login : $tabulations " -ForegroundColor $col_soustitre -BackgroundColor $fnd_soustitre -NoNewline
        
        if($date_derniere_co.length -eq 0 ) {
            $date_derniere_co="jamais connecté(e)"
            write-host "$date_derniere_co" -ForegroundColor $col_erreur -BackgroundColor $fnd_default
            }
        else {
            write-host "inactif depuis le " -ForegroundColor $col_default -BackgroundColor $fnd_default -NoNewline
            write-host "$date_derniere_co" -ForegroundColor $col_warning -BackgroundColor $fnd_default
            }
        }

    Ask-Export-CSV $res_req_csv

} #fucntion

function Get-Users-admin-desactives () {
    #write-host "Utilisateurs inactifs..."
    Show-Messages "Administrateur désactivés :" "titre" $true

    try {
        $res_req=Get-ADGroupMember "Domain Admins" |Select-Object $_.Enabled|Select-Object Name, SamAccountName, LastLogonDate, DistinguishedName| Sort-Object SamAccountName
        $res_req_csv=Get-ADGroupMember "Domain Admins" |Select-Object $_.Enabled
        }
    catch {
        $res_req=Get-ADGroupMember "Admins du domaine" |Select-Object $_.Enabled|Select-Object Name, SamAccountName, LastLogonDate, DistinguishedName| Sort-Object SamAccountName
        $res_req_csv=Get-ADGroupMember "Admins du domaine" |Select-Object $_.Enabled
        }
    $total=$res_req.count
    
    write-host " |_$p_soustitre Total : " -ForegroundColor $col_soustitre -BackgroundColor $fnd_soustitre -NoNewline
    write-host "$total " -ForegroundColor $col_ok -BackgroundColor $fnd_soustitre

    Show-Messages "Liste par nom d'utilisateur dans ordre ascendant :" "titre" $true

    $compteur=0
    foreach ($compte in $res_req){
        $compteur++
        $compteur_txt=$(Calcul-Zeros $compteur $total)

        $login=$compte.SamAccountName
        $nom_affichage=$compte.Name
        $date_derniere_co=$compte.LastLogonDate
        $ou=$(CN-Format $compte.DistinguishedName)
        
        $tabulations=$(Calcul-Tabulations "|_[$compteur_txt] $login")

        write-host " |_[$compteur_txt] $login : $tabulations " -ForegroundColor $col_soustitre -BackgroundColor $fnd_soustitre -NoNewline        
        
        write-host "$nom_affichage" -ForegroundColor $col_warning -BackgroundColor $fnd_default -NoNewline
        write-host " [$ou]" -ForegroundColor $col_default -BackgroundColor $fnd_default
        }
    Ask-Export-CSV $res_req_csv

} #fucntion

