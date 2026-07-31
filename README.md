# CursorWow

## Aperçu

CursorWow est un addon World of Warcraft Retail léger qui affiche un repère rond, coloré et redimensionnable à côté de votre curseur souris, directement configurable depuis le jeu.

## Fonctionnalités

- **Deux styles** : icône de raid (colorée nativement) ou rond uni (couleur pure, sans mélange)
- **Couleur ajustable** : Sélectionnez n'importe quelle couleur via le sélecteur de couleur natif du jeu
- **Taille variable** : Ajustez la taille du repère de 8 à 96
- **Position ajustable** : Décalez le repère horizontalement et verticalement autour du curseur réel (de -100 à 100 sur chaque axe), plutôt que de le superposer exactement dessus
- **Affichage intelligent** : le repère ne s'affiche que lorsque le curseur système est en mode gantelet (survol du monde, des sorts, des frames d'unité comme Healbot/raid). Il se cache automatiquement sur les curseurs spéciaux (achat, réparation, courrier, transmogrification) et pendant la rotation de la caméra
- **Panneau d'options natif** : Interface intégrée au menu Options du jeu (pas de framework externe)
- **Léger et performant** : Aucune dépendance externe (pas d'Ace3 ou autre bibliothèque)
- **Paramètres persistants** : Vos préférences sont sauvegardées au niveau du compte et s'appliquent à tous vos personnages

## Installation / Lancement

1. **Localisez votre dossier AddOns** :
   - Naviguez vers `World of Warcraft/_retail_/Interface/AddOns/`

2. **Installez CursorWow** :
   - Copiez (ou créez un lien symbolique vers) le dossier `CursorWow/` dans le répertoire `AddOns`

3. **Activez l'addon** :
   - Au lancement du jeu, sur l'écran de sélection des personnages, cliquez sur « AddOns »
   - Cochez la case à côté de « CursorWow »

4. **Lancez le jeu** :
   - Sélectionnez un personnage et entrez dans le jeu. L'addon se charge automatiquement.

**Note** : CursorWow est conçu pour World of Warcraft Retail uniquement et n'est pas compatible avec Classic.

## Utilisation

Une fois en jeu, ouvrez le menu Paramètres :

1. Appuyez sur **Échap** (Escape) pour ouvrir le menu Principal
2. Allez dans **Options**
3. Sélectionnez l'onglet **AddOns**
4. Cliquez sur **CursorWow**

### Contrôles disponibles

- **Style** : Rond (icône) ou Rond (couleur pure)
- **Taille** : de 8 à 96
- **Décalage horizontal** et **Décalage vertical** : déplacent le repère par rapport à la position réelle du curseur (-100 à 100 sur chaque axe)
- **Afficher uniquement en mode gantelet** : case à cocher pour n'afficher le repère que quand le curseur est en mode interaction/gantelet
- **Afficher uniquement en combat** : case à cocher pour n'afficher le repère qu'en combat
- **Couleur** : Cliquez sur le bouton « Choisir une couleur » pour ouvrir le sélecteur de couleur et personnaliser la teinte du repère

Les modifications s'appliquent instantanément. Vos préférences sont sauvegardées automatiquement.

### Limitation connue

Le curseur spécial affiché **avant** l'ouverture d'une fenêtre (survol direct d'un marchand, d'une boîte aux lettres ou d'un PNJ de transmogrification dans le monde, avant de cliquer) n'est pas détectable par un addon — WoW ne l'expose pas via son API Lua. Le repère reste donc visible dans ce cas précis ; il se masque correctement une fois la fenêtre concernée ouverte.

Une commande `/cursorwow debug` existe pour afficher dans le chat les informations de détection du curseur (utile si un nouveau cas particulier apparaît).

## Déploiement

Pour un usage personnel, aucune étape de compilation ou de package n'est nécessaire. Installez simplement le dossier `CursorWow/` comme indiqué ci-dessus.

Si vous souhaitez publier l'addon sur une plateforme comme **CurseForge** ou **Wago**, créez une archive ZIP contenant le dossier `CursorWow/` avec tous ses fichiers (CursorWow.toc, Core.lua, Options.lua).
