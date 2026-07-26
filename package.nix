{
  # Nix/Rust packaging helpers
  lib,
  rustPlatform,
  fetchgit,
  autoPatchelfHook,
  makeWrapper,

  # Bundled Chromium/CEF runtime
  cef,

  # Build tools and generators
  git,
  just,
  meson,
  ninja,
  cmake,
  python3,
  pkg-config,
  llvmPackages,

  # Core media playback and codecs
  mpv,
  ffmpeg,
  libass,
  libplacebo,

  # OpenGL/GBM and display infrastructure
  libGL,
  libgbm,
  libdrm,
  libdisplay-info,

  # X11 support
  libx11,
  libxcb,
  libxext,
  libxrandr,
  libxfixes,
  libxpresent,
  libxscrnsaver,

  # Wayland support
  wayland,
  libxkbcommon,
  wayland-scanner,
  wayland-protocols,

  # Hardware video acceleration
  libva,
  vulkan-loader,
  vulkan-headers,
  nv-codec-headers,
  nv-codec-headers-12,

  # Network and disc media support
  curl,
  libcdio,
  libbluray,
  libdvdnav,
  libdvdread,

  # Archive and scripting support
  lua,
  mujs,
  libarchive,

  # Audio processing and output
  SDL2,
  alsa-lib,
  libjack2,
  pipewire,
  rubberband,
  pulseaudio,
  libcdio-paranoia,

  # Image, terminal graphics, and visual output
  lcms2,
  libcaca,
  libsixel,
  libjpeg_turbo,

  # Subtitle/text encoding and video filters
  zimg,
  vapoursynth,
  libuchardet,
}:

rustPlatform.buildRustPackage {
  pname = "jellium-desktop";
  version = "unstable-2026-07-23";

  CEF_PATH = "${cef}";
  LIBCLANG_PATH = "${lib.getLib llvmPackages.libclang}/lib";

  src = fetchgit {
    url = "https://github.com/andrewrabert/jellium-desktop.git";
    rev = "f3ba9cdcf29173d21c2384b981ba1f496a408980";
    hash = "sha256-FOz4mxsKminTtWul6BXRI0V0uBqXUeSEGziQTjxnHYs=";
    fetchSubmodules = true;
  };

  cargoRoot = "src";
  cargoHash = "sha256-b71LONOnoYDq/e60foYA9H2waRJuhORKNxz5GXsplr8=";

  patchPhase = ''
    patchShebangs third_party/mpv
  '';

  buildPhase = ''
    runHook preBuild
        cargo run \
        --release \
        --manifest-path src/xtask/Cargo.toml \
        -- build --cef-path ${cef}
        runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    appDir="$out/lib/jellium-desktop"
    mkdir -p "$appDir" "$out/bin"

    install -Dm755 build/libmpv.so.2 "$appDir/libmpv.so.2"
    install -Dm755 build/jellium-desktop "$appDir/jellium-desktop"
    install -Dm644 resources/linux/net.nullsum.JelliumDesktop.desktop \
                    "$out/share/applications/net.nullsum.JelliumDesktop.desktop"
    install -Dm644 resources/linux/net.nullsum.JelliumDesktop.metainfo.xml \
                    "$out/share/metainfo/net.nullsum.JelliumDesktop.metainfo.xml"
    install -Dm644 resources/linux/net.nullsum.JelliumDesktop.svg \
                    "$out/share/icons/hicolor/scalable/apps/net.nullsum.JelliumDesktop.svg"

    makeWrapper                                 \
      "$appDir/jellium-desktop"                 \
      "$out/bin/jellium-desktop"                \
      --set CEF_PATH "${cef}"                   \
      --prefix LD_LIBRARY_PATH : "$appDir:${cef}"

    runHook postInstall
  '';

  doCheck = false;
  autoPatchelfIgnoreMissingDeps = [
    "libcef.so"
  ];

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    cmake
    python3
    llvmPackages.clang
    autoPatchelfHook
    makeWrapper
    wayland-scanner
  ];

  buildInputs = [
    alsa-lib
    cef
    curl
    ffmpeg
    lcms2
    libGL
    libarchive
    libass
    libcdio
    libcdio-paranoia
    libdisplay-info
    libdrm
    libgbm
    libjpeg_turbo
    libplacebo
    libuchardet
    libva
    libx11
    libxcb
    libxext
    libxfixes
    libxkbcommon
    libxpresent
    libxrandr
    libxscrnsaver
    lua
    mujs
    nv-codec-headers-12
    pipewire
    pulseaudio
    rubberband
    vulkan-headers
    vulkan-loader
    wayland
    wayland-protocols
    zimg
  ];

  meta = {
    description = "An unofficial desktop client for Jellyfin";
    homepage = "https://github.com/andrewrabert/jellium-desktop";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    mainProgram = "jellium-desktop";
  };
}
