mkdir ~/.local/bin
mkdir ~/.local/lib
echo 'export PATH=$PATH:~/.local/bin' >> ~/.bashrc

# default folder names
echo 'XDG_DESKTOP_DIR="$HOME/dsk"
XDG_DOWNLOAD_DIR="$HOME/tmp"
XDG_TEMPLATES_DIR="$HOME/"
XDG_PUBLICSHARE_DIR="$HOME/"
XDG_DOCUMENTS_DIR="$HOME/doc"
XDG_MUSIC_DIR="$HOME/aud"
XDG_PICTURES_DIR="$HOME/img"
XDG_VIDEOS_DIR="$HOME/vid"' | tee ~/.config/user-dirs.dirs
mv ~/Desktop ~/dsk; mv ~/Downloads ~/tmp; mv ~/Documents ~/doc; mv ~/Music ~/aud; mv ~/Pictures ~/img; mv ~/Videos ~/vid
mv ~/Public/* ~/dsk; mkdir ~/doc/templates; mv ~/Templates ~/doc/templates
xdg-user-dirs-update

# desktop
mkdir ~/dsk/drawer; mv ~/dsk/* ~/dsk/drawer
cp ./FjP2s8wUYAUlaUW.jpeg ~/dsk

# background. line 2 solid color, line 3 no image, line 4 black
# xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitorLVDS-1/workspace0/backdrop-cycle-enable -s "false"
# xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitorLVDS-1/workspace0/color-style -s "0"
# xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitorLVDS-1/workspace0/image-style -s "0"
# xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitorLVDS-1/workspace0/rgba1 -s "0" -s "0" -s "0" -s "1"
# this might be best to do manually. not that much work lol

# icons
xfconf-query -c xfce4-desktop -p /desktop-icons/file-icons/show-filesystem -n -s "false"
xfconf-query -c xfce4-desktop -p /desktop-icons/file-icons/show-home -n -s "false"
xfconf-query -c xfce4-desktop -p /desktop-icons/file-icons/show-removable -n -s "false"
xfconf-query -c xfce4-desktop -p /desktop-icons/file-icons/show-trash -n -s "false"
xfconf-query -c xfce4-desktop -p /desktop-icons/icon-size -s "192"


# fonts
sudo cp ./*.ttf /usr/share/fonts/truetype
fc-cache -fv
xfconf-query -c xsettings -p /Net/FontName -s "Helvetica 11"
xfconf-query -c xfwm4 -p /general/title_font -s "Helvetica 11"
xfconf-query -c xsettings -p /Net/FontName -s "Unifont Medium 12"
xfconf-query -c xsettings -p /Gtk/DecorationLayout -s ":minimize,close"


# lightdm settings
echo '[greeter]
background = #000000
theme-name = Qogir-Dark
icon-theme-name = Qogir
font-name = Helvetica 11
user-background = false' | sudo tee -a /etc/lightdm/lightdm-gtk-greeter.conf > /dev/null

# xfce4 terminal settings
echo 'FontAllowBold=FALSE
FontUseSystem=TRUE
ScrollingUnlimited=TRUE' | tee -a ~/.config/xfce4/terminal/terminalrc > /dev/null


# take off boot splash
sudo sed -i '/GRUB_CMDLINE_LINUX_DEFAULT="/s/quiet splash //' /etc/default/grub
sudo update-grub


# non-free firmware installs + wine :(
sudo apt update
sudo apt install software-properties-common
sudo apt-add-repository --component contrib
sudo apt-add-repository --component non-free

sudo dpkg --add-architecture i386
sudo mkdir -pm755 /etc/apt/keyrings
sudo wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/bullseye/winehq-bullseye.sources

sudo apt update
sudo apt install blueman firmware-iwlwifi firmware-linux git sassc
sudo modprobe -r iwlwifi; sudo modprobe iwlwifi

sudo apt install --install-recommends winehq-stable
sudo apt install winetricks


# themes
git clone git@github.com:vinceliuice/Qogir-theme.git qogir; cd qogir; chmod +x ./install.sh
sudo ./install.sh -l --tweaks square -c dark -t default -d /usr/share/themes; cd ..; rm -rf qogir
git clone git@github.com:vinceliuice/Qogir-icon-theme.git qogir-icon; cd qogir-icon; chmod +x ./install.sh
sudo ./install.sh -t default -d /usr/share/icons; cd ..; rm -rf qogir-icon
xfconf-query -c xsettings -p /Net/ThemeName -s "Qogir-dark"
xfconf-query -c xfwm4 -p /general/theme -s "Qogir-dark"
xfconf-query -c xsettings -p /Net/IconThemeName -s "Qogir-dark"


# firefox extensions -- later lol
# mkdir firefox-ext
# wget -nv --show-progress https://addons.mozilla.org/en-US/firefox/addon/ublock-origin/


# software installs
sudo apt install audacity default-jre deluge ffmpeg fuse-overlayfs gimp gpick libass-dev libxml2-utils mtp-tools obs-studio python2 python3-pip strace usbutils v4l2loopback-dkms v4l2loopback-utils vlc xclip xpad xsel
cd /usr/local/bin; curl https://getmic.ro | sudo bash; cd -
git config --global core.editor "micro"
wget -nv --show-progress -O discord.deb "https://discord.com/api/download?platform=linux&format=deb"
sudo apt install ./discord.deb; rm ./discord.deb

sudo wget -nv --show-progress -O /usr/local/bin/yt-dlp https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp_linux
echo "alias yt-dlp='yt-dlp --config-location ~/.config/yt-dlp/yt-dlp.conf'" >> ~/.bashrc
mkdir ~/vid/yt

wget -nv --show-progress -O pia.run $(curl -s https://www.privateinternetaccess.com/installer/download_installer_linux_beta | xmllint --html --format --xpath 'string(.//head//meta[@http-equiv="refresh"]//@content)' 2>/dev/null - | sed 's/0; url=//')

chmod +x pia.run; ./pia.run; rm pia.run

wget -nv --show-progress -O gimp-resynth.zip https://www.gimp-forum.net/attachment.php?aid=6867
unzip gimp-resynth.zip -d resynthesizer; mv resynthesizer/* ~/.config/GIMP/2.10/plug-ins/; rmdir resynthesizer
wget -nv --show-progress -O gimp.AppImage https://github.com/TasMania17/Gimp-Appimages-Made-From-Debs/releases/download/Gimp-Python2-AppImage-Launchers-for-Linux/gimp-python2-fuse-overlay-launcher-mx-linux21-1.AppImage
chmod +x gimp.AppImage; mv gimp.AppImage ~/.local/bin/gimp-py2
cp ./gimp.desktop ~/.local/share/applications/gimp.desktop; sed -i "s/~/\/home\/$(whoami)/" ~/.local/share/applications/gimp.desktop


wget -nv --show-progress https://cytranet.dl.sourceforge.net/project/avidemux/avidemux/2.8.1/avidemux_2.8.1.tar.gz
tar -xzf avidemux_2.8.1.tar.gz; cd avidemux_2.8.1; bash createDebFromSourceUbuntu.bash --deps-only
bash bootStrap.bash --with-system-libass; sudo cp -R install/usr/* /usr/; cd ..; rm -rf avidemux_2.8.1 avidemux_2.8.1.tar.gz

VER=$(curl --silent -qI https://github.com/13rac1/twemoji-color-font/releases/latest | awk -F '/' '/^location/ {print  substr($NF, 1, length($NF)-1)}');
wget -nv --show-progress -O twemoji.tar.gz https://github.com/13rac1/twemoji-color-font/releases/download/$VER/TwitterColorEmoji-SVGinOT-Linux-${VER#v}.tar.gz
tar -xzf twemoji.tar.gz $(tar -tzf twemoji.tar.gz | grep TwitterColorEmoji-SVGinOT.ttf); sudo mv TwitterColorEmoji-SVGinOT.ttf /usr/share/fonts/truetype
rm TwitterColorEmoji-SVGinOT-Linux-${VER#v}.tar.gz

wget -nv --show-progress -O slsk.tgz https://www.slsknet.org/SoulseekQt/Linux/SoulseekQt-2018-1-30-64bit-appimage.tgz
tar -xzf slsk.tgz $(tar -tzf slsk.tgz | grep SoulseekQt); sudo mv SoulseekQt*.AppImage ~/.local/bin/slsk; rm slsk.tgz; mkdir ~/.local/lib/slsk; cp slsk.png ~/.local/lib/slsk/slsk.png
touch slsk.desktop ~/.local/share/applications
echo "[Desktop Entry]
Version=
Name=SoulSeek
Comment=an ad-free, spyware free, just plain free file sharing network
Exec=~/.local/bin/slsk %U
Icon=~/.local/lib/slsk/slsk.png
Terminal=false
StartupWMClass=SoulSeek
Type=Application
Categories=Application;Network;Music;
Path=
StartupNotify=true" | sed "s/~/\/home\/$(whoami)/" > ~/.local/share/applications/slsk.desktop
chmod +x ~/.local/share/applications/slsk.desktop

wget -nv --show-progress -O go.tar.gz $(curl -s https://go.dev/dl/ | xmllint xmllint --html --format --xpath './/body//a[contains(@href, ".linux-amd64.tar.gz") and contains(@class, "downloadBox")]//@href' 2>/dev/null -); sudo tar -C /usr/local -xzf go.tar.gz; rm go.tar.gz

echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee -a /etc/profile; source /etc/profile
echo 'export GOPATH=$HOME/.local/lib/go' >> ~/.bashrc

# tuxguitar; yeah... im a genius
wget -O tuxguitar.deb $(curl -s $(curl -s "https://sourceforge.net"$(curl -s https://sourceforge.net/projects/tuxguitar/files/TuxGuitar/ | xmllint --html --format --xpath 'string(.//body//tbody//tr[1]//th[@headers="files_name_h"]//a//@href)' 2>/dev/null -) | xmllint --html --format --xpath 'string(.//body//a[contains(@title, "linux-x86_64.deb")]//@href)' 2>/dev/null -) | xmllint --html --format --xpath 'string(.//body//a[contains(@href, "linux-x86_64.deb")]//@href)' 2>/dev/null - | cut -f 1 -d "?")
sudo dpkg -i tuxguitar.deb; rm tuxguitar.deb
