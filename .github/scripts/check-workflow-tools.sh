#!/bin/bash
# FORK (robert-flo): guard contra merges de upstream que borran herramientas
# que nuestros workflows usan (caso 9188fb91: bin/repo desaparecio y
# release-personal fallo recien en el dispatch con exit 127).
#
# Recorre .github/workflows/*.yml, extrae toda referencia a un script del
# repo (bin/<x>, build/<x>, helpers/<x>, .github/scripts/<x>, con o sin ./)
# y falla si alguno no existe en el arbol. Corre en cada PR.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
missing=0
while IFS=: read -r file line ref; do
  ref=${ref#./}
  [[ -e "$ref" ]] && continue
  echo "::error file=$file,line=$line::$file:$line referencia '$ref', que no existe en el repo"
  missing=1
done < <(
  # Comentarios (YAML o shell) y name:/description: no cuentan: solo codigo ejecutable.
  grep -nvE '^[[:space:]]*(#|-? *(name|description):)' .github/workflows/*.yml /dev/null \
    | grep -oE '^[^:]+:[0-9]+:|(^|[^[:alnum:]_./-])(\./)?(bin|build|helpers|\.github/scripts)/[[:alnum:]_-]+([.][[:alnum:]]+)?' \
    | awk '/^[^:]+:[0-9]+:$/{loc=$0; next} {sub(/^[^.bh]*/, ""); print loc $0}' | sort -u)
if (( missing )); then
  echo "FORK FAIL: hay workflows que llaman herramientas inexistentes (¿un merge de upstream las borro?)."
  exit 1
fi
echo "OK: todas las herramientas referenciadas por los workflows existen."
