VERSION=1.0.0
UPDATED=30/05/20
GAME_DIRECTORY=/root/files

echo Trident Filehost Configuration
echo version $VERSION updated $UPDATED; echo

# Install OS dependancies
echo info: Downloading OS dependancies...
apt update; 
export DEBIAN_FRONTEND=noninteractive
apt install -yq nginx

# Enable UFW and add firewall.
echo info: Enabling firewall...
ufw enable <<< $"y\n"
ufw allow 80

cd /root/
# Install utility tools
if [ ! -d ".oh-my-zsh" ]; then
    echo info: Installing OhMyZSH and Homebrew...
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

echo Downloading NGINX files...
wget -qO- https://raw.githubusercontent.com/skyefoxie/trident-tf2-config/master/nginx.tar.gz | tar xvzf -

echo Installing NGINX as a service...
mv nginx/nginx.service /lib/systemd/system/nginx.service

systemctl enable nginx
systemctl start nginx

echo; echo Done.; echo