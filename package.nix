{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchgit,

  pkg-config,
  just,
  meson,
  ninja,
  cmake,
  git,

  cef,

  ffmpeg,
  mpv,
  libplacebo,
  libGL,
  libxkbcommon,
  wayland,
  pipewire,
  alsa-lib
}:

rustPlatform.buildRustPackage rec {
  pname = "jellyfin-desktop";
  version = "git";

  CEF_PATH = "${cef}";

  # During development we'll point this at a local checkout.
  src = fetchgit {
      url = "https://github.com/andrewrabert/jellium-desktop.git";
      hash = "sha256-FOz4mxsKminTtWul6BXRI0V0uBqXUeSEGziQTjxnHYs=";
      fetchSubmodules = true;
    };

  # Dummy hash for now. Nix will tell us the correct one.
  cargoRoot = "src";
  cargoHash = "sha256-b71LONOnoYDq/e60foYA9H2waRJuhORKNxz5GXsplr8=";

  buildPhase = ''
      cargo run \
      --release \
      --manifest-path src/xtask/Cargo.toml \
      -- build --cef-path ${cef}
  '';

  doCheck = false;

  nativeBuildInputs = [
    pkg-config
    just
    meson
    ninja
    cmake
  ];

  buildInputs = [
      ffmpeg
      mpv
      libplacebo
      libGL
      libxkbcommon
      wayland
      pipewire
      alsa-lib
  ];

  meta = with lib; {
    description = "Desktop client for Jellyfin";
    homepage = "https://github.com/jellyfin/jellyfin-desktop";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    mainProgram = "jellyfin-desktop";
  };
}
