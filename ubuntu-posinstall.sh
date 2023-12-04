#!/bin/bash
# ----------------------------- VARIAVEIS ----------------------------- #
PPA_LUTRIS="ppa:lutris-team/lutris"
PPA_GRAPHICS_DRIVERS="ppa:graphics-drivers/ppa"
PPA_OBS="ppa:obsproject/obs-studio"
PPA_POPSICLE="ppa:system76/pop"

URL_WINE_KEY="https://dl.winehq.org/wine-builds/winehq.key"
URL_PPA_WINE="https://dl.winehq.org/wine-builds/ubuntu/"
URL_VIRTUALBOX="https://download.virtualbox.org/virtualbox/7.0.12/virtualbox-7.0_7.0.12-159484~Ubuntu~jammy_amd64.deb"
URL_GOOGLE_CHROME="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
URL_PROTONVPN="https://repo.protonvpn.com/debian/dists/stable/main/binary-all/protonvpn-stable-release_1.0.3-2_all.deb"
URL_ANYDESK="https://anydesk.com/en/downloads/thank-you?dv=deb_64"
URL_LIGHTWORKS="https://25893642.fs1.hubspotusercontent-eu1.net/hubfs/25893642/Lightworks%20Latest%20Version/lightworks_linux_deb.deb"
URL_JAVA8="https://javadl.oracle.com/webapps/download/AutoDL?BundleId=249192_b291ca3e0c8548b5a51d5a5f50063037"
URL_JDK="https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.1%2B12/OpenJDK21U-jdk_x64_linux_hotspot_21.0.1_12.tar.gz"


DIRETORIO_DOWNLOADS="$HOME/Downloads/"

PROGRAMAS_PARA_INSTALAR=(
  snapd  
  virtualbox
  flameshot
  steam-installer
  steam-devices
  steam:i386
  lutris
  libvulkan1
  libvulkan1:i386
  vlc
  obs-studio
  popsicle-gtk
  qbittorrent

)
# ---------------------------------------------------------------------- #

# ----------------------------- REQUISITOS ----------------------------- #
## Removendo travas eventuais do apt ##
sudo rm /var/lib/dpkg/lock-frontend
sudo rm /var/cache/apt/archives/lock

## Adicionando/Confirmando arquitetura de 32 bits ##
sudo dpkg --add-architecture i386

## Atualizando o repositório ##
sudo apt update -y

## Adicionando repositórios de terceiros e suporte a Snap (Driver Logitech, Lutris e Drivers Nvidia)##
sudo apt-add-repository "$PPA_LIBRATBAG" -y
sudo add-apt-repository "$PPA_LUTRIS" -y
sudo apt-add-repository "$PPA_GRAPHICS_DRIVERS" -y
sudo add-apt-repository "$PPA_OBS" -y

wget -nc "$URL_WINE_KEY"
sudo apt-key add winehq.key
sudo apt-add-repository "deb $URL_PPA_WINE bionic main"
echo "c68a0b8dad58ab75080eed7cb989e5634fc88fca051703139c025352a6ee19ad  protonvpn-stable-release_1.0.3-2_all.deb" | sha256sum --check -

# ---------------------------------------------------------------------- #

# ----------------------------- EXECUCAO ----------------------------- #
## Atualizando o repositório depois da adição de novos repositórios ##
sudo apt update -y

## Download e instalaçao de programas externos ##
mkdir "$DIRETORIO_DOWNLOADS"
wget -c "$URL_VIRTUALBOX"           -p "$DIRETORIO_DOWNLOADS"
wget -c "$URL_GOOGLE_CHROME"        -p "$DIRETORIO_DOWNLOADS"
wget -c "$URL_GOOGLE_CHROME"        -p "$DIRETORIO_DOWNLOADS"
wget -c "$URL_WINE_KEY"             -p "$DIRETORIO_DOWNLOADS"
wget -c "$URL_PPA_WINE"             -p "$DIRETORIO_DOWNLOADS"
wget -c "$URL_VIRTUALBOX"           -p "$DIRETORIO_DOWNLOADS"
wget -c "$URL_GOOGLE_CHROME"        -p "$DIRETORIO_DOWNLOADS"
wget -c "$URL_PROTONVPN"            -p "$DIRETORIO_DOWNLOADS"
wget -c "$URL_ANYDESK"              -p "$DIRETORIO_DOWNLOADS"
wget -c "$URL_LIGHTWORKS"           -p "$DIRETORIO_DOWNLOADS"
wget -c "$URL_JAVA8"                -p "$DIRETORIO_DOWNLOADS"
wget -c "$URL_JDK"                  -p "$DIRETORIO_DOWNLOADS"

## Instalando pacotes .deb baixados na sessão anterior ##
sudo dpkg -i $DIRETORIO_DOWNLOADS/*.deb
apt -f install
# Instalar programas no apt
for nome_do_programa in ${PROGRAMAS_PARA_INSTALAR[@]}; do
  if ! dpkg -l | grep -q $nome_do_programa; then # Só instala se já não estiver instalado
    apt install "$nome_do_programa" -y
  else
    echo "[INSTALADO] - $nome_do_programa"
  fi
done

sudo apt install --install-recommends winehq-stable wine-stable wine-stable-i386 wine-stable-amd64 -y

## Instalando pacotes Snap ##
sudo snap install discord
sudo snap install spotify
sudo snap install notion-snap-reborn
sudo snap install winrar
sudo snap install code --classic
sudo snap install teams-for-linux
sudo snap install nvim --classic
sudo snap install bitwarden

# Git clone de repositórios

sudo git clone https://github.com/LilithRainbows/HabboAirForLinux.git /home/deborah

# Instalação do Java e JDK

sudo cd /usr/java/ && tar zxvf jre-8u73-linux-x64.tar.gz
cd /home/deborah/Downloads
sudo tar -xvf OpenJDK21U-jdk_x64_linux_hotspot_21.0.1_12.tar.gz
sudo mv jdk-21.0.1+12 /opt
sudo update-alternatives --install /usr/bin/java java /opt/jdk-21.0.1+12/bin/java /500
sudo update-alternatives --config java
java --version


# ---------------------------------------------------------------------- #

# ----------------------------- POS INSTALACAO ----------------------------- #
## Finalização, atualização e limpeza##
sudo apt update && sudo apt dist-upgrade -y
flatpak update
sudo apt autoclean
sudo apt autoremove -y
# ---------------------------------------------------------------------- #