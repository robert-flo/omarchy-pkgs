# Excepción al fleet ADR 0024 (`omarchy-pkgs`)

`robert-flo/omarchy-pkgs` **no** adopta el modelo completo del
[fleet ADR 0024](https://github.com/robert-flo/fleet/blob/main/docs/adr/0024-personal-y-upstream-en-cada-fork.md)
(default `personal` + rama espejo `upstream` de `omacom/omarchy-pkgs:master` +
rebase nightly con `robert-flo/fleet/.github/workflows/sync-personal-fork.yml`).

## Por qué

- `personal` es una rama **curada**: pin lockstep del par `omarchy` /
  `omarchy-settings` (`"personal": true`, `pkgrel` §5.3) y recetas propias.
  No es un overlay que deba trackear `master` de omacom.
- Frente a `omacom/omarchy-pkgs:master` (2026-10-05): `personal` está
  **40 adelante / 87 atrás**. Un rebase de prueba de `personal` sobre esa
  punta **choca** en el primer commit personal (`b7cd534`) en
  `pkgbuilds/omarchy/PKGBUILD`, `pkgbuilds/omarchy-settings/PKGBUILD`,
  `.github/workflows/test.yml` y modify/delete de `sync-aur.yml`.
- Un `push --force-with-lease` nightly de `personal` competiría con
  `release-personal.yml`, que commitea el pin y publica el repo pacman
  (`omarchy-personal-repo`). Romper ese flujo no es aceptable.
- `publish.yml` dispara en push a `master` con environment `publish`
  restringido a `master`. Rebasear `personal` sobre recetas oficiales no es
  el camino de publicación personal; `builder-images.yml` refresh está
  guardado a `omacom/omarchy-pkgs`.

## Qué usa en su lugar

- Default de GitHub: **`master`** (copia de registro de `release-personal.yml`
  y `sync-check.yml` para `schedule` / `workflow_dispatch`).
- Pin real: rama **`personal`** (PRs a `personal`; el pin se commitea ahí).
- Cadencia: `sync-check.yml` compara el pin con **tags de `omacom/omarchy`**,
  no con commits de `omacom/omarchy-pkgs`.
- Fast-forward del espejo `upstream` y rebase de `personal`: en
  **`robert-flo/omarchy`** (línea `omacom/omarchy:quattro`), disparados desde
  `release-personal.yml`.
- Crons oficiales de recetas (`track-branches.yml`, `sync-upstream.yml`,
  `sync-rebuilds.yml`) inertes a propósito (`workflow_dispatch` only).
- No hay caller `sync-personal-fork.yml` en este repo.

La enmienda canónica del ADR 0024 vive en `robert-flo/fleet` (Decision §11).
Este archivo deja la misma excepción junto a la fábrica.
