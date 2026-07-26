{
  # Nix packaging and archive extraction
  stdenv,
  fetchurl,
  autoPatchelfHook,

  # Core GLib, browser security, and IPC runtime
  nss,
  glib,
  nspr,
  dbus,
  systemd,

  # GTK accessibility support
  atk,
  at-spi2-atk,
  at-spi2-core,

  # Printing and audio support
  cups,
  alsa-lib,

  # Graphics, text rendering, and OpenGL
  mesa,
  pango,
  libxkbcommon,

  # X11 support
  libxi,
  libxext,
  libxfixes,
  libxrandr,
  libxdamage,
  libxcomposite,
}:

stdenv.mkDerivation rec {
  pname = "cef";
  platform = "linux64";
  version = "150.0.10+g8042e43+chromium-150.0.7871.101";

  src = fetchurl {
    url = "https://cef-builds.spotifycdn.com/cef_binary_${version}_${platform}_minimal.tar.bz2";
    hash = "sha256-bB1Ike84huPM9l0JKI2DBOP343JKR8kyk+K9Y+dlKOQ=";
  };

  nativeBuildInputs = [
    # Modify ELFs to point to Nix Store
    autoPatchelfHook
  ];

  buildInputs = [
    # Core GLib, browser security, and IPC runtime
    nss
    glib
    nspr
    dbus
    systemd

    # GTK accessibility support
    atk
    at-spi2-atk
    at-spi2-core

    # Printing and audio support
    cups
    alsa-lib

    # Graphics, text rendering, and OpenGL
    mesa
    pango
    libxkbcommon

    # X11 support
    libxi
    libxext
    libxfixes
    libxrandr
    libxdamage
    libxcomposite
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"
    cp -r include "$out"
    cp -r Release/* "$out"
    cp -r Resources/* "$out"

    runHook postInstall
  '';

}
