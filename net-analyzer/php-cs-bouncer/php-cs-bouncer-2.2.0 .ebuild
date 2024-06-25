# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PHP_EXT_NAME="cs_bouncer"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
PHP_EXT_ECONF_ARGS=(--enable-cs_bouncer)
USE_PHP="php7-4 php8-0 php8-1 php8-2"

inherit php-ext-source-r3

DESCRIPTION="The official PHP bouncer library for the CrowdSec Local API"
HOMEPAGE="https://github.com/crowdsecurity/php-cs-bouncer/"
SRC_URI="https://github.com/crowdsecurity/php-cs-bouncer/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-lang/php-7.2.5:*[json,gd]
	>=dev-php/crowdsec-remediation-engine-3.3.0
	>=dev-php/crowdsec-common-2.2.0
	|| (
		dev-php/symfony-config-4.4.27
		dev-php/symfony-config-5.2
		dev-php/symfony-config-6.0
	)
	>=dev-php/twig-3.4.2
	>=dev-php/gregwar-captcha-1.2.1
	>=dev-php/mlocati-ip-lib-1.18
"
DEPEND="${RDEPEND}"
BDEPEND=">=dev-php/composer-2.7.7"

S="${WORKDIR}/php-cs-bouncer-${PV}"

src_prepare() {
	default
	php-ext-source-r3_src_prepare
}

src_configure() {
	php-ext-source-r3_src_configure
}

src_compile() {
	php-ext-source-r3_src_compile
	composer install --no-dev --optimize-autoloader || die "Composer install failed"
}

src_install() {
	php-ext-source-r3_src_install

	# Install PHP files
	insinto "/usr/share/php/crowdsec-bouncer"
	doins -r src/* config templates vendor
}

pkg_postinst() {
	php-ext-source-r3_pkg_postinst
	elog "CrowdSec PHP Bouncer has been installed."
	elog "Please refer to the documentation for configuration and usage instructions."
}