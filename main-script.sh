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
     sxiv mpv zathura zathura-pdf-mupdf ffmpeg imagemagick python python-pip \
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
cd "$HOME/.local/bin" 
chmod +x *
cd

# Retrieving wallpaper from my GDRIVE
mkdir -p "$HOME/wallcolor" || { echo "Failed to create wallcolor directory"; exit 1; }
cd "$HOME/wallcolor" || { echo "Failed to change directory to wallcolor"; exit 1; }
wget -O "$HOME/wallcolor/wallhaven-2yxp16.jpg" "https://www.dropbox.com/scl/fi/9jrmcvx01ons70ov84vp1/wallhaven-2yxp16.jpg?rlkey=t1ozs3ixqn7w2o5jir47jx9th&st=yxdk66sq&dl=1" || { echo "Failed to download wallpaper"; exit 1; }
wget -O "$HOME/wallcolor/wallhaven-3led2d.jpg" "https://www.dropbox.com/scl/fi/7jtl4oczv6s62ec1svvr9/wallhaven-3led2d.jpg?rlkey=13qyh4r6s17872eetegydckpo&st=ewug7hup&dl=1" || { echo "Failed to download wallpaper"; exit 1; }
wget -O "$HOME/wallcolor/wallhaven-5go1w8.jpg" "https://www.dropbox.com/scl/fi/saqpmbacppj9pgte87zf9/wallhaven-5go1w8.jpg?rlkey=amlgkedq813mhvb39ojnvz5uz&st=n5fv9sg8&dl=1" || { echo "Failed to download wallpaper"; exit 1; }
wget -O "$HOME/wallcolor/wallhaven-7p7yoe.png" "https://www.dropbox.com/scl/fi/w8bqsprzlsty4bwja1hhb/wallhaven-7p7yoe.png?rlkey=k8t57nwneq0ry5kzd19a6sc6r&st=qg31ynce&dl=1" || { echo "Failed to download wallpaper"; exit 1; }
wget -O "$HOME/wallcolor/wallhaven-9dp3y1.jpg" "https://www.dropbox.com/scl/fi/goi2korg3lkdf08l2w59h/wallhaven-9dp3y1.jpg?rlkey=kd8lombxvo26hbg7wtlb75kbk&st=p9i8816i&dl=1" || { echo "Failed to download wallpaper"; exit 1; }
wget -O "$HOME/wallcolor/wallhaven-72yzje.jpg" "https://www.dropbox.com/scl/fi/0fovos8sd468rv00ive0d/wallhaven-72yzje.jpg?rlkey=ri4hou2jomns04kwoj17fpznl&st=lk147jim&dl=1" || { echo "Failed to download wallpaper"; exit 1; }
wget -O "$HOME/wallcolor/wallhaven-8586my.png" "https://www.dropbox.com/scl/fi/a6yn9u1ofknwt336yf8i0/wallhaven-8586my.png?rlkey=lhf5oux0tonyfdk05o259y0k0&st=p0jnge6t&dl=1" || { echo "Failed to download wallpaper"; exit 1; }
wget -O "$HOME/wallcolor/wallhaven-d6y12l.jpg" "https://www.dropbox.com/scl/fi/zsx1wkn5uyncuvnjc9cc9/wallhaven-d6y12l.jpg?rlkey=mdg2gzz44lgpqoea6648d5exs&st=y2698vf0&dl=1" || { echo "Failed to download wallpaper"; exit 1; }
wget -O "$HOME/wallcolor/wallhaven-d6yrml.jpg" "https://www.dropbox.com/scl/fi/mu53joq30a3q4o4g9z16j/wallhaven-d6yrml.jpg?rlkey=b2jkty1mpc3x1kjztq2risf22&st=r4h2uxag&dl=1" || { echo "Failed to download wallpaper"; exit 1; }
wget -O "$HOME/wallcolor/wallhaven-exrqrr.jpg" "https://www.dropbox.com/scl/fi/lqj3z1r7y7jw507w8bm8b/wallhaven-exrqrr.jpg?rlkey=afanjbrwsxd17x1b3f1rdmvjk&st=ez0bnizj&dl=1" || { echo "Failed to download wallpaper"; exit 1; }
wget -O "$HOME/wallcolor/wallhaven-vqlkrm.jpg" "https://www.dropbox.com/scl/fi/i68omjuywxpg3cugp0mjd/wallhaven-vqlkrm.jpg?rlkey=xybzy20zrv5jtoui74skdxgls&st=ztie28u3&dl=1" || { echo "Failed to download wallpaper"; exit 1; }
wget -O "$HOME/wallcolor/wallhaven-werdv6.png" "https://www.dropbox.com/scl/fi/joadibh6a9fmv2sc26t6o/wallhaven-werdv6.png?rlkey=iamrw5c4elq19djzx5zb38hq6&st=g5tmhgvy&dl=1" || { echo "Failed to download wallpaper"; exit 1; }
wget -O "$HOME/wallcolor/wallhaven-zy3l5o.jpg" "https://www.dropbox.com/scl/fi/6clzilx7oo6eyosl9pdsi/wallhaven-zy3l5o.jpg?rlkey=926j9k7lumv5t7cw3t4ol1qu9&st=6kbp0zj1&dl=1" || { echo "Failed to download wallpaper"; exit 1; }
wget -O "$HOME/wallcolor/wallhaven-zy7gew.png" "https://www.dropbox.com/scl/fi/7u9ev58c814t4sh3igai1/wallhaven-zy7gew.png?rlkey=61fjhcjpuaw5gtj8beaamfisn&st=izeb1vka&dl=1" || { echo "Failed to download wallpaper"; exit 1; }
wget -O "$HOME/wallcolor/wallhaven-zyj28v.jpg" "https://www.dropbox.com/scl/fi/h6uusdpu3doxhtr5zmz0r/wallhaven-zyj28v.jpg?rlkey=jh4bts9jjy290fqp40h1s9h7a&st=tf1xc08p&dl=1" || { echo "Failed to download wallpaper"; exit 1; }

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

# Adding this script to xinitrc file (startup programs and configurations)
echo "startx &" >> "$HOME/.xinitrc" || { echo "Failed to add startx to .xinitrc"; exit 1; }
echo "~/.local/bin/colorscript.sh" >> "$HOME/.xinitrc" || { echo "Failed to add colorscript command to .xinitrc"; exit 1; }
echo "exec dwm" >> "$HOME/.xinitrc" || { echo " Failed to add exec dwm xinitrc" ; exit 1; }

# Adding TGPT to OS from an unofficial site
curl -s https://tgpt.yxu.sh/install | bash || { echo "Failed to install TGPT"; exit 1; }

# Finish 
echo "Installation completed successfully! Please reboot the system."
