﻿<#
#---------------------------------------------------------------------------------------------------------------
TITRE : Module de fonctions d'interfaces graphiques 
VERSION : 1.0
DATE CREATION : 06.06.2019

DESCRIPTION
Ce module configure et affiche une interface graphique
Cette interface graphique est dotée :
 - d'une banniere <header>(entete) : titre, version...
 - d'une deuxiemme banniere <console>(milieu) : indique la fonction en cours d'execution et 
 - d'une baniere <footer>(pied de page) : Copyrights...

Cette inetrface graphique interagit avec les differents fonctions du module virtuel
Ces differentes fonctions sont affichés dans un menu


LISTE DES FONCTIONS DE CE MODULE : 

 - Set-Header ($titre, $col, $fnd)
 - Set-Menu-Header ($titre) {
 - Set-Sousmenu-Header ($titre) {
 - Set-Menu-Footer () {
 - Show-Saisie ()
 - Show-Menu-List ()
 - Show-Main ($index)
 - Check-Choix ($choix)
 - Check-Choix-Import ($choix)
 - Run-Commande-Mauvais-Choix ($choix_utilisateur) 
 - Run-Commande-Mauvais-Choix-Import ($choix_utilisateur) 
 - Run-Commande-Mauvais-Choix-Fichier ($choix_utilisateur)

#---------------------------------------------------------------------------------------------------------------
#>
function Show-Logo {
    $titre="   __    ____     __  __    __    ___  ____  ____  ____ "#premiere ligne, largeur fixe, meme que les suivantes
    #calcul des espaces à remplir
    $largeurEcran=$(Get-Host).UI.RawUI.WindowSize.Width
    $diff=($largeurEcran-$titre.length)
    $arrondi=$([math]::round($diff))

    #si chiffre impair, ajouter un espace a droite
    if ($diff -eq $arrondi) {
        $espace_d=" "
        $espace_g=""
        }
    else {
        $espace_d=""
        $espace_g=""
        }    

    #remplir les espaces
    for ($x=1; $x -le $diff/2; $x++) {
        $espace_d=$espace_d+" "
        $espace_g=$espace_g+" "
        }

    Show-Messages "$espace_g   __    ____     __  __    __    ___  ____  ____  ____ " 'titre' $false
    Show-Messages "$espace_g  /__\  (  _ \   (  \/  )  /__\  / __)(_  _)( ___)(  _ \" 'titre' $false
    Show-Messages "$espace_g /(__)\  )(_) )   )    (  /(__)\ \__ \  )(   )__)  )   /" 'titre' $false
    Show-Messages "$espace_g(__)(__)(____/   (_/\/\_)(__)(__)(___/ (__) (____)(_)\_)" 'titre' $false
    Show-Messages "$espace_g https://github.com/dino213dz/ADMaster              V1.0" 'soustitre' $false

}

function Set-Header ($titre, $col, $fnd) {
    #calcul des espaces à remplir
    $largeurEcran=$(Get-Host).UI.RawUI.WindowSize.Width
    $diff=($largeurEcran-$titre.length)
    $arrondi=$([math]::round($diff))

    #si chiffre impair, ajouter un espace a droite
    if ($diff -eq $arrondi) {
        $espace_d=$admaster_header_motif
        $espace_g=""
        }
    else {
        $espace_d=""
        $espace_g=$admaster_header_motif
        }    

    #remplir les espaces
    for ($x=1; $x -le $diff/2; $x++) {
        $espace_d=$espace_d+$admaster_header_motif
        $espace_g=$espace_g+$admaster_header_motif
        }
    
    #afficher le titre
    Write-host $espace_g$titre$espace_g -BackgroundColor $fnd -ForegroundColor $col
    
    #pour debug:
    #Write-host "col=$col/fnd=$fnd `nlargeurEcran=$largeurEcran`n titre_taille="($titre.length)"`n diff=$diff`n x=$x" -BackgroundColor $fnd_header -ForegroundColor $col_header
}

function Set-Menu-Header ($titre) {
    #titre du menu principal
    $titre="$admaster_format_header"
    Set-Header  $titre $col_header $fnd_header
} #fucntion

function Set-Sousmenu-Header ($titre) {
    #titre de la Console
    $titre=$admaster_format_middle -replace "§TITRE_PAGE§","$titre"
    Set-Header  $titre $col_header $fnd_header
} #fucntion

function Set-Menu-Footer () {
    #titre du menus du bas
    $domaine=$(Get-Domain-name)
    $hostname=$(hostname)
    $date=$(date)#$admaster_header_motif$admaster_header_motif
    $infos="[DOMAINE:$domaine]"
    $infos=$infos+"[hostname:$hostname ]"
    $infos=$infos+"[date:$date ]"
    #$titre=$admaster_format_footer
    Set-Header $infos $col_header $fnd_header
} #fucntion
#------------------------------------------------------------------------------------------
function Show-Menu-List ($index) {

    $categorie_actuelle=-1 #aucune categorie selectionnée au depart, on check celle des liens
    $index_lien=0 # position du lien dans array admaster_liens
    $index_user=1  # raccourcis affiché à l'utilisateur, on commence à 1 car incrementation debut boucle

    ForEach ($lien in $admaster_liens) {
        $lien_titre=$lien[0]
        $lien_cat=$lien[1]
        $lien_fct=$lien[2]

        if ($lien_cat -ne $categorie_actuelle ) {
            $cat_titre=$admaster_categories[$lien_cat]
            $categorie_actuelle=$lien_cat
            Show-Messages "$cat_titre :" "titre" $true
            }#if

        if ($index_lien -eq $index) {
            write-host " |_[$index_user]" -ForegroundColor $col_highlight -BackgroundColor $fnd_soustitre -NoNewline
            write-host " " -ForegroundColor $col_warning -BackgroundColor $fnd_default -NoNewline
            write-host "$lien_titre" -ForegroundColor $col_highlight -BackgroundColor $fnd_highlight -NoNewline
            write-host " <<" -ForegroundColor $col_warning -BackgroundColor $fnd_default
            }
        else {
            Show-Messages " |_[$index_user] $lien_titre" "soustitre" $false
            }
        
        $index_lien++
        $index_user++
        }#ForEach

} #fucntion

function Show-Main ($choix_utilisateur) {
    
    do {           
        $index=$(Check-Choix $choix_utilisateur)
        
        if ($index -eq -1) {
            $mauvais_choix=$true
            $index=$lien_par_defaut-1
            }
        else {
            $mauvais_choix=$false
            }  
          
        #recup parametres commande
        $infos_commande=$admaster_liens[$index]
        $lien_titre=$infos_commande[0]
        $lien_cat=$infos_commande[1]
        $lien_fct=$infos_commande[2]
        $page=$lien_titre   
        function Run-Commande { & "$lien_fct" } 
        

        #effacer l'ecran
        Clear-Host

        #afficher lme titre de la fenetre
        Set-Menu-Header $admaster_slogan #"Menu Principal"
        
        #afficher le logo
        Show-Logo

        #afficher le menu
        Show-Menu-List ($index)
        
        #titre
        Set-Sousmenu-Header $page

        #lancer la commande        
        Run-Commande

        #afficher le bas
        Set-Menu-Footer "Copyrights"

        #barre rouge en cas de mauvaise saisie
        if ($mauvais_choix) {
            Run-Commande-Mauvais-Choix ($choix_utilisateur)
            }

        $choix_utilisateur=$(Show-Saisie)        

    }while ($choix_utilisateur -ne ($admaster_liens.count) )
    
    #Quitter                 

} #fucntion

function Show-Saisie () {

    #titre du menus du bas
    $titre="Saisissez une option svp : "
    Set-Header $titre $col_saisie $fnd_saisie
    $saisie_utilisateur=read-host
    $saisie_utilisateur=$saisie_utilisateur -replace "^0*",""
    Show-messages $saisie_utilisateur "message" $false
    return "$saisie_utilisateur"

} #fucntion
#------------------------------------------------------------------------------------------
function Check-Choix ($choix) {
    
    $choix=$choix -replace " ",""
    $choix_is_int=$choix -match "^\d+$"
    $i_min=1
    $i_max=$admaster_liens.count
    
    if ($choix_is_int){   
        $choix = $choix -as [int]   
        
        if ( ($choix -gt $i_max) -or ($choix -lt $i_min) ) {
            $retour=-1
            }
        else {#integer et bonne plage
            $retour=($choix-1)
            }
              
        }
    else {#not integer
        $retour=-1
        }

    return $retour
}#function

function Check-Choix-Import ($choix) {
    
    $choix=$choix -replace " ",""

    $choix_is_int=$choix -match "^\d+$"
    $i_min=1
    $i_max=3
    
    if ($choix_is_int){   
        $choix = $choix -as [int]
        
        if ( ($choix -gt $i_max) -or ($choix -lt $i_min) ) {
            $retour=-1
            }
        else {#integer et bonne plage
            $retour=($choix-1)
            }
              
        }
    else {#not integer
        $retour=-1
        }

    return $retour
    }
#------------------------------------------------------------------------------------------    
function Run-Commande-Mauvais-Choix ($choix_utilisateur) {     
    $message="mauvais choix <$choix_utilisateur>"
    Set-Header $message $col_erreur $fnd_erreur
    }

function Run-Commande-Mauvais-Choix-Import ($choix_utilisateur) {
    write-host " |_[mauvais choix]_______/" -ForegroundColor $col_erreur 
    }

function Run-Commande-Mauvais-Choix-Fichier ($choix_utilisateur) {
    write-host " |_[Fichier introuvable]_______________________________________________________/" -ForegroundColor $col_erreur 
    }
#------------------------------------------------------------------------------------------
function Show-Help {
    #write-host " Aide à l'utilisation ici...." -ForegroundColor $col_erreur 
    $help_brut=Get-Content "$admaster_help_file" # | Where-Object {$_ -match $regex}
    $no_ligne=0
    ForEach ($ligne in $help_brut) {
        $no_ligne++
        if($ligne.length -ge 3) {$test=$ligne.Substring(0,3)}
        switch($test){
        [+] {   write-host "$ligne" -ForegroundColor $col_titre
                }
        --- {
                write-host "$ligne" -ForegroundColor $col_soustitre
                }
        ___ {
                write-host "$ligne" -ForegroundColor $col_soustitre
                }
        default {
                if ($no_ligne -le 4){
                    write-host "$ligne" -ForegroundColor $col_titre
                    }
                else {
                    write-host "$ligne" -ForegroundColor $col_default
                    }
                }
            }
        }
    }
