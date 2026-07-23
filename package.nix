{
  lib,
  rustPlatform,
  fetchFromGitHub,

  pkg-config,
  just,
  git,

  cef,

  ffmpeg,
  mpv,
  libGL,
  libxkbcommon,
  wayland,
  pipewire,
  alsa-lib,
}:

rustPlatform.buildRustPackage rec {
  pname = "jellyfin-desktop";
  version = "git";

  # During development we'll point this at a local checkout.
  src = fetchFromGitHub {
      owner = "andrewrabert";
      repo = "jellium-desktop";
      rev = "main";
      hash = "sha256-HyTO5waNIDZOXewjxaqBxFxqlop9zqToJWmQ7pVthR8=";
      fetchSubmodules = true;
    };

  # Dummy hash for now. Nix will tell us the correct one.
  cargoRoot = "src";
  cargoHash = "sha256-b71LONOnoYDq/e60foYA9H2waRJuhORKNxz5GXsplr8=";

  preBuild = ''
      export CEF_PATH=${cef}
  '';

  buildPhase = ''
      cargo build \
      --release \
      --manifest-path src/Cargo.toml
      '';

  doCheck = false;

  nativeBuildInputs = [
    pkg-config
    just
  ];

  buildInputs = [
    ffmpeg
    mpv
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
