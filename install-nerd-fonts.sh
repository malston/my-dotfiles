#!/usr/bin/env bash

declare -a fonts=(
    3270
    Agave
    AnonymousPro
    Arimo
    AurulentSansMono
    BigBlueTerminal
    BitstreamVeraSansMono
    CascadiaCode
    CodeNewRoman
    ComicShannsMono
    Cousine
    DaddyTimeMono
    DejaVuSansMono
    DroidSansMono
    FantasqueSansMono
    FiraCode
    FiraMono
    FontPatcher
    Go-Mono
    Gohu
    Hack
    Hasklig
    HeavyData
    Hermit
    iA-Writer
    IBMPlexMono
    Inconsolata
    InconsolataGo
    InconsolataLGC
    Iosevka
    IosevkaTerm
    JetBrainsMono
    Lekton
    LiberationMono
    Lilex
    Meslo
    Monofur
    Monoid
    Mononoki
    MPlus
    NerdFontsSymbolsOnly
    Noto
    OpenDyslexic
    Overpass
    ProFont
    ProggyClean
    RobotoMono
    ShareTechMono
    SourceCodePro
    SpaceMono
    Terminus
    Tinos
    Ubuntu
    UbuntuMono
    VictorMono)

version="3.0.2"

fonts_dir="${HOME}/.local/share/fonts"
mkdir -p "$fonts_dir"

for font in "${fonts[@]}"; do
  zip_file="${font}.zip"
  download_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v${version}/${zip_file}"
  echo "[-] Downloading ${font} [-]"
  wget "$download_url"
  unzip -o "$zip_file" -d "$fonts_dir"
  rm "$zip_file"
done

find "$fonts_dir" -name '*Windows Compatible*' -delete
fc-cache -fv
