
function Export-CSV ($liste, $fichier_destination) {    
    $liste | export-csv "$fichier_destination"
}


function Ask-Export-CSV ([array] $liste_a_exporter) {  
    [int] $nb_lignes=$liste_a_exporter.count+1
    
    #$liste_a_exporter=$($liste_a_exporter|format-table|ConvertTo-Csv)
    Show-Messages "Exporter ces résultats vers un fichier CSV ($nb_lignes lignes)?" 'titre' $true
    $verif=$(Ask-OuiNon " |_[?]  Tapez <oui> pour confirmer : " $col_soustitre $fnd_soustitre)
    
    if ($verif){
        
        Write-host "`n[+] Fichier destination :" -ForegroundColor $col_titre -BackgroundColor $fnd_titre
        Write-host " |_[-] Chemin (Laissez vide pour annuler) : " -ForegroundColor $col_soustitre -BackgroundColor $fnd_soustitre -NoNewline
        $fichier_csv_destination=read-host
        
        if ($fichier_csv_destination.length -eq 0){
            Show-Messages "`n[+] Export annulé!" 'titre' $false
            return
            }
        
        Write-host "`n[+] Export :" -ForegroundColor $col_titre -BackgroundColor $fnd_titre
        Write-host " |_[-] Destination : " -ForegroundColor $col_soustitre -BackgroundColor $fnd_soustitre -NoNewline
        Write-host "$fichier_csv_destination" -ForegroundColor $col_warning -BackgroundColor $fnd_default       
        

        try {
            #write-host " |_[i] info : " -ForegroundColor $col_soustitre -NoNewline
            #write-host "Fonction d'export en cours de dévelopement!" -ForegroundColor $col_warning
            [array] $array_csv = $liste_a_exporter|ConvertTo-Csv -NoTypeInformation -Delimiter ";"
            foreach ($ligne in $array_csv){
                Write-Output $ligne >> $fichier_csv_destination
                }
            notepad $fichier_csv_destination
            }
        catch {
            $erreur=$_.Exception.Message
            $erreur=$erreur -replace "Could not find a part of the path","Verifiez le chemin. Un dossier doit manquer"
            write-host " |_[X] erreur : " -ForegroundColor $col_soustitre -NoNewline
            write-host "$erreur" -ForegroundColor $col_erreur
            }
        Show-Messages "`n[+] Export terminé!" 'titre' $false
        }
    else {
        Show-Messages "`n[+] Export annulé!" 'titre' $false
        }
}
