#!/bin/bash

PKG=stormgears-opencv
PKGVER=3.1.0.7
PKGREL=1
GITURL=https://github.com/Itseez/opencv
GITURL2=https://github.com/Itseez/opencv_contrib

. /etc/os-release
dist=$ID$VERSION_ID
codename=$VERSION_CODENAME
[ -z "$codename" ] && codename=$(echo $VERSION | sed 's/.*(\(.*\)).*/\1/')

WD=$(dirname $0)
[ "$WD" == "." ] && WD=$PWD

rm -rf $WD/work
mkdir $WD/work
cd $WD/work
if [ -e "$WD/opencv.git.tar.gz" ]; then
  tar xzf $WD/opencv.git.tar.gz
else
  git clone $GITURL
  tar czf $WD/opencv.git.tar.gz opencv
fi
if [ -e "$WD/opencv_contrib.git.tar.gz" ]; then
  tar xzf $WD/opencv_contrib.git.tar.gz
else
  git clone $GITURL2
  tar czf $WD/opencv_contrib.git.tar.gz opencv_contrib
fi

cd $WD/work/opencv
git checkout 3.1.0
cd $WD/work/opencv_contrib
git checkout 3.1.0

rm -rf $WD/work/opencv/.git
rm -rf $WD/work/opencv_contrib/.git

mv $WD/work/opencv $WD/work/${PKG}-${PKGVER}
mv $WD/work/opencv_contrib $WD/work/${PKG}-${PKGVER}/
cp -r $WD/deb $WD/work/${PKG}-${PKGVER}/debian
if [ -e "$WD/work/${PKG}-${PKGVER}/debian/control.$ID" ]; then
  mv "$WD/work/${PKG}-${PKGVER}/debian/control.$ID" \
     "$WD/work/${PKG}-${PKGVER}/debian/control"
fi
cp -r $WD/profile.pkg $WD/work/${PKG}-${PKGVER}/stormgears-opencv.sh
cd $WD
 
cat > $WD/work/${PKG}-${PKGVER}/debian/changelog <<EOF
$PKG (${PKGVER}-${PKGREL}.$dist) $codename; urgency=medium

  * Automatically generated

 -- W. Mark Smith <wmsmith@gmail.com>  $(date -R)
EOF
tar -C work -czf work/${PKG}_${PKGVER}.orig.tar.gz ${PKG}-${PKGVER}

cat <<EOF
Source files are prepared. You have two options:
(1) Build deb package:
  cd $WD/work/${PKG}-${PKGVER} && dpkg-buildpackage -us -uc -b
(2) Prepare upload for PPA:
  cd $WD/work/${PKG}-${PKGVER} && dpkg-buildpackage -S
EOF

cd $WD

