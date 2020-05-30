VERSION=1.0.0
UPDATED=30/05/20
SUBJECT=3621

echo Trident Configuration
echo version $VERSION updated $UPDATED; echo

echo info: Checking dependancies...
require_dep wget

if [ ! -d "./lgsm" ] && [ ! -f "tf2server" ]; then
    echo "error: LGSM does not appear to be installed - downloading it for you..."
    wget -qO linuxgsm.sh https://linuxgsm.sh && chmod +x linuxgsm.sh
    echo "info: Run ./linuxgsm.sh tf2server to continue."
fi

GAME_DIRECTORY=$1

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