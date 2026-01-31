#!/usr/bin/env bash

if [ "$(whoami)" == "root" ];then
    echo "Run a program with root permissions is restricted. Please do not run an application on the 'root' behalf."
    exit 1
fi

GAME_PATH=""
GAME_NAME=""
SCRIPT_PATH=""
ICON_GAME_PATH=""
REMOVE_GAME_LAUNCHER=""
VALID_DATA_FLAG=1
AGREE_WITH_DATA_FLAG=""

while getopts p:n:s:i:r:h option
do
    case "${option}"
        in
            p) GAME_PATH=${OPTARG};;
            n) GAME_NAME=${OPTARG};;
            s) SCRIPT_PATH=${OPTARG};;
            i) ICON_GAME_PATH=${OPTARG};;
            r) REMOVE_GAME_LAUNCHER=${OPTARG};;
            h) show_help;;
            *) show_help;;
  esac
done

function show_help() {
    echo "
Create game launcher based on the provided data

-p  game path (path to bin)
-n  game name
-s  folder with scripts
-i  game icon
-r remove game launcher and related data
-h  show help
"
    exit 0
}

function checkData() {
    if [ -z "$GAME_PATH" ]; then
        echo "Full path to bin is required. Please set path with -p key."
        VALID_DATA_FLAG=0
    fi
    if [ -z "$SCRIPT_PATH" ]; then
        echo "Script path to bin is required. Please set path with -s key."
        VALID_DATA_FLAG=0
    fi
    if [ -z "$GAME_NAME" ]; then
        echo "Name is required. Please set path with -n key."
        VALID_DATA_FLAG=0
    fi
}

function normalizeName() {
    GAME_NAME="$(echo "$GAME_NAME" | tr -d "[:space:]")"
}

function printInfo() {
    echo "Bin path (executable application): '$GAME_PATH'"
    echo "Scripts root folder: '$SCRIPT_PATH'"
    echo "Game name: '$GAME_NAME'"
    echo "Game Icon: '$ICON_GAME_PATH'"
}

function createScript() {
    local SCRIPT_FULL_PATH="${SCRIPT_PATH%/}/$GAME_NAME.sh"
    echo "Creating script ..."
    echo "#!/usr/bin/env bash

proton-run '$GAME_PATH'
    " > "$SCRIPT_FULL_PATH"
    chmod +x "$SCRIPT_FULL_PATH"
    echo "Script has been created successfully."
}

function createDesktopEntity() {
    local SCRIPT_FULL_PATH="${SCRIPT_PATH%/}/$GAME_NAME.sh"
    echo "[Desktop Entry]
Type=Application
Version=1.0
Name=$GAME_NAME
Comment='$GAME_NAME' runs via Proton. Game entity was created by a script.
Exec=$SCRIPT_FULL_PATH
Icon=$ICON_GAME_PATH
Terminal=false
Categories=Game;
" | sudo tee "$(createDesktopEntityPath "$GAME_NAME")" > /dev/null
    echo "Creating desktop entity ..."
}

function createDesktopEntityPath() {
    echo "/usr/share/applications/$1.desktop"
}

function extractIcons() {
    local ICON_FOLDER_PATH="/tmp/zkl-game-$GAME_NAME/icons"
    local ICON_FILE="$GAME_NAME.ico"
    local CURRENT_DIR="$(pwd)"
    local WIDTH=16
    local HEIGHT=16
    local ICON_APP_PATH=""
    mkdir -p "$ICON_FOLDER_PATH"
    cd "$ICON_FOLDER_PATH"
    wrestool -x -t 14 "$GAME_PATH" > "$ICON_FILE"
    magick "$ICON_FILE" "$GAME_NAME.png"
    for ICON_PNG in ./$GAME_NAME*.png; do
        WIDTH="$(identify -format "%w" $ICON_PNG)"
        HEIGHT="$(identify -format "%h" $ICON_PNG)"
        ICON_APP_PATH="/usr/share/icons/hicolor/$WIDTH"x"$HEIGHT/apps/$GAME_NAME.png"
        echo "Create icon under $ICON_APP_PATH"
        sudo cp "$ICON_PNG" "$ICON_APP_PATH"
    done
    rm -r "$ICON_FOLDER_PATH"
    cd "$CURRENT_DIR"
    ICON_GAME_PATH="$GAME_NAME"
    updateIconCache
}

function updateIconCache() {
    sudo gtk-update-icon-cache -f /usr/share/icons/hicolor
    sudo update-desktop-database /usr/share/applications
}

function removeGameLauncher() {
    if [ -e "$(createDesktopEntityPath "$REMOVE_GAME_LAUNCHER")" ]; then
        echo "The game '$REMOVE_GAME_LAUNCHER' exists."
    else
        echo "The game '$REMOVE_GAME_LAUNCHER' does not exist."
        exit 1
    fi
    removeScript
    removeDesktopEntity
}

function removeScript() {
    if [ -z "$SCRIPT_PATH" ]; then
        echo "Script path is empty, please specify the script path with '-s' key"
        exit 1
    fi
    local PATH="${SCRIPT_PATH%/}/$REMOVE_GAME_LAUNCHER.sh"
    if [ -e "$PATH" ]; then
        rm "$PATH"
        echo "Script under $PATH has been removed."
    else
        echo "Script under $PATH is no longer exist, no action required."
    fi
}

function removeDesktopEntity() {
    sudo rm "$(createDesktopEntityPath "$REMOVE_GAME_LAUNCHER")"
    echo "Desktop launcher for '$REMOVE_GAME_LAUNCHER' has been removed."
}

if [ -n "$REMOVE_GAME_LAUNCHER" ]; then
    removeGameLauncher
    exit 0
fi

checkData

if [ $VALID_DATA_FLAG != 1 ];then
    show_help
fi

normalizeName
printInfo

read -sp "Do you agree with provided data? (y/n)" AGREE_WITH_DATA_FLAG

if [ "$AGREE_WITH_DATA_FLAG" != "y" ]; then
    exit 0;
fi

echo ""

createScript
extractIcons
createDesktopEntity
