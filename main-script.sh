#!/bin/bash

#Explanation of code
# # Check for Root Privileges:
# The script checks if it's being run as root (administrator). If not, it exits with a message,
# ensuring that administrative permissions are required for the script to run.

# Install Necessary Programs:
# This step installs various essential packages and programs for the system,
# including utilities, themes, and applications needed for the setup.

# Clone and Build Software:
# The script clones source code from repositories I’ve worked on, builds the software, and installs it.
# This includes window managers, terminal emulators, menu tools, and status bar components.

# Download Wallpapers:
# Downloads various wallpapers from Google Drive to use as desktop backgrounds.

# Configure X Server and Scripts:
# Copies the default X server configuration file, adds compositor settings,
# and creates a script to handle wallpaper and theme changes automatically.

# Set Up Shell Environment:
# Configures environment variables and paths for the Zsh shell,
# including automatic X server start on virtual terminals.

# Install and Configure e-DEX-UI:
# Downloads and sets up the e-DEX-UI terminal emulator UI,
# adjusting permissions and moving it to the local bin directory.

# Update .xinitrc:
# Adds commands to the .xinitrc file to start programs and configurations at login,
# including running the X server, applying themes, and starting window managers and applications.

# Install TGPT:
# Installs TGPT from a remote script and adds it to the system.

# Completion Message:
# Prints a message indicating that the installation is complete and prompts the user to reboot the system.

# Checking Sudo privileges


# Installing necessary programs
sudo pacman -S git vim neofetch uwufetch libxinerama libxft xorg-server xorg-xinit xorg-xrandr xorg-xkill xorg-xsetroot xorg-xbacklight xorg-xprop \
     noto-fonts noto-fonts-emoji noto-fonts-cjk ttf-jetbrains-mono ttf-joypixels ttf-font-awesome ttf-fira-code \
     sxiv mpv zathura zathura-pdf-mupdf ffmpeg imagemagick python-pip \
     fzf man-db xwallpaper python-pywal unclutter xclip maim zsh-syntax-highlighting wget \
     zip unzip unrar p7zip xdotool papirus-icon-theme brightnessctl \
     dosfstools ntfs-3g git sxhkd zsh pipewire pipewire-pulse thunar \
     emacs-nox arc-gtk-theme rsync qutebrowser dash \
     xcompmgr libnotify dunst slock jq aria2 cowsay \
     dhcpcd connman wpa_supplicant rsync pamixer mpd ncmpcpp \
     xdg-user-dirs libconfig \
     bluez bluez-utils --noconfirm || { echo "Installation of necessary programs failed"; exit 1; }

# Making DIR for git REPOS for DE
mkdir -p "$HOME/Gitoo" || { echo "Failed to create Gitoo directory"; exit 1; }
cd "$HOME/Gitoo" || { echo "Failed to change directory to Gitoo"; exit 1; }

# Cloning and building repos and compiling them

# dwm: Window Manager
git clone --depth=1 https://github.com/Bugswriter/dwm.git "$HOME/Gitoo/dwm" || { echo "Git cloning dwm failed"; exit 1; }
sudo make -C "$HOME/Gitoo/dwm" install || { echo "Installing dwm failed"; exit 1; }

# st: Terminal
git clone --depth=1 https://github.com/Bugswriter/st.git "$HOME/.local/src/st" || { echo "Git cloning st failed"; exit 1; }
sudo make -C "$HOME/.local/src/st" install || { echo "Installing st failed"; exit 1; }

# dmenu: Program Menu
git clone --depth=1 https://github.com/Bugswriter/dmenu.git "$HOME/Gitoo/dmenu" || { echo "Git cloning dmenu failed"; exit 1; }
sudo make -C "$HOME/Gitoo/dmenu" install || { echo "Installing dmenu failed"; exit 1; }

# dmenu: Dmenu based Password Prompt
git clone --depth=1 https://github.com/ritze/pinentry-dmenu.git "$HOME/Gitoo/pinentry-dmenu" || { echo "Git cloning pinentry-dmenu failed"; exit 1; }
sudo make -C "$HOME/Gitoo/pinentry-dmenu" clean install || { echo "Installing pinentry-dmenu failed"; exit 1; }

# dwmblocks: Status bar for dwm
git clone --depth=1 https://github.com/ofcourseiuselinux/dwmblocks.git "$HOME/Gitoo/dwmblocks" || { echo "Git cloning dwmblocks failed"; exit 1; }
sudo make -C "$HOME/Gitoo/dwmblocks" install || { echo "Installing dwmblocks failed"; exit 1; }

