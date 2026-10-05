---
name: veille-strategique-ia
description: "Veille IA, opportunités business et rapports Google Sheet."
version: 1.0.0
license: MIT
author: Hermes Agent
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [veille, ia, opportunites, business, celdel, google-sheets, drive, composio]
    category: research
---

# Veille stratégique IA et opportunités business (Celdel AI)

Repérer l'actualité IA et en tirer des opportunités de marché exploitables, puis livrer un
rapport dans un **Google Sheet déposé dans le Drive** de l'utilisateur.

## When to Use : quand l'utiliser

- « quelles sont les actus IA ? », « fais-moi un rapport de veille »
- « quelles opportunités business l'IA ouvre-t-elle ? », « quels besoins d'entreprise l'IA peut résoudre ? »
- « nouveaux outils / modèles IA », « gains de productivité », « signaux à surveiller »
- toute demande de rapport de veille destinée à Celdel AI

## LES 4 THÈMES (cadre imposé par le SOUL.md du profil)

1. **Productivité**, gains de productivité, automatisation des processus.
2. **Outils IA**, nouveaux outils, modèles, fonctionnalités.
3. **Opportunités métier**, nouveaux besoins ou problèmes d'entreprise que l'IA peut résoudre.
4. **Signaux à surveiller**, signaux faibles, évolutions réglementaires, mouvements fournisseurs.

## RÈGLE DE LIVRAISON : le Google Sheet, systématiquement

**Tout rapport de veille est livré dans un Google Sheet déposé dans le Drive.** C'est une
convention permanente de ce profil, pas une option. Ne jamais se contenter d'un tableau dans le
chat quand le Drive est joignable.

Voie d'accès : **Composio CLI**. Ne pas passer par `hermes mcp` : le CLI est au niveau machine
(binaire dans `~/.local/bin`, session dans `~/.composio/config.json`, hors de `HERMES_HOME`) et
sert donc **tous les profils** sans installation supplémentaire.

Structure du classeur (onglets sans apostrophe, la notation A1 exigerait de les doubler) :

| Onglet | Contenu |
|---|---|
| `Synthèse` | Les constats qui engagent une décision, **dont ce qui n'est PAS démontré** |
| `Opportunités` | Fiches d'opportunité + score, triées par score décroissant |
| `Actualités` | Fiches d'actualité en 8 points, classées par thème |
| `Financements` | Dispositifs publics qui paient le conseil et la formation |
| `Signal terrain` | Citations de praticiens (Reddit, HN) qui corroborent ou contredisent une opportunité, **avec leur limite d'échantillon** |
| `Sources` | Chaque source, son niveau de fiabilité, ce qu'elle documente |
| `À vérifier` | Ce qui bloque un usage public, avec priorité |
| `Méthode` | Grille de score, niveaux de fiabilité et de maturité, règles appliquées |

## Procédure

### 1. Ancrer la date et vérifier le profil actif

```bash
date -u "+%Y-%m-%d %H:%M UTC (%A)"
echo "$HERMES_HOME"
```

Un profil peut avoir été renommé ou repointé depuis la session précédente : `profile.yaml`
contient `previous_names`. Relire le `SOUL.md` du profil actif si la mission semble avoir changé, 
c'est lui qui fait foi, pas le souvenir de la session précédente.

### 2. Rechercher : 3 sources de signal complémentaires

