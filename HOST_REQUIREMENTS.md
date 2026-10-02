# Host requirements — Ubuntu 24.04 Scipion/Xmipp Apptainer image

These are the requirements a **host machine** must meet to run the Scipion/Xmipp
Apptainer image (built on `nvidia/cuda:12.6.3-cudnn-devel-ubuntu24.04`, i.e.
**glibc 2.39 / CUDA 12.6**).

## The golden rule (why this list exists)

`apptainer exec --nv` injects the **host's** NVIDIA driver and GLVND
(`libGLdispatch.so.0` / `libGLX.so.0`) libraries into the container at runtime.
Those host libraries are linked against the **host's** glibc, and glibc is
**backward- but not forward-compatible**. Therefore:

> **The host's glibc must be ≤ the container's glibc (2.39).**

A host *newer* than the image (e.g. a future Ubuntu release with glibc > 2.39)
re-introduces the `GLIBC_2.xx not found` crash for every OpenGL program
(ChimeraX, IMOD viewers, …). The fix is then to rebuild the image on that newer
base — never to patch it at launch. Build the image on the **newest host OS you
need to support**; it stays backward-compatible with older hosts.

## 1. NVIDIA GPU & driver

| | Requirement |
|---|---|
| Driver (recommended) | **≥ 560.35.03** — native CUDA 12.6 support |
| Driver (minimum) | **≥ 525.60.13** — works via CUDA minor-version compatibility |
| Compute capability | **≥ 5.0** (Maxwell → Blackwell; e.g. RTX 3090/4070 are fine) |

- `nvidia-smi` must run on the host; kernel module and userspace driver must match.
- Prefer a driver that **natively** supports CUDA 12.6 (≥ 560.35.03) so you don't
  depend on minor-version compatibility.

## 2. Host OS / glibc (the ceiling)

- Host **glibc ≤ 2.39** → **Ubuntu 20.04 / 22.04 / 24.04 LTS** (or equivalents:
  RHEL/Rocky/Alma 9, Debian 12).
- ⚠️ **Do not** run on glibc > 2.39 hosts (Ubuntu 24.10 / 25.04, glibc 2.40+):
  OpenGL will break. Use LTS hosts, or rebuild the image on the newer base.
- There is no practical lower OS bound — the binding constraint is the driver
  version, not the OS age.

## 3. Apptainer / Singularity runtime

- **Apptainer ≥ 1.1** (or SingularityCE ≥ 3.8) with a working **`--nv`** flag.
- **Unprivileged user namespaces** enabled for sudo-free use:
  `sysctl kernel.unprivileged_userns_clone=1` (Debian/Ubuntu), or Apptainer
  installed in setuid mode.
- `--nv` locates the driver via the host's `ldconfig`/NVIDIA install.

## 4. Architecture & kernel

- **x86-64 (amd64)** only — the CUDA base image is amd64.
- Any kernel new enough for the installed NVIDIA driver (satisfied by all
  supported LTS releases).

## 5. Display / OpenGL (ChimeraX, Scipion GUI, viewers)

- An **X11 server** with `$DISPLAY` set and `/tmp/.X11-unix` present
  (Wayland desktops need **XWayland**).
- For hardware-accelerated 3D (ChimeraX): the X server/GLX should run on the
  NVIDIA GPU (or a GPU with working GLX).
- Remote/SSH sessions need **VirtualGL** or local rendering — plain X11
  forwarding provides only indirect GLX (no modern OpenGL core profile).
- The launching user must have access to the display (same session / `xhost`).

## 6. ChimeraX (host-provided, bind-mounted — never bundled in the image)

- Install the ChimeraX build whose glibc requirement is **≤ 2.39**: the
  **Ubuntu 22.04 or 24.04** ChimeraX build both run in this container.
  (A build needing glibc > 2.39 will not run.)
- Point `CHIMERA_HOME` / `CHIMERA_LOCATION` at it in `launcher.sh`
  (see the ChimeraX block there).

## 7. Storage & filesystem

- Space for images: each `.sif` is several–15+ GB; a full multi-flavour cache can
  approach ~300 GB.
- A writable **`APPTAINER_TMPDIR`** with room for build/extract scratch.
- Bind targets must exist and be readable/writable: data dir (`→ /data`),
  projects dir, tests dir, and any external software (CryoSPARC/PHENIX/…).

## 8. Network (only if pulling images from the registry)

- Reachability to the Harbor registry (`rinchen.cnb.csic.es`) with `curl` + `jq`
  for `check_tags.sh` (guest:guest), and ORAS / `apptainer pull` access.

## Quick host self-check

```bash
nvidia-smi --query-gpu=driver_version,compute_cap --format=csv   # driver ≥ 560.35.03
ldd --version | head -1                                          # host glibc ≤ 2.39
apptainer --version                                             # ≥ 1.1
echo "$DISPLAY"; ls /tmp/.X11-unix                              # GUI available
```
