# Skills tiers : à vérifier avant toute diffusion

Ces skills ne sont pas écrits par Celdel AI. Les rediffuser publiquement peut poser un problème de licence : à trancher avant publication.

| Skill | Origine |
|---|---|
| `afrexai-social-media-engine` | skill publié sur un registre, `_meta.json` : owner `kn76xhdy26wp3h8djks2hnskj18130kg`, v1.0.0 |
| `last30days` | embarque une bibliothèque tierce vendorisée (`scripts/lib/vendor/bird-search`) |

## Ce qui a été vérifié

- **Aucun credential** : scan de motifs (`sk-`, `ntn_`, `ghp_`, `GOCSPX-`, `AKIA`, `AIza`, clés privées PEM) → aucun résultat réel.
- **Aucune affectation de clé littérale** dans le code.
- **Aucune donnée client** identifiée.
