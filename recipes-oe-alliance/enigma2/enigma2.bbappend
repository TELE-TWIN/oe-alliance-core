FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

PRINC = "41"

DEPENDS = " \
	ethtool \
	freetype \
	gettext-native \
	gst-plugins-base gstreamer \
	hotplug-e2-helper \
	jpeg \
	libdreamdvd libdvbsi++ libfribidi libmad libpng libsigc++-1.2 libungif libxml2 libxmlccwrap \
	openssl \
	python python-imaging python-twisted python-wifi \
	swig-native \
	tuxtxt-enigma2 \
	"

RDEPENDS_${PN} = " \
	alsa-conf \
	enigma2-fonts \
	ethtool \
	glibc-gconv-iso8859-15 \
	hotplug-e2-helper \
	${PYTHON_RDEPS} \
	"

RRECOMMENDS_${PN} = " \
	gst-plugin-subsink \
	${GST_BASE_RDEPS} \
	${GST_GOOD_RDEPS} \
	${GST_BAD_RDEPS} \
	${GST_UGLY_RDEPS} \
	"

PYTHON_RDEPS += " \
	python-email \
	python-mime \
	python-pyusb \
	python-subprocess \
	python-process \
	"

# We depend on the font which we use for TXT subtitles (defined in skin_subtitles.xml)
RDEPENDS_${PN} += "font-valis-enigma"

RDEPENDS_${PN} += "${@base_contains("MACHINE_FEATURES", "blindscan-dvbc", "virtual/blindscan-dvbc" , "", d)}"

#make sure default skin is installed.
RDEPENDS_${PN} += "${E2DEFAULTSKIN} "

PV = "2.8+git${SRCPV}"
PKGV = "2.8+git${GITPKGV}"
SRC_URI = "${ENIGMA2_URI}"

SRC_URI_append_vuduo = " \
			file://duo_VFD.patch \
			"
SRC_URI_append_gb800solo = " \
			file://gb800-evfd.patch \
			"
SRC_URI_append_gb800se = " \
			file://gb800-evfd.patch \
			"
SRC_URI_append_gb800ue = " \
			file://gb800-evfd.patch \
			"

FILES_${PN} += " ${bindir} ${sysconfdir}/e2-git.log"

PV_font-valis-enigma = "2009.11.12"
PR_font-valis-enigma = "r2"
PKGV_font-valis-enigma = "${PV_font-valis-enigma}"
DESCRIPTION_font-valis-enigma = "Valis enigma font"

PACKAGES =+ " font-valis-enigma"
PROVIDES =+ " font-valis-enigma"
FILES_font-valis-enigma = "/usr/share/fonts/valis_enigma.ttf"

# Save po files
PACKAGES =+ "${PN}-po"
FILES_${PN}-po = "${datadir}/enigma2/po/*.po ${datadir}/enigma2/po/*.pot"

EXTRA_OECONF += "\
	--with-po \
	${@base_contains("MACHINE_FEATURES", "fullgraphiclcd", "--with-fullgraphiclcd" , "", d)} \
	${@base_contains("MACHINE_FEATURES", "gigabluelcd", "--with-gigabluelcd" , "", d)} \
	${@base_contains("MACHINE_FEATURES", "colorlcd220", "--with-colorlcd220" , "", d)} \
	${@base_contains("MACHINE_FEATURES", "bwlcd255", "--with-bwlcd255" , "", d)} \
	"

# some plugins contain so's, their stripped symbols should not end up in the enigma2 package
FILES_${PN}-dbg += "\
	/usr/lib/enigma2/python/*/.debug \
	/usr/lib/enigma2/python/*/*/*.debug \
	/usr/lib/enigma2/python/*/*/*/.debug \
	/usr/lib/enigma2/python/*/*/*/*/.debug \
	"

FILES_${PN}-src += "\
	/usr/lib/enigma2/python/upgrade.py \
	/usr/lib/enigma2/python/PowerTimer.py \
	"

def enigma2changeword(file):
	fn = file[:-1]
	os.system('sed -i "s/STB_BOX/' + MACHINE1 + '/g" ' + fn)
	os.system('sed -i "s/STB-BOX/' + MACHINE1 + '/g" ' + fn)
	os.system('sed -i "s/STB-GUI/Receiver/g" ' + fn)

