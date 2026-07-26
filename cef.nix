{
  alsa-lib,
  at-spi2-core,
  autoPatchelfHook,
  cairo,
  cups,
  dbus,
  expat,
  fetchurl,
  glib,
  libgbm,
  libx11,
  libxcb,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxkbcommon,
  libxrandr,
  nspr,
  nss,
  pango,
  stdenv,
  systemd,
}:

stdenv.mkDerivation {
  pname = "cef";
  version = "150.0.10";

  src = fetchurl {
    url = "https://cef-builds.spotifycdn.com/cef_binary_150.0.10+g8042e43+chromium-150.0.7871.101_linux64.tar.bz2";
    hash = "sha256-ef/DVbfGbPebAmcwitTmjwBLajs1J5VkYHV3XQKgddQ=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];
  buildInputs = [
    glib
    nspr
    nss
    at-spi2-core
    dbus
    cups
    alsa-lib
    expat
    cairo
    pango
    libgbm
    libx11
    libxkbcommon
    libxcb
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxrandr
    systemd
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