- `web_search` (FR + EN, avec le mois et l'année dans la requête) puis `web_extract` sur les
  sources les plus prometteuses.
- **last30days** pour le signal d'engagement réel (Reddit, Hacker News, Polymarket, GitHub) :
  vaut surtout pour repérer une douleur vécue, qu'aucune dépêche ne documente.
  Toujours `--no-browser-cookies`. Ne pas charger son `SKILL.md` (260 Ko).
- Sources publiques officielles : rapports parlementaires, France Num, Bpifrance, INSEE, CNIL,
  documentation éditeur.

**Le chiffre le plus utile n'est presque jamais dans l'actualité : il est dans les enquêtes
publiques.** Croiser systématiquement le fait du jour avec la statistique de marché qui le chiffre.

### 3. Distinguer fait, affirmation et analyse

Trois niveaux à ne jamais confondre dans une même phrase :

- **Fait**, ce que dit la source, attribué nommément.
- **Affirmation de la source**, un communiqué éditeur, une étude commanditée par un acteur du marché.
- **Analyse**, la lecture de l'assistant, présentée comme telle.

### 4. Niveaux de fiabilité

| Niveau | Type | Usage |
|---|---|---|
| Élevée | Source officielle, rapport parlementaire, étude identifiable, média citant sa source primaire | Citable |
| Moyenne | Étude **commanditée par une partie prenante**, média relayant un média, presse en accès partiel | Citable **en attribuant explicitement le commanditaire** |
| Faible | Blog commercial, agrégateur | Piste uniquement, jamais citable |

### 5. Niveaux de maturité (champ obligatoire)

`Disponible` (déployé ou en vigueur) · `En test` · `Annoncé` · `Spéculatif` (prise de position
sans dispositif opérationnel). **Ne jamais présenter une annonce comme une preuve d'efficacité.**

### 6. Fiche d'actualité : 8 points imposés

1. Titre et date · 2. Résumé factuel · 3. Pourquoi c'est pertinent · 4. Problème métier concerné ·
5. Application possible · 6. Niveau de maturité · 7. Points de vigilance · 8. Sources avec lien et date.

### 7. Score d'opportunité (sur 100)

| Critère | Poids |
|---|---|
| Intensité de la douleur | 20 |
| Preuve de disposition à payer | 20 |
| Faisabilité avec l'IA | 15 |
| Fenêtre de tir (caractère récent du signal) | 15 |
| Différenciation face à la concurrence connue | 15 |
| Effort et délai, inversés | 15 |

**Seuil : 70.** En dessous, l'opportunité passe en observation, elle ne figure pas au rapport.
Le score est une **estimation de l'assistant**, à écrire noir sur blanc dans l'onglet Méthode.

### 8. Publier dans le Drive (Composio CLI)

```bash
composio whoami                                          # session existante ?
composio connections list                                # googlesheets / googledrive actifs ?
composio execute <SLUG> --get-schema                     # TOUJOURS avant d'appeler
composio execute GOOGLESHEETS_CREATE_GOOGLE_SHEET1 -d '{"title":"..."}'
composio execute GOOGLESHEETS_UPDATE_SHEET_PROPERTIES -d '{...}'   # renommer Sheet1
composio execute GOOGLESHEETS_ADD_SHEET -d '{...}'                 # un appel par onglet
composio execute GOOGLESHEETS_VALUES_UPDATE -d @payload.json       # value_input_option: RAW
composio execute GOOGLESHEETS_VALUES_GET -d '{...}'                # relecture obligatoire
```

Écrire le script Python sous `write_file` puis l'exécuter, pas de heredoc géant à retaper.
Le script doit **relire chaque onglet et comparer au nombre de lignes attendu**. Un
`successful: true` n'est pas une preuve : le comptage l'est.

### 9. Nettoyer derrière soi

Un script relancé après un plantage crée un **classeur orphelin à chaque tentative**. Avant de
recréer : lister avec `GOOGLESHEETS_SEARCH_SPREADSHEETS` (`-d '{"query":"<fragment de titre>"}'`,
un fragment simple, une syntaxe de requête Drive ne remonte rien) et **mettre le doublon à la
corbeille** avec `GOOGLEDRIVE_TRASH_FILE -d '{"file_id":"..."}'`. La suppression par défaut est
réversible : la préférer.

## Pitfalls

- **Ne jamais coder en dur le nom d'un profil dans un chemin de skill.** Résoudre via
  `$HERMES_HOME` (ex. `$HERMES_HOME/skills/research/last30days`). Un profil renommé, c'est arrivé, 
  fait échouer toutes les commandes restées sur l'ancien chemin, et un `cd` raté en tâche de fond
  se solde par une sortie vide qui passe pour « pas de résultat » au lieu d'une erreur.
- **Un signal communautaire n'est pas une mesure de marché.** Des citations de praticiens avec
  2 à 8 votes confirment une intuition ; elles ne chiffrent rien. Joindre la taille de l'échantillon
  et le nombre de votes à chaque ligne, et une ligne de limite explicite pour l'ensemble.
- **Relire avec une plage EXPLICITE, jamais `'Onglet'!A1` seul.** `A1` désigne une seule cellule :
  une lecture sur cette plage renvoie **une ligne**, ce qui fait passer une écriture parfaitement
  réussie pour un écart. Utiliser une plage couvrant les dimensions attendues
  (ex. `'Opportunités'!A1:P20`), puis retirer les lignes vides de fin avant de compter.
- **Les noms de paramètres diffèrent d'un outil à l'autre.** Sur le même workspace : `spreadsheet_id`
  pour `VALUES_UPDATE` / `ADD_SHEET` / `GET_SHEET_NAMES`, mais `spreadsheetId` pour
  `CREATE_GOOGLE_SHEET1` et `UPDATE_SHEET_PROPERTIES`, et `file_id` pour `TRASH_FILE`. Un appel qui
  échoue sur un paramètre inconnu doit faire relire le schéma, pas réessayer à l'identique.
- **La clé d'identifiant est `spreadsheetId` (camelCase) dans la réponse de création**, pas
  `spreadsheet_id`. Lecture défensive : chercher l'ID dans `data`, et à défaut l'extraire de
  `spreadsheetUrl`.
- **Ne jamais annoncer un rapport enregistré sans l'avoir relu depuis le Drive.** C'est la seule
  vérification qui vaut.
- **Une étude commanditée par une partie prenante n'est pas une étude neutre.** Un chiffre
  d'adoption produit par un fournisseur de cloud doit être cité avec le nom du commanditaire,
  jamais comme un fait de marché.
- **Additionner des pourcentages d'une enquête sans vérifier qu'ils sont exclusifs** produit un
  chiffre faux. Le signaler dans « À vérifier ».
- **L'actualité n'est pas l'opportunité.** Une annonce produit n'ouvre une opportunité que si l'on
  peut nommer le problème métier et la disposition à payer. Sans les deux, c'est une brève.
- **Ne pas confondre volontaire et obligatoire.** Un accord d'autocontrôle n'est pas une loi :
  présenter l'un comme l'autre est une faute qui se paie en crédibilité.
- **Sujet politiquement sensible** : ne conserver que l'angle factuel ou méthode, sans commentaire
  sur les acteurs politiques.
- **Aucune veille récurrente lancée sans fréquence définie par l'utilisateur.**
- **Document de travail interne** : aucune publication, aucun contact, aucune prise de parole.

## Préférences de l'utilisateur

- Réponse en français, professionnelle et dense ; pas de remplissage.
- Il veut des **artefacts réels** (fichier déposé, URL vérifiée, sortie d'exécution), pas une
  description de ce qui serait fait.
- Il veut les **blocages dits franchement**, avec la preuve du contrôle et la procédure de déblocage.
- **Chaque rapport va dans un Google Sheet de son Drive**, convention permanente.
- Il veut pouvoir **ajouter ses propres idées** : le classeur reste modifiable (colonne `Statut`).

## Vérification

- Le classeur relu contient autant de lignes que produit, onglet par onglet.
- Chaque opportunité porte un score, un niveau de maturité et une preuve de disposition à payer.
- Chaque chiffre cité est traçable à une ligne de l'onglet Sources, avec son niveau de fiabilité.
- L'onglet Synthèse dit explicitement ce qui n'est pas démontré.
- Aucun classeur orphelin ne reste dans le Drive après une relance.
- L'URL du classeur est communiquée à l'utilisateur.
