{ super
, fetchurl
, lib
, pkgs
, stdenv
}:
stdenv.mkDerivation rec {
  pname = "plymouth-themes";
  version = "0.0.0";

  src = builtins.fetchGit {
    url = "https://github.com/adi1090x/plymouth-themes";
    rev = "bf2f570bee8e84c5c20caac353cbe1d811a4745f";
  };

  buildInputs = [
    pkgs.git
  ];

  configurePhase = ''
    mkdir -p $out/share/plymouth/themes/
  '';

  buildPhase = ''
  '';

  installPhase = ''
    cp -r pack_1/* $out/share/plymouth/themes/
    for i in `ls pack_1`
    do
      cat pack_1/$i/$i.plymouth | sed  "s@\/usr\/@$out\/@" > $out/share/plymouth/themes/$i/$i.plymouth
    done
    cp -r pack_2/* $out/share/plymouth/themes/
    for i in `ls pack_2`
    do
      cat pack_2/$i/$i.plymouth | sed  "s@\/usr\/@$out\/@" > $out/share/plymouth/themes/$i/$i.plymouth
    done
    cp -r pack_3/* $out/share/plymouth/themes/
    for i in `ls pack_3`
    do
      cat pack_3/$i/$i.plymouth | sed  "s@\/usr\/@$out\/@" > $out/share/plymouth/themes/$i/$i.plymouth
    done
    cp -r pack_4/* $out/share/plymouth/themes/
    for i in `ls pack_4`
    do
      cat pack_4/$i/$i.plymouth | sed  "s@\/usr\/@$out\/@" > $out/share/plymouth/themes/$i/$i.plymouth
    done
  '';

  meta = with lib ; {
    description = "A collection of Plymouth boot animations ported from Android boot animations";
    homepage = "https://github.com/adi1090x/plymouth-themes";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
