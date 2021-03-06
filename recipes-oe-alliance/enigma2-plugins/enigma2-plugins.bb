DESCRIPTION = "Additional plugins for Enigma2"
MAINTAINER = "OE-Alliance team"

LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://COPYING;md5=8e37f34d0e40d32ea2bc90ee812c9131"

PACKAGES_DYNAMIC = "enigma2-plugin-(?!pli-).*"
PROVIDES = "${PN} \
	enigma2-plugin-extensions-fancontrol2 \
	"

inherit gitpkgv

PV = "git${SRCPV}"
PKGV = "git${GITPKGV}"
PR = "r24"

SRC_URI = "${ENIGMA2_PLUGINS_URI} file://pluginnotwanted"

SRC_URI_append_vuuno = " \
			file://dreambox_bouqueteditor.png \
			file://FC2dreambox.png"
SRC_URI_append_vuultimo = " \
			file://dreambox_bouqueteditor.png \
			file://FC2dreambox.png"
SRC_URI_append_vusolo = " \
			file://dreambox_bouqueteditor.png"
SRC_URI_append_vuduo = " \
			file://dreambox_bouqueteditor.png"
SRC_URI_append_et4x00 = " \
			file://dreambox_bouqueteditor.png"
SRC_URI_append_et5x00 = " \
			file://dreambox_bouqueteditor.png"
SRC_URI_append_et6x00 = " \
			file://dreambox_bouqueteditor.png"
SRC_URI_append_et9x00 = " \
			file://dreambox_bouqueteditor.png"
SRC_URI_append_odinm9 = " \
			file://dreambox_bouqueteditor.png"

EXTRA_OECONF = " \
	BUILD_SYS=${BUILD_SYS} \
	HOST_SYS=${HOST_SYS} \
	STAGING_INCDIR=${STAGING_INCDIR} \
	STAGING_LIBDIR=${STAGING_LIBDIR} \
	--without-debug \
	--with-po \
	--with-boxtype=${MACHINE} \
	${@base_contains("MACHINE_FEATURES", "tpm", "--with-tpm" , "", d)} \
"

CONFFILES_${PN} += "${sysconfdir}/enigma2/movietags"
FILES_${PN} += " /usr/share/enigma2 /usr/share/fonts "
FILES_${PN}-meta = "${datadir}/meta"
FILES_enigma2-plugin-extensions-bmediacenter += " ${libdir}/enigma2/python/Components/Renderer/LizWatches.pyo ${libdir}/enigma2/python/Components/Converter/LizExtraNumText.pyo"
FILES_enigma2-plugin-extensions-bmediacenter-src += " ${libdir}/enigma2/python/Components/Renderer/LizWatches.py ${libdir}/enigma2/python/Components/Converter/LizExtraNumText.py"

PACKAGES += "${PN}-meta"
PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit autotools

S = "${WORKDIR}/git"

DEPENDS = "enigma2 \
	python-pyopenssl \
	python-gdata \
	streamripper \
	python-mutagen \
	python-twisted \
	python-daap \
	dvdbackup \
	libcddb \
	nmap \
	${@base_contains("MACHINE_FEATURES", "tpm", "" , "enigma2-plugin-extensions-webinterface-old", d)}"

do_install_append_vuuno() {
	install -m 0644 ${WORKDIR}/FC2dreambox.png ${D}/usr/lib/enigma2/python/Plugins/Extensions/FanControl2/data/
	install -m 0644 ${WORKDIR}/dreambox_bouqueteditor.png ${D}/usr/lib/enigma2/python/Plugins/Extensions/WebBouquetEditor/web-data/
}
do_install_append_vuultimo() {
	install -m 0644 ${WORKDIR}/FC2dreambox.png ${D}/usr/lib/enigma2/python/Plugins/Extensions/FanControl2/data/
	install -m 0644 ${WORKDIR}/dreambox_bouqueteditor.png ${D}/usr/lib/enigma2/python/Plugins/Extensions/WebBouquetEditor/web-data/
}
do_install_append_vusolo() {
	install -m 0644 ${WORKDIR}/dreambox_bouqueteditor.png ${D}/usr/lib/enigma2/python/Plugins/Extensions/WebBouquetEditor/web-data/
}
do_install_append_vuduo() {
	install -m 0644 ${WORKDIR}/dreambox_bouqueteditor.png ${D}/usr/lib/enigma2/python/Plugins/Extensions/WebBouquetEditor/web-data/
}
do_install_append_et4x00() {
	install -m 0644 ${WORKDIR}/dreambox_bouqueteditor.png ${D}/usr/lib/enigma2/python/Plugins/Extensions/WebBouquetEditor/web-data/
}
do_install_append_et5x00() {
	install -m 0644 ${WORKDIR}/dreambox_bouqueteditor.png ${D}/usr/lib/enigma2/python/Plugins/Extensions/WebBouquetEditor/web-data/
}
do_install_append_et6x00() {
	install -m 0644 ${WORKDIR}/dreambox_bouqueteditor.png ${D}/usr/lib/enigma2/python/Plugins/Extensions/WebBouquetEditor/web-data/
}
do_install_append_et9x00() {
	install -m 0644 ${WORKDIR}/dreambox_bouqueteditor.png ${D}/usr/lib/enigma2/python/Plugins/Extensions/WebBouquetEditor/web-data/
}
do_install_append_odinm9() {
	install -m 0644 ${WORKDIR}/dreambox_bouqueteditor.png ${D}/usr/lib/enigma2/python/Plugins/Extensions/WebBouquetEditor/web-data/
}

