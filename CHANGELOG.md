# Omarchy Packages Personal Fork Changelog

This document tracks all package maintenance, PKGBUILD recipes, and build pipeline updates applied to the **`robert-flo/omarchy-pkgs`** repository.

This repository powers the packaging infrastructure that builds, signs, and publishes personal Arch Linux packages to the **`omarchy-personal-repo`** package repository.

---

## [2026-09-29]

### `5a49a3f` — Workspace Integration & Upstream Synchronization

- **Commit Hash:** [`5a49a3fab56c2dea5190c8a1cfe42a38555bec48`](https://github.com/robert-flo/omarchy-pkgs/commit/5a49a3fab56c2dea5190c8a1cfe42a38555bec48)
- **Branch:** `master`
- **Upstream Base:** `omacom/omarchy-pkgs`

#### What was changed:
1. **Workspace Setup:**
   - Cloned and established the packaging workspace under [`pj-omarchy-fork/robert-flo_omarchy-pkgs`](https://github.com/robert-flo/omarchy-pkgs) as part of the centralized multi-repository fork structure.
2. **Upstream Alignment:**
   - Synchronized with upstream master up to commit `5a49a3f` (*"Keep Hermes Desktop opening on its runtime after Hermes updates (#718)"*), including the latest package definitions for `t3code-bin`, `strata`, and core tools.
3. **Pipeline Coupling:**
   - Connected with the newly deployed [`omarchy-personal-repo`](https://github.com/robert-flo/omarchy-personal-repo) distribution target, ensuring the PKGBUILD build automation and release workflows have a live GitHub Pages host to publish to.

#### Why it was done (Rationale):
- **Ecosystem Cohesion:** The fork architecture relies on three coordinated components:
  - [`robert-flo/omarchy`](https://github.com/robert-flo/omarchy) (source code and configurations),
  - [`robert-flo/omarchy-pkgs`](https://github.com/robert-flo/omarchy-pkgs) (PKGBUILD recipes and build pipelines),
  - [`robert-flo/omarchy-personal-repo`](https://github.com/robert-flo/omarchy-personal-repo) (pacman binary distribution).
- **Build Readiness:** Keeping `omarchy-pkgs` up to date ensures all build scripts and GitHub Actions runners (`build-pr.yml`, `publish.yml`) operate against the latest upstream Arch dependencies while producing packages compatible with the `[omarchy-personal]` repository.
