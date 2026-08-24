PACKAGE_NAME="pjproject"
PACKAGE_VERSION="2.15.1"
PACKAGE_SRC="https://github.com/pjsip/pjproject/archive/refs/tags/${PACKAGE_VERSION}.tar.gz"
PACKAGE_DEPENDS="alsa-lib"

configure_package() {
	CC="${BUILD_CC}" \
	CXX="${BUILD_CXX}" \
	CFLAGS="${BUILD_CFLAGS}" \
	CXXFLAGS="${BUILD_CFLAGS}" \
	CPPFLAGS="${BUILD_CFLAGS}" \
	LDFLAGS="${BUILD_LDFLAGS}" \
	PKG_CONFIG_LIBDIR="${BUILD_PKG_CONFIG_LIBDIR}" \
	PKG_CONFIG_SYSROOT_DIR="${BUILD_PKG_CONFIG_SYSROOT_DIR}" \
	./configure \
		--prefix=${INSTALL_PREFIX} \
		--build=${MACHTYPE} \
		--host=${BUILD_TARGET} \
		--disable-video \
		--disable-ffmpeg \
		--disable-v4l2 \
		--disable-openh264 \
		--disable-libyuv \
		--disable-vpx \
		--disable-opencore-amr \
		--disable-silk \
		--disable-speex \
		--disable-tls
}

make_package() {
	make dep
	make -j${MAKE_JOBS}
}

install_package() {
	BINDIR=${STAGING_DIR}/${INSTALL_PREFIX}/bin
	mkdir -p ${BINDIR}

	PJSUA_BIN=$(find ${PACKAGE_SRC_DIR}/pjsip-apps/bin \
		-maxdepth 1 -type f -name 'pjsua-*' -perm -111 | head -n1)

	[ -n "${PJSUA_BIN}" ] || return 1

	install -v -m 0755 "${PJSUA_BIN}" "${BINDIR}/pjsua"
}
