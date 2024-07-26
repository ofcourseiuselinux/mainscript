#!/bin/bash

# Update the system
echo "Updating system packages..."
sudo pacman -Syu || { echo "System update failed"; exit 1; }

# Installing necessary packages
echo "Installing necessary packages for compilation and basic system utilities..."
sudo pacman -S base-devel git vim xwallpaper xorg-xrandr zsh python-pywal zsh-syntax-highlighting xdotool || { echo "Package installation failed"; exit 1; }

echo "Installing dependencies ....."
sudo pacman -S xorg libxft libx11 libxinerama ttf-font-awesome python python-pip || { echo "Additional dependencies installation failed"; exit 1; }

echo "Installing gdown for GD pull req"
sudo pip install gdown --break-system-packages || { echo "Failed to install gdown"; exit 1; }

# Cloning the repositories
echo "Cloning the dwm repository from GitHub..."
git clone https://github.com/ofcourseiuselinux/myusage-dwm.git || { echo "Failed to clone dwm repository"; exit 1; }

echo "Cloning the st repository from GitHub..."
git clone https://github.com/ofcourseiuselinux/myusage-st.git || { echo "Failed to clone st repository"; exit 1; }

echo "Cloning the dmenu repository from GitHub..."
git clone https://github.com/ofcourseiuselinux/myusage-dmenu.git || { echo "Failed to clone dmenu repository"; exit 1; }

# Array of repositories to build and install
directories=("myusage-dwm" "myusage-st" "myusage-dmenu")

# Loop through each repository and build/install
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

# Modify .bash_profile to add startx
echo "Modifying .bash_profile to add 'startx'..."
if ! grep -q "startx" ~/.bash_profile; then
  echo "startx" >> ~/.bash_profile || { echo "Failed to modify .bash_profile"; exit 1; }
else
  echo "'startx' is already present in .bash_profile"
fi

echo ".xinitrc has been configured and .bash_profile updated."

echo "Configuration complete."
