#-------------------------------------------------- Récuperation des arguments -------------------------------------------------- 
 [CmdletBinding()] 
 param(
   [Parameter(Mandatory=$false)]
  $output,$sortie,$fichier,$file,  
  [switch] $help,[switch] $aide,[switch] $h,            #commande
  [switch] $centreon                                #parametre
 )

#------------------------------------ CONFIGURATION DE L'ENVIRONNEMENT -------------------------------------- 
#variables
$ErrorActionPreference="Stop"
$prefBackup=$WarningPreference
$WarningPreference='SilentlyContinue'

$admaster_config_file=".\modules\cfg.ps1"

$c_msg="Cyan";$c_fmsg="Black";$c_tit="Cyan"
$e_msg="Red";$e_fmsg="DarkRed"
$h_msg="Yellow";$h_fmsg="Black"

#--------------------arguments : traitement ----------------------------------

# si false: mode verbeux, sinon silent
$mode_cmdline=($help -or $aide -or $h) -or ($check -or $verify -or $t)


#affiche l'aide et quitte le programme
if ($help -or $aide -or $h){
    $help_brut=Get-Content "$admaster_help_file"
    ForEach ($ligne in $help_brut) {
        write-host "$ligne" #-ForegroundColor $col_soustitre 
        }
    exit
}#if


#---------------------------------------- CHARGEMENT DES MODULES -------------------------------------------- 
clear-host

#chargement du fichier config
try {
    #chargement.....
    Write-Host "[+] Chargement du fichier de configuration : $module" -BackgroundColor 'darkMagenta' -ForegroundColor 'cyan'

    Import-Module ActiveDirectory
    Import-Module GroupPolicy

     . ($admaster_config_file)
    Write-Host " |_[OK] Chargement du fichier de configuration effectué $admaster_config_dossier_modules!" -BackgroundColor 'darkMagenta' -ForegroundColor 'cyan'
}
catch {
    #erreur de chargement des modules...
    Write-Host " |_[!] Erreur lors du chargement du fichier config : $admaster_config_file" -BackgroundColor 'darkMagenta' -ForegroundColor cyan
    Write-Host "`n`n"
    exit
}

#chargement des modules
try {
    Write-Host "`n[+] Chargement des modules" -BackgroundColor 'darkMagenta' -ForegroundColor 'cyan'
    #chargement.....
    ForEAch ($module in $admaster_modules) {
        $mod_file="$admaster_config_dossier_modules\"+$module[0]
        $mod_desc=$module[1]
        Write-Host " |_[-] Chargement du module <$mod_desc> : " -BackgroundColor 'darkMagenta' -ForegroundColor 'cyan'
        . ("$mod_file")
        }
    Write-Host " |_[OK] Chargement des modules effectué" -BackgroundColor 'darkMagenta' -ForegroundColor 'cyan'
    }

catch {
    #erreur de chargement des modules...
    Write-Host " |_[!] Erreur de chargement de module <$mod_desc> : $mod_file" -BackgroundColor 'darkMagenta' -ForegroundColor $col_erreur
    #Write-Host " |_[!] Debug du module : " -BackgroundColor $col_default -ForegroundColor $col_erreur
    $msgerr=$_.Exception.Message
    #$msgerr=$msgerr -replace "  ",""
    if ("$msgerr" -match "`n *~")     {$msgerr=$msgerr -replace "`n.*~+.*",""}
    else                           {$msgerr=$msgerr -replace "`n","`n          "}

    $ligne=($($msgerr -replace "At ","Ligne :").split("{:}")[3]).split("{ }")[0]
    $colonne=($($msgerr -replace "Char","").split("{:}")[3]).split("{`n}")[0]
    $msgerr=$msgerr -replace "At .*"," "
    $msgerr=$msgerr -replace "[+]",""
    #$errname=$_.Exception.ItemName
    $catinfo=$_.Exception.getType()
    #$fqeid=$_.Exception.FullyQualifiedErrorId
    #Write-Host "    |_[!] Nom de l'erreur  : $errname" -BackgroundColor 'darkMagenta' -ForegroundColor $col_erreur
    Write-Host "    |_[!] Ligne : $ligne " -BackgroundColor 'darkMagenta' -ForegroundColor $col_erreur
    Write-Host "    |_[!] Colonne : $colonne " -BackgroundColor 'darkMagenta' -ForegroundColor $col_erreur
    Write-Host "    |_[!] Categorie : $catinfo " -BackgroundColor 'darkMagenta' -ForegroundColor $col_erreur
    #Write-Host "    |_[!] Error ID  : $fqeid " -BackgroundColor 'darkMagenta' -ForegroundColor $col_erreur
    Write-Host "    |_[!] Message d'erreur : " -BackgroundColor 'darkMagenta' -ForegroundColor $col_erreur -NoNewline
    Write-Host "    $msgerr " -BackgroundColor 'darkMagenta' -ForegroundColor $col_warning
    exit
    }

#debug
#Write-Host "`n$msg_chargement_ok"  -BackgroundColor $c_fmsg -ForegroundColor $c_msg -NoNewline
#sleep $admaster_delai_affichage_messages;Write-Host "." -BackgroundColor $c_fmsg -ForegroundColor $c_msg -NoNewline
#sleep $admaster_delai_affichage_messages;Write-Host "." -BackgroundColor $c_fmsg -ForegroundColor $c_msg -NoNewline
#sleep $admaster_delai_affichage_messages;Write-Host "." -BackgroundColor $c_fmsg -ForegroundColor $c_msg -NoNewline

#-------------------------------------------------- Affichage du titre -------------------------------------------------- 
Clear-Host

#Set-Position 1 1
#Set-Resolution 140 40
Set-Title "$admaster_titre $admaster_version"

#-------------------------------------------------- Affichage du menu -------------------------------------------------- 
try {
    Show-Main $lien_par_defaut
    }
#un CTRL+C

catch {
    Quitter "$admaster_titre $admaster_version n'arrive pas à afficher le menu!" $true
    }

#-------------------------------------------------- fin du script -------------------------------------------------- 
#quitter dans les regles...
Quitter "$admaster_titre $admaster_version vous dit à bientôt!" $false