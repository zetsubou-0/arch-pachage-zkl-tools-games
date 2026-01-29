#!/usr/bin/env bash

if [ "$(whoami)" == "root" ];then
    echo "Run a program with root permissions is restricted. Please do not run an application on the 'root' behalf."
    exit 1
fi

game_path=""
game_name=""
script_path=""
icon_path=""
valid_data=1
agree_with_data=""

while getopts p:n:s:i:h option
do
  case "${option}"
      in
          p) game_path=${OPTARG};;
          n) game_name=${OPTARG};;
          s) script_path=${OPTARG};;
          i) icon_path=${OPTARG};;
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
-i  icon_path
-h  show help
"
    exit 0
}

function checkData() {
    if [ -z "$game_path" ]; then
        echo "Full path to bin is required. Please set path with -p key."
        valid_data=0
    fi
    if [ -z "$script_path" ]; then
        echo "Script path to bin is required. Please set path with -s key."
        valid_data=0
    fi
    if [ -z "$game_name" ]; then
        echo "Name is required. Please set path with -n key."
        valid_data=0
    fi
}

function normalizeName() {
    game_name="$(echo "$game_name" | tr -d "[:space:]")"
}

function printInfo() {
    echo "Bin path (executable application): '$game_path'"
    echo "Scripts root folder: '$script_path'"
    echo "Game name: '$game_name'"
    echo "Game Icon: '$icon_path'"
}

function createScript() {
    local script_full_path="${script_path%/}/$game_name.sh"
    echo "Creating script ..."
    echo "#!/usr/bin/env bash

proton-run '$game_path'
    " > "$script_full_path"
    chmod +x "$script_full_path"
    echo "Script has been created successfully."
}

function createDesktopEntity() {
    local script_full_path="${script_path%/}/$game_name.sh"
    echo "[Desktop Entry]
Type=Application
Version=1.0
Name=$game_name
Comment='$game_name' runs via Proton. Game entity was created by a script.
Exec=$script_full_path
Icon=$icon_path
Terminal=false
Categories=Game;
" | sudo tee "/usr/share/applications/$game_name.desktop" > /dev/null
    echo "Creating desktop entity ..."
}

function extractIcons() {
    local icon_folder_path="/tmp/zkl-game-$game_name/icons"
    local ico_file="$game_name.ico"
    local current_dir="$(pwd)"
    local width=16
    local height=16
    local ico_app_path=""
    mkdir -p "$icon_folder_path"
    cd "$icon_folder_path"
    wrestool -x -t 14 "$game_path" > "$ico_file"
    magick "$ico_file" "$game_name.png"
    for icon_png in ./$game_name*.png; do
        width="$(identify -format "%w" $icon_png)"
        height="$(identify -format "%h" $icon_png)"
        ico_app_path="/usr/share/icons/hicolor/$width"x"$height/apps/$game_name.png"
        echo "Create icon under $ico_app_path"
        sudo cp "$icon_png" "$ico_app_path"
    done
    rm -r "$icon_folder_path"
    cd "$current_dir"
    icon_path="$game_name"
    updateIconCache
}

function updateIconCache() {
    sudo gtk-update-icon-cache -f /usr/share/icons/hicolor
    sudo update-desktop-database /usr/share/applications
}

checkData

if [ $valid_data != 1 ];then
    show_help
fi

normalizeName
printInfo

read -sp "Do you agree with provided data? (y/n)" agree_with_data

if [ "$agree_with_data" != "y" ]; then
    exit 0;
fi

echo ""

createScript
extractIcons
createDesktopEntity
