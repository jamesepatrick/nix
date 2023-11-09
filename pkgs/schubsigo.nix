{ super
, autoPatchelfHook
, fetchurl
, lib
, pkgs
, stdenv
, gtk3
}:
stdenv.mkDerivation rec {
  #buildGoPackage rec {
  pname = "schubsigo";
  version = "v1.2.0";

  #goPackagePath = "github.com/jangxx/SchubsiGo/";

  src = fetchurl {
    url = "https://github.com/jangxx/SchubsiGo/releases/download/${version}/SchubsiGo-${version}-linux-x64.tar.xz";
    sha256 = "sha256-7TMubQ6qXdItU5BKDp8Xfq+gYN6IvJ7/q3XmbY/F8IY=";
  };

  # buildInputs = [ pkgs.makeWrapper ];
  #setSourceRoot = "sourceRoot=`pwd`";

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    gtk3 #libgtk-3.so.0
  ];

  sourceRoot = ".";
  installPhase = ''
    install -m755 -D SchubsiGo $out/bin/SchubsiGo
  '';
  #makeWrapper $out/schubsigo/SchubsiGo
  # src = fetchFromGitHub {
  #   owner = "jangxx";
  #   repo = "Schubsigo";
  #   rev = "v${version}";
  #   sha256 = "sha256-JDoTnJeoiAQiMChpkFF2cTP9zUMZtYqrJavauYftPtU=";
  # };
  # These packages are needed to build wails
  # and will also need to be used when building a wails app.
  # nativeBuildInputs = [
  # pkg-config
  # makeWrapper
  # ];

  # Following packages are required when wails used as a builder.
  # propagatedBuildInputs = [
  #   pkg-config
  #   go
  #   gcc
  #   gtk3
  #   webkitgtk
  #   nodejs
  # ];
  # goDeps = ./deps.nix;


  meta = with lib ; {
    description = "An unofficial Pushover Client for Linux written in Go";
    homepage = "https://github.com/jangxx/SchubsiGo";
    changelog = "https://github.com/jangxx/SchubsiGo/releases/tag/${version}";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
