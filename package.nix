{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchgit,
  autoPatchelfHook,

  pkg-config,
  just,
  meson,
  ninja,
  cmake,
  git,

  cef,
  python3,

  ffmpeg,
  mpv,
  libplacebo,
  libGL,
  libass,
  libxcb,
  llvmPackages,
  libgbm,

glib,
  nspr,
  nss,
  atk,
  at-spi2-atk,
  at-spi2-core,
  dbus,
  cups,
  mesa,
  expat,
  cairo,
  pango,
  systemd,
  fontconfig,
  freetype,
  pixman,
  fribidi,
  harfbuzz,
  libthai,
  avahi,
  gnutls,
  libxml2,
  bzip2,
  brotli,
  libdatrie,
  graphite2,
  xz,
  p11-kit,
  libidn2,
  libunistring,
  libtasn1,
  nettle,
  gmp,
  zlib,
  util-linux,
  libffi,
  pcre2,

  xorg,
  curl,
  libcdio,
  libdvdnav,
  libdvdread,
  mujs,
  libarchive,
  libbluray,
  lua,
  rubberband,
  SDL2,
  libuchardet,
  vapoursynth,
  libXfixes,
  zimg,
  alsa-lib,
  libjack2,
  pipewire,
  pulseaudio,
  libcaca,
  libdrm,
  libdisplay-info,
  libjpeg_turbo,
  libsixel,
  wayland,
  wayland-protocols,
  wayland-scanner,
  libxkbcommon,
  libXScrnSaver,
  libXpresent,
  libXrandr,
  libva,
  nv-codec-headers,
  autoAddDriverRunpath,
makeWrapper,
}:

rustPlatform.buildRustPackage rec {
  pname = "jellyfin-desktop";
  version = "git";

  CEF_PATH = "${cef}";
  LIBCLANG_PATH = "${lib.getLib llvmPackages.libclang}/lib";

  # During development we'll point this at a local checkout.
  src = fetchgit {
      url = "https://github.com/andrewrabert/jellium-desktop.git";
      hash = "sha256-FOz4mxsKminTtWul6BXRI0V0uBqXUeSEGziQTjxnHYs=";
      fetchSubmodules = true;
    };

  # Dummy hash for now. Nix will tell us the correct one.
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
    just
    meson
    ninja
    cmake
    git
    python3
    llvmPackages.clang
    autoPatchelfHook
  makeWrapper
    wayland
    wayland-scanner
    wayland-protocols

  ];

  buildInputs = [
  cef
      ffmpeg
      mpv
      libplacebo
      libGL
      libass
      libxcb
      alsa-lib

      # CEF dependencies
      glib
      nspr
      nss

      atk
      at-spi2-atk
      at-spi2-core

      dbus
      cups

      xorg.libX11
      xorg.libXcomposite
      xorg.libXdamage
      xorg.libXext
      xorg.libXfixes
      xorg.libXrandr
      xorg.libxcb
      xorg.libXau
      xorg.libXrender
      xorg.libXi

      expat
      cairo
      pango
      fontconfig
      freetype
      harfbuzz
      systemd   # provides libudev
curl
  libcdio
  libdvdnav
  libdvdread
  mujs
  libarchive
  libbluray
  lua
  rubberband
  SDL2
  libuchardet
  vapoursynth
  xorg.libXfixes
  zimg
  libjack2
  pipewire
  pulseaudio
  libcaca
  libdrm
  libdisplay-info
  libjpeg_turbo
  libsixel
  wayland
  wayland-scanner
  wayland-protocols
  libxkbcommon
  xorg.libXScrnSaver
  xorg.libXpresent
  libva
  nv-codec-headers
  libgbm
  ];

meta = {
  description = "An unofficial desktop client for Jellyfin";
  homepage = "https://github.com/andrewrabert/jellium-desktop";
  license = lib.licenses.gpl2Only;
  platforms = lib.platforms.linux;
  mainProgram = "jellium-desktop";
};
}
