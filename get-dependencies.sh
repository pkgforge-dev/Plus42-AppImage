#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
# pacman -Syu --noconfirm PACKAGESHERE

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

echo "Building Plus42..."
echo "---------------------------------------------------------------"
REPO="https://thomasokken.com/plus42"
VERSION=1.3.15
curl -fLo "plus42-upstream-$VERSION.tgz" "$REPO/upstream/plus42-upstream-$VERSION.tgz"
tar -xzf "plus42-upstream-$VERSION.tgz"
echo "$VERSION" > ~/version

mkdir -p ./AppDir/bin
mkdir -p ./AppDir/share/plus42/skins
cd "plus42-upstream-$VERSION/gtk"

# build both bin and dec version
make cleaner
make
make clean
make BCD_MATH=1
mv -v plus42bin ../AppDir/bin
mv -v plus42dec ../AppDir/bin/plus42

cd ../skins
for x in Plus42.* README.txt; do
    cp "$x" ../../AppDir/share/plus42/skins
done
