#!/usr/bin/env bash
# Contrôle si un service externe est REELLEMENT utilisable depuis ce profil Hermes.
#
# Usage : audit_connexions.sh <motif>
#   audit_connexions.sh google     # Drive, Sheets, Docs, Gmail (OAuth du skill google-workspace)
#   audit_connexions.sh composio   # plateforme de connecteurs tierce (voie MCP)
#   audit_connexions.sh notion     # tout service relie via MCP
#
# A lancer AVANT de promettre une ecriture dans un service distant (Sheet, Doc, base).
# Un service que l'utilisateur croit connecte n'est connecte que si une etape ci-dessous le prouve.

set -u

MOTIF="${1:-}"
if [ -z "$MOTIF" ]; then
  echo "usage: $0 <motif, ex: google|composio|notion|airtable>" >&2
  exit 2
fi

export HERMES_HOME="${HERMES_HOME:-$HOME/.hermes}"
MOTIF_UC="$(printf '%s' "$MOTIF" | tr '[:lower:]' '[:upper:]')"

echo "=== Audit de connexion : $MOTIF ==="
echo "Profil actif (HERMES_HOME) : $HERMES_HOME"
echo
echo "-- 1/5 Jeton OAuth du service (skill google-workspace) --"
SETUP="$HERMES_HOME/skills/productivity/google-workspace/scripts/setup.py"
if [ -f "$SETUP" ]; then
  python "$SETUP" --check 2>&1 | tail -3
else
  echo "setup.py introuvable -> service non configure par cette voie"
fi
echo
echo "-- 2/5 Cles *${MOTIF_UC}* dans les fichiers .env --"
FOUND_ENV=0
for f in "$HERMES_HOME/.env" "$HOME/.hermes/.env"; do
  [ -f "$f" ] || continue
  HITS="$(grep -oiE "^[A-Z0-9_]*${MOTIF_UC}[A-Z0-9_]*" "$f" 2>/dev/null | sort -u)"
  if [ -n "$HITS" ]; then
    echo "$f : $HITS"
    FOUND_ENV=1
  else
    echo "$f : aucune cle correspondante"
  fi
done
echo
echo "-- 3/5 Serveurs MCP declares --"
if command -v hermes >/dev/null 2>&1; then
  timeout 60 hermes mcp list 2>&1 | head -20
else
  echo "CLI hermes introuvable dans le PATH"
fi
echo
echo "-- 4/5 Catalogue MCP approuve --"
if command -v hermes >/dev/null 2>&1; then
  timeout 90 hermes mcp catalog 2>&1 | grep -iE "${MOTIF}" || echo "aucune entree correspondant a '$MOTIF' dans le catalogue"
fi
echo
echo "-- 5/5 Outils differees (a faire cote agent) --"
echo "    tool_search(['$MOTIF <action> <objet>']) puis lire available_sources :"
echo "    seuls les services qui y apparaissent sont REELLEMENT branches."
echo
echo "=== Conclusion a etablir AVANT toute promesse d'ecriture distante ==="
if [ "$FOUND_ENV" -eq 1 ]; then
  echo "Indice trouve dans les .env : verifier l'etapes 3/4 avant de conclure."
else
  echo "Aucune cle '$MOTIF_UC' trouvee : le service n'est probablement PAS branche sur ce profil."
fi
echo "Si non joignable : livrer l'artefact local + les commandes 'hermes mcp add' / setup OAuth."
echo "Ne jamais annoncer une ecriture distante non verifiee."
