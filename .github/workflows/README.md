# GitHub Actions Workflows

## Active Workflows

### godot-build.yml
**Status:** ✅ Active

Builds VRig for multiple platforms using Godot 4.5-stable:
- Linux (x86_64)
- Windows (x86_64)
- macOS (Universal)

**Triggers:**
- Push to `copilot/translate-unity-to-godot` or `main` branches
- Pull requests to those branches
- Manual workflow dispatch

**Docker Image:** `barichello/godot-ci:4.5`

**Artifacts:** Builds are uploaded and retained for 14 days.

## Disabled Workflows (Unity - Legacy)

The following Unity-based workflows have been disabled as the project has been migrated to Godot:

- `activation.yml.disabled` - Unity license activation (legacy)
- `build.yml.disabled` - Unity multi-platform builds (legacy)
- `main.yml.disabled` - Unity build dispatcher (legacy)
- `push.yml.disabled` - Unity push builds (legacy)

These files are kept for reference but will not run.

## Migration Note

This project has been fully migrated from Unity to Godot 4.5-stable. All active CI/CD now uses Godot engine and the GDMP addon for MediaPipe integration.

## How to Use

The Godot build workflow runs automatically on pushes and pull requests. You can also trigger it manually:

1. Go to Actions tab in GitHub
2. Select "Build VRig Godot" workflow
3. Click "Run workflow"
4. Download build artifacts after completion (14-day retention)
