[![License](https://img.shields.io/badge/license-GPLv2-green.svg)](https://github.com/dino213dz)
![logo](https://avatars2.githubusercontent.com/u/34544107 "ADMaster by dino213dz")

# DESCRIPTION:

 - Outil permettant d'effectuer les fréquentes tâches de maintenance rapidement.
 - Tous les résultats sont exportables en csv.
 - Ce script possède un menu et des raccourcis

# UTILISATION:
 - Le script doit être lancé depuis la ligne de commande powershell.
 - Le module Powershell AD dit être disponibles.
 - Il faut donc lancer le script depuis un serveur AD avec les droits administrateurs

 - Exemple:
    - ADMaster.ps1

# FLEXIBILITE
 - L'outil est entierrement parametrable sans éditer le code principal
 - Il suffit d'éditer le fichier "modules/cfg.ps1" 
 - Il est possible d'ajouter d'autres scripts et leurs fonctions facilement.
 - Ajouter des catégories
 - Modifier les couleurs de l'interface
 - Modifier les messages affichés à l'ecran


## Ajouter une categorie:
   - Pour ajouter une catégorie de menus (ensemble de liens)
     - Ouvrir le fichier "modules/cfg.ps1" 
     - Editer la variable "$admaster_categories" et ajoutez une entrée au tableau
     - Ajoutez votre entree à la fin du tableau derniere case pour ne pas trop casser l'agencement: ("entrée","entree2","Entree3"..."Votre entree")
   - Remarque:
     - L'ordre des categries est important car il sert d'index aux liens. La premiere etant le n° zero

## Ajouter un lien:
     - Ouvrir le fichier "modules/cfg.ps1" 
     - Editer la variable "$admaster_liens" et ajoutez une entrée au tableau
     - Chaque entrée est un tableau également : @("Titre du lien", numero_index_categorie, 'NomFonction' )
### Remarque:
     - L'ordre des categories des liens est important. Chaque lien affiche sa caategorie si le lien précedent n'est pas de la meme categorie.
     - Si vous souhaitez avoir une seule categorie suivie de ses liens, il est necessaire que les categories se suivent.

## Captures d'écran:
![logo](http://dino213dz.online.fr/img/screenshot/ADMaster_1.0_Screenshot.jpg "ADMaster.sh 1.0")
