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
