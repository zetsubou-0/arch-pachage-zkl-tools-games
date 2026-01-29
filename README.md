# Game Tools

## About
This tools package is based on Proton compatibility and is used to simplify working with Windows games.

## How to add to the repository

### Arch-based repositories (pacman)

1. Open `/etc/pacman.conf` with root privileges
2. Add a new repository:
```
[zkl-repo]
SigLevel = Optional TrustAll
Server = https://zetsubou-0.github.io/arch-pachage-zkl-tools-games/repo/any
```
3. Update repositories
```
sudo pacman -Sy
```

## How to install
```
sudo pacman -S zkl-tools-games
```

## Build from sources
1. Run `./build.sh`
2. Find the package under `repo/any/zkl-tools-games-{{version}}-any.pkg.tar.zst`
3. Run the following command (replace the version):
```
sudo pacman -U /path/to/package/zkl-tools-games-{{version}}-any.pkg.tar.zst
```

## Examples

### Create game entity in the system meny under "Games" category
<p>For example lets try to create an entity for Warcraft 3.<br>
The executable binary file (exe) located under "/mnt/store/Games/Warcraft 3/Frozen Throne.exe",
in this case we need to specify this path with '-p' key</p>

<p>The name of the game we want to see in the menu is “war3”. Please note that the name of the generated script will be the same.<br>
Specify it with the '-n' key.</p>

<p>The folder where the generated scripts will be located specified with '-s' key.</p>

<p>If you want to specify the icon, please do it with the '-i' key and full path to icon</p>

```
create-game \
    -p "/mnt/store/Games/Warcraft 3/Frozen Throne.exe" 
    -n war3 \
    -s ~/scripts \
    -i "/mnt/store/Games/Warcraft 3/replays.ico"
```



