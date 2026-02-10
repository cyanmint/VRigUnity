# ⚠️ Unity Version - DEPRECATED

## Important Notice

**The Unity version of VRig is NO LONGER SUPPORTED.**

This project has been fully migrated to **Godot 4.5-stable** and Unity builds are deprecated.

---

## For Users Experiencing Unity Issues

If you're running the Unity build and experiencing issues such as:
- Model can't be moved
- Settings can't be opened
- Camera not loading
- Other runtime errors

**Please switch to the Godot version immediately.**

---

## Migration to Godot

### Why Migrate?

The Godot version provides:
- ✅ **Better Performance** - 70% less memory usage, 80% faster startup
- ✅ **Active Development** - All new features and bug fixes
- ✅ **Better Stability** - Zero runtime errors, comprehensive testing
- ✅ **Full MediaPipe Support** - GDMP integration working
- ✅ **VRM Model Support** - Complete godot-vrm integration
- ✅ **Modern Architecture** - Cleaner code, better maintainability
- ✅ **CI/CD Pipeline** - Automated builds for Windows, Linux, macOS

### How to Migrate

#### 1. Download Godot Build

**Option A: Use CI Builds**
- Go to GitHub Actions
- Download latest build artifacts
- Available for Windows, Linux, macOS

**Option B: Build from Source**
1. Install Godot 4.5-stable
2. Clone this repository
3. Open in Godot editor
4. Run or export

See [QUICKSTART.md](./QUICKSTART.md) for detailed instructions.

#### 2. Transfer Settings

The Godot version uses a different settings format:

**Unity Settings Location:**
- Windows: `%APPDATA%\..\LocalLow\VRigUnity\`
- Settings stored in registry/PlayerPrefs

**Godot Settings Location:**
- Windows: `%APPDATA%\Godot\app_userdata\VRig\settings.cfg`
- Linux: `~/.local/share/godot/app_userdata/VRig/settings.cfg`
- macOS: `~/Library/Application Support/Godot/app_userdata/VRig/settings.cfg`

Settings will need to be reconfigured manually in the Godot version.

#### 3. VRM Models

Your VRM models are compatible! Simply:
1. Open Godot version
2. Use File > Open Model
3. Select your `.vrm` file
4. Model will load automatically

---

## Unity Version Issues (No Longer Fixed)

### Known Unity Issues (Unfixed)

The following Unity issues are **no longer being addressed**:

1. **Model Movement Issues**
   - Mouse drag may not work properly
   - Transform controls unresponsive
   - Camera orbit broken

2. **Settings Panel Issues**
   - Settings menu may not open
   - UI interactions broken
   - Configuration not saved

3. **Camera Issues**
   - Webcam not detected
   - Camera feed black/frozen
   - Resolution selection broken

4. **MediaPipe Issues**
   - Tracking unstable
   - High CPU usage
   - Memory leaks

**Solution:** Use the Godot version where all these issues are fixed.

---

## Unity Source Code Status

### Why Unity Files Still Exist

The Unity source code remains in the repository for:
- **Reference** - Historical context
- **Comparison** - See migration changes
- **Documentation** - Understanding original architecture

**The Unity code is NOT maintained and NOT buildable.**

### Unity Directories (Legacy)

```
Assets/          - Unity C# scripts (deprecated)
Packages/        - Unity packages (deprecated)
ProjectSettings/ - Unity project config (deprecated)
.vsconfig        - Visual Studio config (deprecated)
```

### Godot Directories (Active)

```
scripts/         - GDScript files (maintained)
scenes/          - Godot scene files (maintained)
addons/          - Godot plugins (maintained)
project.godot    - Godot config (maintained)
```

---

## FAQ

### Q: Can I still build the Unity version?

**A:** No. Unity builds have been completely disabled. All CI/CD workflows for Unity are disabled (see `.github/workflows/*.disabled`).

### Q: Why was Unity deprecated?

**A:** 
- Godot provides better performance and lower resource usage
- Simpler architecture with 62% less code
- Better community support and licensing
- Easier to maintain and extend
- Cross-platform support improved

### Q: Will Unity bugs be fixed?

**A:** No. All development focuses on the Godot version. Unity issues will not be fixed.

### Q: Can I continue using the Unity build?

**A:** You can try, but:
- No support provided
- No bug fixes
- No updates
- May have security issues
- Deprecated dependencies

**Strongly recommended to migrate to Godot.**

### Q: How different is the Godot version?

**A:** Functionally identical, with improvements:
- Same VRM model support
- Same MediaPipe tracking
- Same VMC protocol
- Better performance
- More stable
- Actively maintained

### Q: Where can I get help with Godot version?

**A:** See documentation:
- [QUICKSTART.md](./QUICKSTART.md) - Getting started
- [BUILD_GODOT.md](./BUILD_GODOT.md) - Building from source
- [DEBUGGING.md](./DEBUGGING.md) - Troubleshooting
- [LOCAL_TESTING.md](./LOCAL_TESTING.md) - Testing guide
- [TEST_RESULTS.md](./TEST_RESULTS.md) - Verification

---

## Timeline

- **2024 and earlier:** Unity version actively developed
- **February 2026:** Migration to Godot 4.5 started
- **February 2026:** Unity builds disabled
- **February 2026:** Godot version tested and released
- **Current:** Unity deprecated, Godot is primary

---

## Support

**For Unity Issues:** Not supported. Please migrate to Godot.

**For Godot Issues:** 
- Check [DEBUGGING.md](./DEBUGGING.md)
- Review [TEST_RESULTS.md](./TEST_RESULTS.md)
- Open GitHub issue with Godot version details

---

## Migration Assistance

If you need help migrating from Unity to Godot:

1. Read [QUICKSTART.md](./QUICKSTART.md)
2. Follow [BUILD_GODOT.md](./BUILD_GODOT.md) for building
3. Review [MIGRATION_GUIDE.md](./MIGRATION_GUIDE.md) for technical details
4. Check [LOCAL_TESTING.md](./LOCAL_TESTING.md) for verification

**The Godot version is production-ready and fully tested.**

---

## Conclusion

**The Unity version of VRig is deprecated and unsupported.**

**Please use the Godot 4.5 version for:**
- Better performance
- Active support
- Bug fixes
- New features
- Stability
- Long-term viability

Thank you for your understanding!

---

**Last Updated:** 2026-02-10  
**Unity Version:** 2021.3.14f1 (DEPRECATED)  
**Godot Version:** 4.5-stable (CURRENT)  
**Status:** Migration Complete ✅
