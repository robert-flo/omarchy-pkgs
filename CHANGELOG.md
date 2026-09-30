# Omarchy Packages Personal Fork Changelog

This document tracks all package maintenance, PKGBUILD recipes, and build pipeline updates applied to the **`robert-flo/omarchy-pkgs`** repository.

This repository powers the packaging infrastructure that builds, signs, and publishes personal Arch Linux packages to the **`omarchy-personal-repo`** package repository.

## [2026-09-30]

### `ba7de2b` & `33a827a` — Upstream Cron Neutralization, Ephemeral Branch Cleanup & Issue Tracker Activation

- **Commit Hashes:**
  - `master`: [`ba7de2b077cfd14a2abc6cd6e076570b1d1fb88f`](https://github.com/robert-flo/omarchy-pkgs/commit/ba7de2b077cfd14a2abc6cd6e076570b1d1fb88f)
  - `personal`: [`33a827a5cffd27265380b9a366a1f12e6ac400bf`](https://github.com/robert-flo/omarchy-pkgs/commit/33a827a5cffd27265380b9a366a1f12e6ac400bf)
- **Resolved Issues:**
  - [#1: [Mantenimiento] Eliminar ramas efímeras automáticas (auto/sync-upstream, auto/sync-rebuilds)](https://github.com/robert-flo/omarchy-pkgs/issues/1)
  - [#2: [CI] Desactivar crons programados de upstream en master y personal](https://github.com/robert-flo/omarchy-pkgs/issues/2)
- **Active Alerts:**
  - [#3: [Cadencia] Omarchy v4.0.4 publicado; pin personal en 4.0.2](https://github.com/robert-flo/omarchy-pkgs/issues/3)

#### What was changed:
1. **GitHub Issues Enabled:**
   - Enabled GitHub Issues on the fork repository `robert-flo/omarchy-pkgs`. This unblocks the automated cadence monitoring workflow (`sync-check.yml`), allowing it to file and close alert tickets without failing on permission errors.
2. **Ephemeral Branch Cleanup:**
   - Removed rogue remote branches `origin/auto/sync-upstream` and `origin/auto/sync-rebuilds`, which were pushed by inherited upstream cron jobs prior to failing pull request creation due to default GitHub Actions permission barriers.
   - Cleaned local tracking references via `git fetch --prune`.
3. **Upstream Cron Neutralization (`schedule:` to manual `workflow_dispatch:`):**
   - **`master` branch:** Deactivated recurring schedules on `sync-upstream.yml` (every 6h), `sync-rebuilds.yml` (every 6h), `track-branches.yml` (every 2h), and `builder-images.yml` (daily), leaving them strictly executable on-demand via `workflow_dispatch`. Preserved `sync-check.yml` (daily 06:30 UTC cadence check) as the sole legitimate scheduled workflow.
   - **`personal` branch:** Completed neutralization on `track-branches.yml` and `builder-images.yml`, aligning both branches and preventing rogue branch generation and wasted Actions minutes.
4. **Automated Cadence Verification:**
   - Dispatched a manual test run of `sync-check.yml`. The job completed green in 11 seconds and successfully created Issue #3, notifying that upstream published `v4.0.4` while the personal pin is at `4.0.2`.

#### Why it was done (Rationale):
- **Prevent Unintended Branch Sprawl:** The personal fork is scoped strictly to compiling and publishing the personal package pair (`omarchy`, `omarchy-settings`) and explicitly marked personal packages (`"personal": true`). It does not maintain an independent Arch/AUR distribution mirror.
- **Fail-Safe Cadence Tracking:** The workflow `sync-check.yml` is the architectural early-warning sensor (§5.3) designed to prevent machines from resolving official upstream packages over personal ones during `omarchy update`. Activating issues and eliminating failing upstream crons ensures the sensor functions reliably.

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
