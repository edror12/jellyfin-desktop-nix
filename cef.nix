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
