#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# Update the system
echo "Updating system packages..."
sudo pacman -Syu --noconfirm || { echo "System update failed"; exit 1; }

# Installing necessary packages
echo "Installing necessary packages for compilation and basic system utilities..."
sudo pacman -S --noconfirm base-devel git vim xwallpaper xorg-xrandr zsh python-pywal zsh-syntax-highlighting xdotool || { echo "Package installation failed"; exit 1; }

echo "Installing dependencies ....."
sudo pacman -S --noconfirm xorg libxft libx11 libxinerama build-essential ttf-font-awesome python python-pip || { echo "Additional dependencies installation failed"; exit 1; }

echo "Installing gdown for GD pull req"
sudo pip install gdown || { echo "Failed to install gdown"; exit 1; }

# Cloning the main repository
echo "Cloning the main repository from GitHub..."
git clone https://github.com/ofcourseiuselinux/dx.git || { echo "Failed to clone repository"; exit 1; }

# Navigate into the 'dx' directory and run 'sudo make all'
cd dx || { echo "Failed to change directory to dx"; exit 1; }
echo "Running 'sudo make all' in the 'dx' directory..."
sudo make all || { echo "Failed to run make all"; exit 1; }

# Array of subdirectories to build and install within the 'dx' directory
directories=("dwm" "dmenu" "st")

# Loop through each subdirectory and build/install
for dir in "${directories[@]}"; do
  if [ -d "$dir" ]; then
    cd "$dir" || { echo "Failed to change directory to $dir"; exit 1; }
    echo "Installing in directory: $dir"
    sudo make clean install || { echo "Failed to install $dir"; exit 1; }
    cd ..
  else
    echo "Directory $dir does not exist."
  fi
done

# Handle the 'dwmstatus' directory separately
if [ -d "dwmstatus" ]; then
  cd "dwmstatus" || { echo "Failed to change directory to dwmstatus"; exit 1; }
  echo "Executing 'sudo ./install.sh' in 'dwmstatus' directory..."
  sudo ./install.sh || { echo "Failed to execute install.sh"; exit 1; }
  cd ..
else
  echo "Directory 'dwmstatus' does not exist."
fi

# Configure .xinitrc
echo "Configuring .xinitrc to start dwm..."
# Copy the default xinitrc to the user's home directory
cp /etc/X11/xinit/xinitrc ~/.xinitrc || { echo "Failed to copy xinitrc"; exit 1; }

# Install Oh My Zsh
echo "Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended || { echo "Failed to install Oh My Zsh"; exit 1; }

# Set zsh as the default shell
echo "Setting zsh as the default shell..."
chsh -s $(which zsh) || { echo "Failed to set zsh as default shell"; exit 1; }

# Configure .zshrc
echo "Configuring .zshrc..."
# Update the ZSH_THEME in .zshrc
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="alanpeabody"/' ~/.zshrc || { echo "Failed to update ZSH_THEME"; exit 1; }

# Modify alanpeabody.zsh-theme
echo "Configuring alanpeabody.zsh-theme..."
# Edit the alanpeabody theme file
sed -i 's/PROMPT="${user} ${pwd}$ "/PROMPT="[${user} ${pwd}]$ "/' ~/.oh-my-zsh/themes/alanpeabody.zsh-theme || { echo "Failed to modify alanpeabody.zsh-theme"; exit 1; }

echo "Terminal colored!"

# Creating wallpaper directory
echo "Creating wallpaper directory..."
mkdir -p ~/wallpapers || { echo "Failed to create wallpapers directory"; exit 1; }
cd ~/wallpapers || { echo "Failed to change directory to ~/wallpapers"; exit 1; }

# Pulling wallpapers from Google Drive
echo "Downloading wallpapers..."
for id in 1oW5b-fmV437SndGRDQ-Yz-vFizDmDZFG 11scVF2c9qGufWUxXpc4Pwg-FGZoQALNg 16jNpjYE9Z3CmSoDYw_BlsT3OKTc1RlU5 1CY5CKUIT2VafrrJfUDUI6S7JfK7RdFmS 1nhP-tACiGN3tVTA5v97to7NwztG_HGUL 1O82WLdQKnhAWzzshKmOlfjifIwFrO5jG 1DytOC4EjGJ0WbofAKO6KAwn939v2goEO 1tV229zFzfYY0ATWN6p9hlJChqeFGEGVu 1iNhj0c6UORPzdvWC3f08cY46R6rKdrlN 13zuhJGy_L10gvU2HtfFaateYiwTmDBN6 1EukhOxfBG8s0FuDrT1EZtTgqEVmeVhsl 1jdd7inEyGWwLFXYg-nNCI1fRIwKa6myA 14tq24wrSviA7YTHF20ML0yMweawLzguQ 1P7kESkXh1vFv734Kv6YMdpaXOwmCOkor 162P_HzTTRYzuSB1tFKPV6wraEal34rIO; do
  gdown "https://drive.google.com/uc?id=$id" || { echo "Failed to download wallpaper with ID $id"; exit 1; }
done
echo "Well walls are painted"

# Creating the pywal script
echo "Creating pywal script..."
mkdir -p ~/.local/bin
cd ~/.local/bin || { echo "Failed to change directory to ~/.local/bin"; exit 1; }
touch theme-script.sh
chmod +x theme-script.sh
cat <<EOF > theme-script.sh
#!/bin/bash
wall=\$(find ~/wallpapers -type f -name "*.jpg" -o -name "*.png" | shuf -n 1)

# Coloring my wall
xwallpaper --zoom \$wall

# Generating color scheme
wal -c
wal -i \$wall

xdotool key super+F5
EOF

# Linking theme to xinitrc
echo "Linking theme to .xinitrc..."
cd || { echo "Failed to change directory to home"; exit 1; }
# Append 'exec dwm' to the end of the .xinitrc file
echo "xcompmgr &" >> ~/.xinitrc
echo "~/.local/bin/theme-script.sh &" >> ~/.xinitrc
echo "exec dwm" >> ~/.xinitrc

echo ".xinitrc has been configured."

echo "Configuration complete."
