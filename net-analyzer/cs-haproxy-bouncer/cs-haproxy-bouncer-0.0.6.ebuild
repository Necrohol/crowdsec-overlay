# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1..4} luajit )

inherit lua-single toolchain-funcs

MY_PN="cs-haproxy-bouncer"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="CrowdSec bouncer module for HAProxy"
HOMEPAGE="https://github.com/crowdsecurity/cs-haproxy-bouncer"
SRC_URI="https://github.com/crowdsecurity/cs-haproxy-bouncer/releases/download/v${PV}/crowdsec-haproxy-bouncer.tgz -> ${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
REQUIRED_USE="${LUA_REQUIRED_USE}"

DEPEND="
	${LUA_DEPS}
	$(lua_gen_cond_dep '
		dev-lua/lua-cjson[${LUA_USEDEP}]
		dev-lua/luasocket[${LUA_USEDEP}]
	')
	net-proxy/haproxy
"
RDEPEND="${DEPEND}
	$(lua_gen_cond_dep '
		dev-lua/lua-apr[${LUA_USEDEP}]
	')"

S="${WORKDIR}"

src_prepare() {
	default
	# Makefile uses gcc by default
	if [[ -f Makefile ]]; then
		sed -i -e 's/gcc/$(CC)/g' Makefile || die
	fi
}

src_compile() {
	# Make sure the correct CC is used
	if [[ -f Makefile ]]; then
		emake CC="$(tc-getCC)"
	fi
}

src_install() {
	insinto "$(lua_get_lmod_dir)"
	# We'll update this line based on the actual file location
	doins $(find "${S}" -name '*.lua')
}