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

### Automated 4:00 AM Cadence Pipeline & Personal DB Verification Fix

- **Resolved Issues:**
  - [#4: [CI/CD] Configurar automatización diaria a las 4:00 AM y soporte para OMARCHY_EDGE_DB_URL](https://github.com/robert-flo/omarchy-pkgs/issues/4)
- **Files Modified:**
  - `.github/workflows/release-personal.yml`
  - `.github/workflows/sync-check.yml`

#### What was changed:
1. **Edge DB Verification Fix (`release-personal.yml`):**
   - Configured `OMARCHY_EDGE_DB_URL="https://robert-flo.github.io/omarchy-personal-repo/stable/x86_64/omarchy.db.tar.zst"` in the container environment.
   - Prevents `bin/omarchy-pkgs release` from validating against the upstream official edge database (`pkgs.omarchy.org/edge`) which rejected building versions equal to or higher than published upstream releases, enforcing validation strictly against the personal repository's published floor.
2. **Automated Cadence Resolution & Alerts (`release-personal.yml`):**
   - Added `issues: write` permission and an automatic issue closure step. Upon successful package publication to GitHub Pages, any open `[Cadencia]` issues are resolved and closed automatically with release metadata.
3. **Daily 4:00 AM Scheduled Automation (`sync-check.yml`):**
   - Rescheduled daily cadence check from 06:30 UTC to 04:00 AM local time (America/El_Salvador, UTC-6 -> `0 10 * * *`).
   - Granted `actions: write` permission to allow unattended workflow dispatch.
   - When a new upstream release tag is detected (`BEHIND=true`), the workflow creates an alert issue and automatically triggers `release-personal.yml` with the target version, ensuring personal machines receive new packages with version shadowing (`pkgrel=99`) before morning updates.

### `8678506` & Live Release — Omarchy v4.0.4-99 Live Publication & GPG Key Infrastructure

- **Commit Hashes:**
  - `personal`: [`867850688a90eb2e68c7ff6a10e83381f8daf9f5`](https://github.com/robert-flo/omarchy-pkgs/commit/867850688a90eb2e68c7ff6a10e83381f8daf9f5) (Pin v4.0.4-99)
  - `omarchy-personal-repo` (`gh-pages`): [`68bbb3833d0c9b470c8ddf02865e812e3e8e4602`](https://github.com/robert-flo/omarchy-personal-repo/commit/68bbb3833d0c9b470c8ddf02865e812e3e8e4602)
- **Resolved Issues:**
  - [#3: [Cadencia] Omarchy v4.0.4 publicado; pin personal en 4.0.2](https://github.com/robert-flo/omarchy-pkgs/issues/3)
- **Published Artifacts (HTTP 200 Live on GitHub Pages):**
  - `omarchy-4.0.4-99-any.pkg.tar.zst` + `.sig`
  - `omarchy-settings-4.0.4-99-any.pkg.tar.zst` + `.sig`
  - `omarchy-personal.db` + `.sig`
  - `omarchy.db` + `.sig`

#### What was changed:
1. **Cryptographic Signing & Deploy Key Infrastructure:**
   - Generated a dedicated 4096-bit RSA signing key (`CD92AB07B1D24DC9A74EB60E76AFFCC217DB9FC4`, ID `76AFFCC217DB9FC4`) for `Omarchy Personal Repo <omarchy-personal@robert-flo.github.io>` following ADR-006.
   - Configured repository secrets `GPG_PRIVATE_KEY` and `GPG_PASSPHRASE` in `robert-flo/omarchy-pkgs`.
   - Created a dedicated ed25519 deploy key with write access on `robert-flo/omarchy-personal-repo` and configured secret `SSH_DEPLOY_KEY` in `robert-flo/omarchy-pkgs`.
   - Exported the public signing key to `keys/omarchy-personal-repo.pub.asc`.
2. **Release Execution & Package Pinning:**
   - Dispatched `release-personal.yml` for version `v4.0.4`.
   - Lockstep pinned `omarchy` and `omarchy-settings` to version `4.0.4` with shaded `pkgrel=99`.
   - Built both packages inside the Arch Linux container against the official stable dependencies.
   - Cryptographically signed packages and repository databases.
   - Deployed release artifacts to `gh-pages` branch on `robert-flo/omarchy-personal-repo`.
   - Verified live CDN delivery (HTTP 200) on `https://robert-flo.github.io/omarchy-personal-repo/stable/x86_64/`.
   - Closed cadence alert Issue #3.
3. **Workflow Variable Bind Fix:**
   - Injected `VERSION: ${{ inputs.version }}` into the environment of the automated issue closure step in `release-personal.yml` to prevent unbound variable aborts on `set -u`.

### Automated Upstream Fast-Forward & Personal Rebase Engine

- **Resolved Issues:**
  - [#5: [CI/CD] Automatizar sincronización de quattro y rebase de personal con gestión de issues](https://github.com/robert-flo/omarchy-pkgs/issues/5)
- **Files Modified:**
  - `.github/workflows/release-personal.yml`

#### What was changed:
1. **Source Repository Push Authorization:**
   - Configured `SSH_OMARCHY_SOURCE_KEY` in `robert-flo/omarchy-pkgs` paired with an authorized write deploy key on `robert-flo/omarchy`.
2. **Autonomous Fast-Forward & Rebase Pipeline:**
   - Prior to building packages, the pipeline fetches `omacom/omarchy:quattro` and tags.
   - Fast-forwards `quattro` locally and pushes to `origin/quattro`.
   - Executes `git rebase quattro` on `personal`. If clean, pushes `--force-with-lease origin personal`.
3. **Fail-Safe Conflict Shield & Alert Ticketing:**
   - If a code collision occurs during rebase, the pipeline executes `git rebase --abort`.
   - Extracts the list of conflicted files via `git diff --name-only --diff-filter=U`.
   - Automatically opens a descriptive GitHub Issue (`[Conflicto Rebase]`) detailing the conflicted files and step-by-step resolution commands, halting package publication safely.

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