do_install_append() {
	# remove unused .pyc files
	find ${D}/usr/lib/enigma2/python/ -name '*.pyc' -exec rm {} \;
	# remove leftover webinterface garbage
	${@base_contains('MACHINE_FEATURES', 'tpm','','rm -rf ${D}/usr/lib/enigma2/python/Plugins/Extensions/WebInterface',d)}
}

addtask do_remove_unwanted_packages before do_package after do_install

python do_remove_unwanted_packages () {
	mydir = bb.data.getVar('D', d, 1) + "/../git/"

	def deletenotwanted(mydir, d, package):
		packagename = package[-1]
		import shutil
		try:
			src = open(mydir + packagename + "/src/Makefile.am").read()
		except IOError:
			return

		for line in src.split("\n"):
			if line.startswith('installdir'):
				installloc = bb.data.getVar('D', d, 1) + line[13:].replace('$(libdir)',bb.data.getVar('libdir', d,1))
				try:
					shutil.rmtree(installloc)
				except:
					pass

	import logging
# 	logger = logging.getLogger("BitBake.RunQueue")
	currentlist = bb.data.getVar('PACKAGES', d, 1)
# 	logger.warning("PACKAGES %s ", currentlist)
	pkgnotwanted = open(bb.data.getVar('S', d, 1) + "/../pluginnotwanted").read()
# 	logger.warning("NOT WANTED %s ", pkgnotwanted)

	newlist = currentlist.split(" ")
	for package in pkgnotwanted.split("\n"):
		deletenotwanted(mydir, d, package.split('-'))
}

python populate_packages_prepend () {
	enigma2_plugindir = bb.data.expand('${libdir}/enigma2/python/Plugins', d)
	do_split_packages(d, enigma2_plugindir, '^(\w+/\w+)/[a-zA-Z0-9_]+.*$', 'enigma2-plugin-%s', '%s', recursive=True, match_path=True, prepend=True)
	do_split_packages(d, enigma2_plugindir, '^(\w+/\w+)/.*\.py$', 'enigma2-plugin-%s-src', '%s (source files)', recursive=True, match_path=True, prepend=True)
	do_split_packages(d, enigma2_plugindir, '^(\w+/\w+)/.*\.la$', 'enigma2-plugin-%s-dev', '%s (development)', recursive=True, match_path=True, prepend=True)
	do_split_packages(d, enigma2_plugindir, '^(\w+/\w+)/.*\.a$', 'enigma2-plugin-%s-staticdev', '%s (static development)', recursive=True, match_path=True, prepend=True)
	do_split_packages(d, enigma2_plugindir, '^(\w+/\w+)/(.*/)?\.debug/.*$', 'enigma2-plugin-%s-dbg', '%s (debug)', recursive=True, match_path=True, prepend=True)
	do_split_packages(d, enigma2_plugindir, '^(\w+/\w+)/.*\/.*\.po$', 'enigma2-plugin-%s-po', '%s (translations)', recursive=True, match_path=True, prepend=True)

	def getControlLines(mydir, d, package):
		packagename = package[-1]
		import os
		try:
			#ac3lipsync is renamed since 20091121 to audiosync.. but rename in cvs is not possible without lost of revision history..
			#so the foldername is still ac3lipsync
			if packagename == 'audiosync':
				packagename = 'ac3lipsync'
			src = open(mydir + packagename + "/CONTROL/control").read()
		except IOError:
			return
		for line in src.split("\n"):
			full_package = package[0] + '-' + package[1] + '-' + package[2] + '-' + package[3]
			if line.startswith('Depends: '):
				# some plugins still reference twisted-* dependencies, these packages are now called python-twisted-*
				depends = line[9:].replace(',', '').split(' ')
				rdepends = ''
				for depend in depends:
					if depend.startswith('twisted-'):
						rdepends += ' ' + depend.replace('twisted-', 'python-twisted-')
					else:
						rdepends += ' ' + depend
				bb.data.setVar('RDEPENDS_' + full_package, rdepends, d)
			elif line.startswith('Recommends: '):
				bb.data.setVar('RRECOMMENDS_' + full_package, line[12:], d)
			elif line.startswith('Description: '):
				bb.data.setVar('DESCRIPTION_' + full_package, line[13:], d)
			elif line.startswith('Replaces: '):
				bb.data.setVar('RREPLACES_' + full_package, ' '.join(line[10:].split(', ')), d)
			elif line.startswith('Conflicts: '):
				bb.data.setVar('RCONFLICTS_' + full_package, ' '.join(line[11:].split(', ')), d)
			elif line.startswith('Maintainer: '):
				bb.data.setVar('MAINTAINER_' + full_package, line[12:], d)

	mydir = bb.data.getVar('D', d, 1) + "/../git/"
	for package in bb.data.getVar('PACKAGES', d, 1).split():
		getControlLines(mydir, d, package.split('-'))
}
