{
  alsa-lib,
  autoPatchelfHook,
  cef,
  cmake,
  curl,
  fetchgit,
  ffmpeg,
  lcms2,
  lib,
  libGL,
  libarchive,
  libass,
  libcdio,
  libcdio-paranoia,
  libdisplay-info,
  libdrm,
  libgbm,
  libjpeg_turbo,
  libplacebo,
  libuchardet,
  libva,
  libx11,
  libxcb,
  libxext,
  libxfixes,
  libxkbcommon,
  libxpresent,
  libxrandr,
  libxscrnsaver,
  llvmPackages,
  lua,
  makeWrapper,
  meson,
  mujs,
  ninja,
  nv-codec-headers-12,
  pipewire,
  pkg-config,
  pulseaudio,
  python3,
  rubberband,
  rustPlatform,
  vulkan-headers,
  vulkan-loader,
  wayland,
  wayland-protocols,
  wayland-scanner,
  zimg,
}:

rustPlatform.buildRustPackage {
  pname = "jellium-desktop";
  version = "git";

  CEF_PATH = "${cef}";
  LIBCLANG_PATH = "${lib.getLib llvmPackages.libclang}/lib";

  src = fetchgit {
    url = "https://github.com/andrewrabert/jellium-desktop.git";
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

    install -Dm755 \
      build/jellium-desktop \
      "$appDir/jellium-desktop"

    install -Dm755 \
      build/libmpv.so.2 \
      "$appDir/libmpv.so.2"

    makeWrapper \
      "$appDir/jellium-desktop" \
      "$out/bin/jellium-desktop" \
      --set CEF_PATH "${cef}" \
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
