# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Multi-architecture Docker container image repository that builds and publishes images to GitHub Container Registry (GHCR). Forked from onedr0p/containers. All containers are rootless, Alpine/Ubuntu-based, single-process, log to stdout, and avoid s6-overlay.

## Commands

```bash
# Set up Python virtual environment (required for scripts)
task venv

# Append app labels to GitHub labels config
task append-app-labels

# Test a version detection script for an app
bash apps/<app>/ci/latest.sh <channel>

# Build a container locally (example)
docker buildx build --build-arg VERSION=<ver> --build-arg CHANNEL=<chan> --build-arg TARGETPLATFORM=linux/amd64 apps/<app>
```

## Architecture

### App Structure

Each app lives in `apps/<name>/` with:
- **Dockerfile** - Multi-stage build. Receives `VERSION`, `CHANNEL`, `TARGETPLATFORM` as build args. Uses `catatonit` as ENTRYPOINT init.
- **entrypoint.sh** - Runtime init script (config setup, permissions, exec into app).
- **metadata.yaml** - Build metadata defining channels, platforms, test config. Validated against `metadata.rules.cue` (CUE schema).
- **ci/latest.sh** (or `latest.py`) - Queries upstream for the latest version of a given channel. Called by `scripts/prepare-matrices.py` during CI.
- **ci/goss.yaml** - Container health tests (process running, ports listening, HTTP status). Run via Goss on linux/amd64 only.

### CI/CD Pipeline

GitHub Actions workflows in `.github/workflows/`:
- **release-scheduled.yaml** - Hourly cron + manual trigger. Calls `prepare-matrices.py` to detect new upstream versions, then triggers `build-images.yaml`.
- **release-on-merge.yaml** - Triggered on merge to main when app files change (excluding metadata/README). Forces rebuild.
- **build-images.yaml** - Core build workflow. Builds multi-arch images per platform in parallel, runs Goss tests on amd64, merges platform digests into a single manifest, pushes to GHCR.
- **simple-checks.yaml** - Validates metadata.yaml files against CUE schema on PRs.
- **render-readme.yaml** - Auto-generates root README.md from `scripts/templates/README.md.j2`.

### Build Matrix Generation

`scripts/prepare-matrices.py` orchestrates builds by:
1. Parsing each app's `metadata.yaml`
2. Running `ci/latest.sh <channel>` to get current upstream version
3. Checking GHCR for already-published versions
4. Skipping unchanged versions (unless force=true)
5. Generating semantic version tags (e.g., `3.0.8` -> tags `3.0.8`, `3.0`, `3`, `rolling`)
6. Outputting a JSON matrix for GitHub Actions

### Image Tagging

- Stable channel: `ghcr.io/Liana64/<app>` with tags `rolling`, `<version>`, `<major>`, `<major.minor>` (if semver enabled)
- Non-stable channel: `ghcr.io/Liana64/<app>-<channel>`

## Adding a New App

1. Create `apps/<name>/` with `Dockerfile`, `metadata.yaml`, `ci/latest.sh`, and optionally `entrypoint.sh`, `ci/goss.yaml`
2. `metadata.yaml` must conform to the CUE schema in `metadata.rules.cue`
3. `ci/latest.sh` must accept a channel name as argument and print the version to stdout
4. Run `task append-app-labels` to add GitHub labels

## Code Style

- 2-space indentation by default (YAML, JSON, etc.)
- 4-space indentation for Bash, Python, and Dockerfiles (see `.editorconfig`)
- UTF-8, LF line endings, trailing newline
