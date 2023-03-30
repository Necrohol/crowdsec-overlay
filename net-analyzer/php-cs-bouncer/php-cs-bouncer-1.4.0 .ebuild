# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PHP_EXT_ECONF_ARGS=(--enable-cs_bouncer)
USE_PHP="php7-4 php8-0"

inherit php-ext-source-r3 composer

DESCRIPTION="Crowdsec PHP extension for bouncer module"
HOMEPAGE="https://github.com/crowdsecurity/php-cs-bouncer/"
SRC_URI="https://github.com/crowdsecurity/php-cs-bouncer/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-lang/php-7.4:=
	>=dev-libs/libpcre-8.0:0=
"
DEPEND="${RDEPEND}"

src_prepare() {
	php-ext-source-r3_src_prepare
	composer_src_prepare
}

src_configure() {
	php-ext-source-r3_src_configure
}

src_compile() {
	php-ext-source-r3_src_compile
}

src_install() {
	php-ext-source-r3_src_install

	# Install composer dependencies
	composer_src_install
}

pkg_postinst() {
	php-ext-source-r3_pkg_postinst
	composer_pkg_postinst
}

pkg_postrm() {
	php-ext-source-r3_pkg_postrm
	composer_pkg_postrm
}