do_patch_prepend(){
	global MACHINE1
	MACHINE1="Dreambox"
	if "${MACHINE}" == "vuuno":
		MACHINE1="Vu+ Uno"
	elif "${MACHINE}" == "vuultimo":
		MACHINE1="Vu+ Ultimo"
	elif "${MACHINE}" == "vusolo":
		MACHINE1="Vu+ Solo"
	elif "${MACHINE}" == "vusolo2":
		MACHINE1="Vu+ Solo2"
	elif "${MACHINE}" == "vuduo":
		MACHINE1="Vu+ Duo"
	elif "${MACHINE}" == "vuduo2":
		MACHINE1="Vu+ Duo2"
	elif "${MACHINE}" == "et4x00":
		MACHINE1="Xtrend ET4x00"
	elif "${MACHINE}" == "et5x00":
		MACHINE1="Xtrend ET5x00"
	elif "${MACHINE}" == "et6x00":
		MACHINE1="Xtrend ET6x00"
	elif "${MACHINE}" == "et9x00":
		MACHINE1="Xtrend ET9x00"
	elif "${MACHINE}" == "odinm9":
		MACHINE1="Odin M9"
	elif "${MACHINE}" == "gb800solo":
		MACHINE1="GigaBlue HD 800 Solo"
	elif "${MACHINE}" == "gb800se":
		MACHINE1="GigaBlue HD 800 SE"
	elif "${MACHINE}" == "gb800ue":
		MACHINE1="GigaBlue HD 800 UE"
	elif "${MACHINE}" == "gbquad":
		MACHINE1="GigaBlue HD Quad"
	elif "${MACHINE}" == "tmtwin" or "${MACHINE}" == "tm2t" or "${MACHINE}" == "tmsingle":
		MACHINE1="Technomate"
	elif "${MACHINE}" == "ventonhdx":
		if "${DISTRO}" == "ventonsupport" or "${DISTRO}" == "egami" or "${DISTRO}" == "sezamsupport":
			MACHINE1="linux box"
		else:
			MACHINE1="Venton HDx"
	elif "${MACHINE}" == "ventonhde":
		if "${DISTRO}" == "ventonsupport" or "${DISTRO}" == "egami" or "${DISTRO}" == "sezamsupport":
			MACHINE1="linux box"
		else:
			MACHINE1="Venton HDe"
	elif "${MACHINE}" == "xp1000":
		if "${DISTRO}" == "mkdigital" or "${DISTRO}" == "openaaf":
			MACHINE1="MK-Digital XP1000"
		else:
			MACHINE1="MaxDigital XP1000"
	elif "${MACHINE}" == "ebox5000":
		MACHINE1="MixOS F5"
	elif "${MACHINE}" == "odinm7":
		MACHINE1="Odin M7"
	elif "${MACHINE}" == "ixussone":
		MACHINE1="IXUSS ONE"	
	import os
	os.system("find ./ -name \"*.po\" > ./po_list")
	os.system("find ./ -name \"*.py\" >> ./po_list")
	os.system("find ./ -name \"*.xml\" >> ./po_list")
	po_list = []
	po_list = open('po_list','r+').readlines()
	for x in po_list:
		enigma2changeword(x)
	os.system('rm po_list')
}

def enigma2changeword2(file):
	fn = file[:-1]
	os.system('sed -i "s/' + MACHINE1 + '/STB_BOX/g" ' + fn)

