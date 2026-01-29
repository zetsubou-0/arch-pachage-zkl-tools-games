# Maintainer: Kiryl Lutsyk <zetsubou.zero.0@gmail.com>
pkgname=zkl-tools-games
pkgver=1.0.3
pkgrel=3
epoch=
pkgdesc="Tools to create links ,scripts and it can work with games on Arch based systems"
arch=(
    "any"
)
url="https://github.com/zetsubou-0/arch-pachage-zkl-tools-games"
license=(
    "MIT"
)
groups=(
    "zkl-tools"
)
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
changelog=
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


