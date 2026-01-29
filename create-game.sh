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
Create game based on the provided data

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
    echo "Creating desktop entity ..."
    echo "[Desktop Entry]
Type=Application
Version=1.0
Name=$game_name
Comment='$game_name' runs via Proton. Game entity was created by a script.
Exec=$script_full_path
Icon=$icon_path
Terminal=false
Categories=Games;
" > "${HOME%/}/.local/share/applications/$game_name.desktop"
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
createDesktopEntity
