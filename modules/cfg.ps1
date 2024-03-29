$admaster_config_dossier_modules='.\modules'
$admaster_help_file="$admaster_config_dossier_modules\hlp.txt"
$admaster_titre = "AD master"
$admaster_version = "0.1 Beta"
$admaster_titre_original=$(get-host).ui.rawui.WindowTitle
$admaster_slogan="maitrise ton AD"
$admaster_fichier_temp="./tmp"

$admaster_format_header=" $admaster_titre - Menu principal "
$admaster_format_header=" $admaster_titre : $admaster_version "
$admaster_header_motif=" "
$admaster_format_middle=" Console - §TITRE_PAGE§ " #§TITRE_PAGE§ sera remplacé par le titre ed la console/commande
$admaster_format_footer=" $admaster_titre - $admaster_slogan - Ver. $admaster_version - $admaster_maj_date "


#Ordre modules important!
$admaster_modules=@(@("std.ps1","standard"),
                    @("gfx.ps1","graphique"),
                    @("adc.ps1","domaine"),
                    @("grp.ps1","groupes de sécurité ActiveDirectory"), 
                    @("gpo.ps1","groupes Policy Objects"), 
                    @("usr.ps1","utilisateurs ActiveDirectory"),
                    @("sys.ps1","systeme"),
                    @("csv.ps1","outils CSV")
                    )

#Theme etcoloration
#    col= couleur du texte
#    fnd=couleur du fond
#-------------------------------------------------------------
# Menu: Header
$col_header="Yellow"
$fnd_header="magenta"
$col_section="yellow"
$fnd_section="Darkmagenta"
#baniere de saisie
$col_saisie="black"
$fnd_saisie="Yellow"
# couleurs du texte
$col_default="White"
$fnd_default="DarkMagenta"
$col_ok="Green"
$fnd_ok="DarkGreen"
$col_erreur="Red"
$fnd_erreur="DarkRed"
$col_warning="Yellow"
$fnd_warning="DarkYellow"

$col_titre="Magenta" #couleur des categories
$fnd_titre="DarkMagenta" #couleur des categories
$col_soustitre="Cyan" #couleur des liens
$fnd_soustitre="DarkMagenta" #couleur des liens
$col_message="Yellow"
$fnd_message="DarkMagenta"
$col_highlight="darkCyan" #couleur des liens selectionnés
$fnd_highlight="DarkMagenta" #couleur des liens selectionnés
#puces
$p_default="[O]"
$p_erreur="[¤]"
$p_warning="[!]"
$p_section="[o]"
$p_titre="`n[+]"
$p_soustitre="[-]"
$p_infos="[i]"
$p_ok="[OK]"

#categories
$admaster_categories=@(  "Utilisateurs", #0
                         "Groupes de sécurité", #1
                         "Group Policies object (GPO)", #2
                         "Domaine", #3
                         "Autres" #4
                  )

#chaque lien est definit par : titre, categorie(index array admaster_categories), function à executer
#les liens sont affichés dans cet ordre
#les liens de meme categorie doivent se suivre sinon un label de cette categorie sera recree a chaque fois
#le lien quitter doit etre en dernier
$admaster_liens=@(  @("Information ActiveDirectory", 3, 'Show-Infos-AD' ),
                    @("désactivés", 0, 'Get-Users-desactives' ),
                    @("actif mais inutilisés depuis un certain nombre de jours", 0, 'Get-Users-inactifs' ),
                    @("actif mais jamais connectés", 0, 'Get-Users-jamaisCo' ),
                    @("Comptes de test actifs", 0, 'Get-Users-test' ),
                    @("Comptes admin désactivés", 0, 'Get-Users-admin-desactives' ),
                    @("Groupe de sécurité d'un utilisateur", 1, 'Get-Groups-user' ),
                    @("GPO désactivées",  2, 'Get-Gpo-Disabled' ),
                    @("Infos Systeme ",  4, 'Get-Sys-infos' ),
                    @("Aide", 4, 'Show-Help' ),              #le lien aide doit etre en avant-dernier
                    @("Quitter $admaster_titre", 4, "Quitter" ) #le lien quitter doit etre en dernier
                    )

$lien_par_defaut=($admaster_liens.count-1) #aide
$lien_par_defaut=1