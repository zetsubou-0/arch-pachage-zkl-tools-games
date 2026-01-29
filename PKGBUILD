# Maintainer: Kiryl Lutsyk <zetsubou.zero.0@gmail.com>
pkgname=zkl-tools-games
pkgver=1.0.4
pkgrel=1
epoch=
pkgdesc="This tools package is based on Proton compatibility and is used to simplify working with Windows games."
arch=(
    "any"
)
url="https://github.com/zetsubou-0/arch-pachage-zkl-tools-games"
license=(
    "MIT"
)
groups=()
depends=(
    "bash"
    "steam"
)
makedepends=()
checkdepends=()
optdepends=()
provides=()
conflicts=()
replaces=()
backup=()
options=()
install=
changelog=changelog.txt
source=(
    "proton-run.sh"
    "proton-prefix.conf"
    "create-game.sh"
)
noextract=()
sha256sums=(
    "SKIP"
    "SKIP"
    "SKIP"
)
validpgpkeys=()

package() {
    install -Dm755 "$srcdir/proton-run.sh"    "$pkgdir/usr/bin/proton-run"
    install -Dm644 "$srcdir/proton-prefix.conf" \
        "$pkgdir/usr/lib/tmpfiles.d/proton-prefix.conf"

    install -Dm755 "$srcdir/create-game.sh"   "$pkgdir/usr/bin/create-game"
}


