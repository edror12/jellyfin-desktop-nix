{ fetchurl, stdenv, bzip2 }:

stdenv.mkDerivation {
  pname = "cef";
  version = "150.0.10";

  src = fetchurl {
    url = "https://cef-builds.spotifycdn.com/cef_binary_150.0.10+g8042e43+chromium-150.0.7871.101_linux64.tar.bz2";
    hash = "sha256-ef/DVbfGbPebAmcwitTmjwBLajs1J5VkYHV3XQKgddQ=";
  };

  nativeBuildInputs = [
    bzip2
  ];

  unpackPhase = ''
    tar xf $src
  '';

  installPhase = ''
    mkdir -p $out
    cp -r cef_binary_*/* $out/
  '';
}
