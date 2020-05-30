VERSION=1.0.0
UPDATED=30/05/20
GAME_DIRECTORY=/home/tf2/serverfiles

echo Trident Configuration
echo version $VERSION updated $UPDATED; echo

# Install OS dependancies
echo info: Downloading OS dependancies...
dpkg --add-architecture i386; 
apt update; 
export DEBIAN_FRONTEND=noninteractive
apt install -yq unzip binutils jq netcat lib32gcc1 lib32stdc++6 libcurl4-gnutls-dev:i386 libtcmalloc-minimal4:i386

echo info: Installing SteamCMD...
echo steam steam/question select "I AGREE" | debconf-set-selections 
echo steam steam/license note "" | debconf-set-selections 
apt install -yq steamcmd

# Create user
echo info: Creating user 'tf2'...
useradd -m tf2
su tf2

# Enter into TF2 home directory.
cd /home/tf2

if [ ! -d "./lgsm" ] && [ ! -f "tf2server" ]; then
    echo "error: LGSM does not appear to be installed - downloading it for you."
    curl -o- https://linuxgsm.sh | bash -s tf2server
fi

# Install
echo "info: Starting server installation..."

if [ ! $1 ]; then
    echo warn: Game server token has not been specified - this can be changed later.
fi

printf "%s\n" Y Y $GSLT_TOKEN Y Y | ./tf2server install

exit;

# Check for missing game directory.
if [ ! -d $GAME_DIRECTORY ]; then
    echo error: Specified directory does not exist.
    exit;
fi

# Check that game directory is valid.
if [ ! -d "$GAME_DIRECTORY/tf" ] || [ ! -d "$GAME_DIRECTORY/hl2" ] ; then
    echo "error: Invalid game directory."
    exit;
fi

# Install SourceMod.
echo info: Installing SourceMod...
cd "$GAME_DIRECTORY/tf"

wget -qO- https://mms.alliedmods.net/mmsdrop/1.10/mmsource-1.10.7-git971-linux.tar.gz | tar xvzf -
wget -qO- https://sm.alliedmods.net/smdrop/1.10/sourcemod-1.10.0-git6454-linux.tar.gz | tar xvzf -

echo success: Done.
echo info: Extracting configuration...

wget -qO- https://raw.githubusercontent.com/skyefoxie/trident-tf2-config/master/config.tar.gz

echo success: Done.