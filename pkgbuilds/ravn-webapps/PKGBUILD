# Maintainer: Roberto Flores <robert-flo>
pkgname=ravn-webapps
pkgver=1.0.0
pkgrel=1
pkgdesc='Universal web application launchers, icons and runtime launcher for the RaVN workstation'
arch=('any')
url='https://github.com/robert-flo/ravn-webapps'
license=('MIT')
options=('!debug')
depends=('bash' 'hicolor-icon-theme')
optdepends=(
  'google-chrome: Google Chrome browser'
  'brave-bin: Brave browser'
  'chromium: Open source Chromium browser'
  'microsoft-edge-stable-bin: Microsoft Edge browser'
  'uwsm: Wayland Systemd Session Manager for app cgroup isolation'
)
source=(
  "${pkgname}-${pkgver}.tar.gz::${url}/archive/refs/tags/v${pkgver}.tar.gz"
)
sha256sums=(
  'fd5cc02607165c30fa39dd9ef892bff4d7ea547b2701a357e73d722e1a742dfb'
)

package() {
  cd "${srcdir}/${pkgname}-${pkgver}"
  make DESTDIR="${pkgdir}" install
}
