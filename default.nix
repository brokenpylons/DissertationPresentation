let
  pkgs = import <nixpkgs> {};
  cache = pkgs.makeFontsCache {
    fontDirectories = pkgs.texlive.stix2-otf.pkgs;
  };
  config = pkgs.writeText "fonts.conf" ''
    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
    <fontconfig>
      <dir>${builtins.elemAt pkgs.texlive.stix2-otf.pkgs 0}</dir>
      <cachedir>${cache}</cachedir>
    </fontconfig>
  '';
in

with pkgs;

stdenv.mkDerivation {
  name = "presentation";
  src = ./.;

  TEXMFVAR = "/tmp/texmf";
  SOURCE_DATE_EPOCH = builtins.currentTime;
  FONTCONFIG_FILE = config;

  preBuild = ''
    mkdir -p $TEXMFVAR
  '';

  installPhase = ''
    mkdir -p $out
    cp paper.pdf $out
  '';

  buildInputs = [
    libsForQt5.okular
    pympress
    (texlive.combine {
      inherit (texlive) scheme-small latexmk beamer mdframed zref needspace outlines halloweenmath pict2e fontawesome5 beamertheme-metropolis pgfopts siunitx pgfplots;
    })
  ];
}