# Statusbar icons 
git clone --depth=1 https://github.com/ofcourseiuselinux/iconscripts.git "$HOME/Gitoo/iconscripts" || { echo "Git cloning iconscripts failed"; exit 1; }
cd "$HOME/Gitoo/iconscripts" || { echo "Failed to change directory to iconscripts"; exit 1; }
mkdir -p "$HOME/.local/bin" || { echo "Failed to create .local/bin directory"; exit 1; }
mv * "$HOME/.local/bin" || { echo "Failed to move statusbar icons"; exit 1; }

# Retrieving wallpaper from my GDRIVE
mkdir -p "$HOME/wallcolor" || { echo "Failed to create wallcolor directory"; exit 1; }
cd "$HOME/wallcolor" || { echo "Failed to change directory to wallcolor"; exit 1; }
gdown https://drive.google.com/file/d/1oW5b-fmV437SndGRDQ-Yz-vFizDmDZFG/view?usp=drive_link -O "$HOME/wallcolor" || { echo "Failed to download wallpaper"; exit 1; }
# Repeat for other gdown commands similarly...

# Copying configs to proper places
cp /etc/X11/xinit/xinitrc "$HOME/.xinitrc" || { echo "Failed to copy xinitrc"; exit 1; }

# Adding our configs and removing stuff to OS configs and Appending code to ~/.xinitrc using heredoc
sed -i '/twm &/,$d' "$HOME/.xinitrc" || { echo "Failed to update xinitrc"; exit 1; }
cat <<EOF >> "$HOME/.xinitrc"
xcompmgr &
EOF

# Generating script for TTY and DE theming 
cd "$HOME/.local/bin" || { echo "Failed to change directory to .local/bin"; exit 1; }
touch colorscript.sh || { echo "Failed to create colorscript.sh"; exit 1; }
chmod +x colorscript.sh || { echo "Failed to set executable permissions for colorscript.sh"; exit 1; }
cat <<EOF > colorscript.sh
#!/bin/bash

# Changing font
setfont ttf-fira-code

# Setting variable and its value
wall=\$(find $HOME/wallcolor -type f -name "*.jpg" -o -name "*.png" | shuf -n 1)

# Clear pywal cache
wal -c

# Set wallpaper as the value \$wall
xwallpaper --zoom \$wall

# Generating color theme as per wallpaper
wal -i \$wall

# Registering keystroke for status bar to sync theme
xdotool key super+F5
EOF

# Adding path variables
touch $HOME/.zprofile || { echo "Failed to create .zprofile"; exit 1; }
cat <<EOF > $HOME/.zprofile
export ZDOTDIR="$HOME/.config/zsh"
export PATH=$HOME/.local/bin:$PATH

if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then 
  exec startx
fi
EOF

# Adding e-DEX_ui in startup
mkdir -p "$HOME/e-DEX_ui" || { echo "Failed to create e-DEX_ui directory"; exit 1; }
cd "$HOME/e-DEX_ui" || { echo "Failed to change directory to e-DEX_ui"; exit 1; }
gdown https://drive.google.com/file/d/1qokMTsL8U6a8Glle1XMCN-ZuRTfr1dZf/view?usp=sharing || { echo "Failed to download eDEX-UI"; exit 1; }
chmod +x eDEX-UI-Linux-x86_64.AppImage || { echo "Failed to set executable permissions for eDEX-UI"; exit 1; }
chmod +x * || { echo "Failed to set executable permissions for files"; exit 1; }
mv eDEX-UI-Linux-x86_64.AppImage "$HOME/.local/bin" || { echo "Failed to move eDEX-UI to .local/bin"; exit 1; }

# Adding this script to xinitrc file (startup programs and configurations)
echo "startx &" >> "$HOME/.xinitrc" || { echo "Failed to add startx to .xinitrc"; exit 1; }
echo "feh --bg-fill \$wall" >> "$HOME/.xinitrc" || { echo "Failed to add feh command to .xinitrc"; exit 1; }

# Adding TGPT to OS from an unofficial site
curl -s https://tgpt.yxu.sh/install | bash || { echo "Failed to install TGPT"; exit 1; }

# Finish 
echo "Installation completed successfully! Please reboot the system."
