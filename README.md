# Skills Hermès — Actualités & veille IA (Celdel AI)

Repérer et présenter les actualités utiles : productivité, outils IA, opportunités métier, signaux à surveiller.

## Contenu

| Skill | Catégorie | Origine |
|---|---|---|
| `veille-editoriale-ia` | `research` | profil `actualites-ia` |
| `veille-strategique-ia` | `research` | profil `actualites-ia` |
| `last30days` | `research` | profil `actualites-ia` |
| `social-media-content-calendar` | `creative` | profil `actualites-ia` |
| `afrexai-social-media-engine` | `social-media` | profil `actualites-ia` |

La fiche de profil est dans `profil/SOUL.md` : c'est elle qui définit le rôle et les règles de
l'assistant. À recopier dans `<profil>/SOUL.md` sur une nouvelle installation.

## Le strict minimum

1. les skills de veille ci-dessous
2. pour les sources qui exigent un accès : une session navigateur connectée, ou l'application correspondante reliée dans Composio

## Installation

```bash
./install.sh <nom_du_profil>        # ex. ./install.sh actualites-ia
```

Le script copie chaque skill dans la bonne catégorie du profil (d'après `MANIFEST.tsv`).
Pour le manuel :

```bash
cp -r skills/<skill> ~/.hermes/profiles/<profil>/skills/<catégorie>/
```

Puis redémarrer Hermès ou lancer `/reload-skills`.


## Mise à jour

Les skills se modifient dans le profil (`~/.hermes/profiles/<profil>/skills/`), puis se copient
ici. Un dépôt = un profil : ne pas mélanger les domaines.
