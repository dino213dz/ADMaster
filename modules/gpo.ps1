function Get-Gpo-Disabled () {

    Show-Messages "GPO désactivées :" "titre" $true

    $res_req=$(Get-GPO -all| Where-Object -FilterScript {($_.GpoStatus -eq "computersettingsDisabled") -or ($_.GpoStatus -eq "usersettingsDisabled")}|Sort-Object -Property DisplayName) #|Format-Table -AutoSize -Property DisplayName,GpoStatus
    $res_req_csv=$(Get-GPO -all| Where-Object -FilterScript {($_.GpoStatus -eq "computersettingsDisabled") -or ($_.GpoStatus -eq "usersettingsDisabled")}|Sort-Object -Property DisplayName) 
    $total=$res_req.count

    write-host " |_[+] Total : " -ForegroundColor $col_soustitre -BackgroundColor $fnd_soustitre  -NoNewline
    write-host "$total" -ForegroundColor $col_warning -BackgroundColor $fnd_soustitre
   
    
    Show-Messages "Liste des GPO par nom dans l'ordre ascendant :" "titre" $true
    
    $compteur=0
    foreach ($gpo in $res_req){
        $compteur++        
        $compteur_txt=$(Calcul-Zeros $compteur $total)
        
        $gpo_nom=$gpo.DisplayName 
        $gpo_etat=$gpo.GpoStatus
        $gpo_etat=$gpo_etat -replace "SettingsDisabled"," Settings Disabled "    

        #$tabulations=$(Calcul-Tabulations "|_[$compteur_txt] $gpo_nom ")   

        write-host " |_[$compteur_txt] " -ForegroundColor $col_soustitre -BackgroundColor $fnd_soustitre -NoNewline
        write-host "$gpo_nom : " -ForegroundColor $col_soustitre -BackgroundColor $fnd_soustitre -NoNewline
        write-host "$gpo_etat" -ForegroundColor $col_warning -BackgroundColor $fnd_default
        
        }
        
    Ask-Export-CSV $res_req_csv


} #fucntion