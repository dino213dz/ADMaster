function Get-Groups-user () {
    Show-Messages "Groupe de sécurité de l'utilsiateurs :" "titre" $true
    
    $user_cible='xxxxxxxx'
    do{
        write-host " |_[?] Login (laisser vide pour annuler)" -ForegroundColor $col_soustitre -BackgroundColor $fnd_soustitre -NoNewline
        $user_cible=read-host " "
        if ($user_cible.length -eq 0) {return}
        [string] $test=Get-ADUser -Filter "sAMAccountName -eq '$($user_cible)'" 
        if (($user_cible -ne '$user_cible') -and ($test.length -eq 0)) {
            write-host "    |_[X] compte <$user_cible> inexistant!" -ForegroundColor $col_erreur -BackgroundColor $fnd_titre
            }       
        } while ($test.length -eq 0)
    
    write-host " |_[+] Nom `  : " -ForegroundColor $col_soustitre -BackgroundColor $fnd_soustitre -NoNewline
    write-host $(Get-ADUser -Identity $user_cible| Select-Object Name).Name -ForegroundColor $col_warning -BackgroundColor $fnd_soustitre

    $res_req=Get-ADUser -Identity $user_cible -Properties MemberOf | Select-Object -ExpandProperty MemberOf | Get-ADGroup -Properties name | Select-Object name| Sort-Object name 
    $res_req_csv=Get-ADUser -Identity $user_cible -Properties MemberOf | Select-Object -ExpandProperty MemberOf | Get-ADGroup -Properties name
    $total=$res_req.count
    write-host " |_[+] Total : " -ForegroundColor $col_soustitre -BackgroundColor $fnd_soustitre  -NoNewline
    write-host "$total" -ForegroundColor $col_warning -BackgroundColor $fnd_soustitre
   
    
    Show-Messages "Résultat [ordre=nom]:" "titre" $true

    $compteur=0
    foreach ($compte in $res_req){
        $compteur++        
        $compteur_txt=$(Calcul-Zeros $compteur $total)

        $liste_groupes=$compte.Name
        

        foreach ($groupe in $liste_groupes) {
            write-host " |_[$compteur_txt] " -ForegroundColor $col_soustitre -BackgroundColor $fnd_soustitre -NoNewline
            write-host "$groupe" -ForegroundColor $col_warning -BackgroundColor $fnd_default
            }
        }
    Ask-Export-CSV $res_req_csv

} #fucntion