python do_setup_po_ipk () {
	global MACHINE1
	MACHINE1="Dreambox"
	if "${MACHINE}" == "vuuno":
		MACHINE1="Vu+ Uno"
	elif "${MACHINE}" == "vuultimo":
		MACHINE1="Vu+ Ultimo"
	elif "${MACHINE}" == "vusolo":
		MACHINE1="Vu+ Solo"
	elif "${MACHINE}" == "vusolo2":
		MACHINE1="Vu+ Solo2"
	elif "${MACHINE}" == "vuduo":
		MACHINE1="Vu+ Duo"
	elif "${MACHINE}" == "vuduo2":
		MACHINE1="Vu+ Duo2"
	elif "${MACHINE}" == "et4x00":
		MACHINE1="Xtrend ET4x00"
	elif "${MACHINE}" == "et5x00":
		MACHINE1="Xtrend ET5x00"
	elif "${MACHINE}" == "et6x00":
		MACHINE1="Xtrend ET6x00"
	elif "${MACHINE}" == "et9x00":
		MACHINE1="Xtrend ET9x00"
	elif "${MACHINE}" == "odinm9":
		MACHINE1="Odin M9"
	elif "${MACHINE}" == "gb800solo":
		MACHINE1="GigaBlue HD 800 Solo"
	elif "${MACHINE}" == "gb800se":
		MACHINE1="GigaBlue HD 800 SE"
	elif "${MACHINE}" == "gb800ue":
		MACHINE1="GigaBlue HD 800 UE"
	elif "${MACHINE}" == "gbquad":
		MACHINE1="GigaBlue HD Quad"
	elif "${MACHINE}" == "tmtwin" or "${MACHINE}" == "tm2t" or "${MACHINE}" == "tmsingle":
		MACHINE1="Technomate"
	elif "${MACHINE}" == "ventonhdx":
		MACHINE1="Venton HD"
	elif "${MACHINE}" == "ventonhde":
		MACHINE1="Venton HDe"
	elif "${MACHINE}" == "xp1000":
		if "${DISTRO}" == "mkdigital" or "${DISTRO}" == "openaaf":
			MACHINE1="MK-Digital XP1000"
		else:
			MACHINE1="MaxDigital XP1000"
	elif "${MACHINE}" == "ebox5000":
		MACHINE1="MixOS F5"
	elif "${MACHINE}" == "odinm7":
		MACHINE1="Odin M7"
	elif "${MACHINE}" == "ixussone":
		MACHINE1="IXUSS ONE"	
	import os
	os.system("find ./ -name \"*.po\" > ./po_list")
	os.system("find ./ -name \"*.py\" >> ./po_list")
	os.system("find ./ -name \"*.xml\" >> ./po_list")
	po_list = []
	po_list = open('po_list','r+').readlines()
	for x in po_list:
		enigma2changeword2(x)
	os.system('rm po_list')
}

do_openpli_preinstall() {
	if [ -e ${S}/data/${RADIOMVI} ]; then
		ln -f ${S}/data/${RADIOMVI} ${S}/data/radio.mvi
		install -d ${D}${sysconfdir}/enigma2
	fi
}

do_install_append() {
	install -d ${D}/usr/share/keymaps
	find ${D}/usr/lib/enigma2/python/ -name '*.pyc' -exec rm {} \;
	ln -s /usr/lib/enigma2/python/Tools/StbHardware.pyo ${D}/usr/lib/enigma2/python/Tools/DreamboxHardware.pyo
	ln -s /usr/lib/python/Components/PackageInfo.pyo ${D}/usr/lib/enigma2/python/Components/DreamboxInfoHandler.pyo
	install -d ${D}${sysconfdir}
	git --git-dir=${S}/.git log --since=10.weeks --pretty=format:"%s" > ${D}${sysconfdir}/e2-git.log
	git --git-dir=${OE-ALLIANCE_BASE}/meta-oe-alliance/.git log --since=10.weeks --pretty=format:"%s" > ${D}${sysconfdir}/oe-git.log
}

do_install_po() {
	LANGS="ar bg ca cs da de el en en_GB es et fa fi fr fy he hr hu is it lt lv nl no nb pl pt pt_BR ro ru sv sk sl sr th tr uk"
	for lang in ${LANGS}; do
		if [ -e ${S}/po/$lang.po ]; then
			install -m 0755 ${S}/po/$lang.po ${D}${datadir}/enigma2/po/enigma2-$lang.po
		fi
	done
	install -m 0755 ${S}/po/enigma2.pot ${D}${datadir}/enigma2/po/enigma2.pot
}

addtask setup_po_ipk before do_package after do_install
addtask install_po before do_package after do_setup_po_ipk

python populate_packages_prepend() {
	enigma2_plugindir = bb.data.expand('${libdir}/enigma2/python/Plugins', d)
	do_split_packages(d, enigma2_plugindir, '^(\w+/\w+)/[a-zA-Z0-9_]+.*$', 'enigma2-plugin-%s', '%s', recursive=True, match_path=True, prepend=True, extra_depends="enigma2")
	do_split_packages(d, enigma2_plugindir, '^(\w+/\w+)/.*\.py$', 'enigma2-plugin-%s-src', '%s (source files)', recursive=True, match_path=True, prepend=True)
	do_split_packages(d, enigma2_plugindir, '^(\w+/\w+)/.*\.la$', 'enigma2-plugin-%s-dev', '%s (development)', recursive=True, match_path=True, prepend=True)
	do_split_packages(d, enigma2_plugindir, '^(\w+/\w+)/.*\.a$', 'enigma2-plugin-%s-staticdev', '%s (static development)', recursive=True, match_path=True, prepend=True)
	do_split_packages(d, enigma2_plugindir, '^(\w+/\w+)/(.*/)?\.debug/.*$', 'enigma2-plugin-%s-dbg', '%s (debug)', recursive=True, match_path=True, prepend=True)
}
