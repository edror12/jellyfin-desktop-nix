{
fetchurl,
stdenv,
bzip2,
  python3,

  ffmpeg,
  mpv,
  libplacebo,
  libGL,
  libxkbcommon,
  libass,
  libxcb,
  llvmPackages,
  wayland,
  pipewire,
  alsa-lib,

autoPatchelfHook,
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
  libdrm,
  avahi,
  gnutls,
  libxml2,
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
libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxrandr,
  libxi,


  xorg,
}:

stdenv.mkDerivation {
  pname = "cef";
  version = "150.0.10";

  src = fetchurl {
    url = "https://cef-builds.spotifycdn.com/cef_binary_150.0.10+g8042e43+chromium-150.0.7871.101_linux64.tar.bz2";
    hash = "sha256-ef/DVbfGbPebAmcwitTmjwBLajs1J5VkYHV3XQKgddQ=";
  };

  nativeBuildInputs = [
    bzip2
    autoPatchelfHook
  ];
  buildInputs = [
  glib
  nspr
  nss
  atk
  at-spi2-atk
  at-spi2-core
  dbus
  cups
  alsa-lib
  mesa
  expat
  cairo
  pango
  libdrm
  libxkbcommon
  libxcb
  libxcomposite
  libxdamage
  libxext
  libxfixes
  libxrandr
  libxi
  systemd
];

  unpackPhase = ''
    tar xf $src
  '';

  installPhase = ''
      mkdir -p $out

      sdk=$(echo cef_binary_*)

      cp -r "$sdk/include" "$out"

      cp -r "$sdk/Release/"* "$out"

      cp -r "$sdk/Resources/"* "$out"

# archive.json is required by download-cef
      cat > "$out/archive.json" <<EOF
      {"type":"standard","name":"cef_binary_150.0.10+g8042e43+chromium-150.0.7871.101","sha1":""}
  EOF
      '';
}
