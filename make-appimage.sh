#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q plus42 | awk '{print $2; exit}') # example command to get version of application here
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export DESKTOP=/usr/share/applications/plus42.desktop
export STARTUPWMCLASS=plus42
export DEPLOY_GTK=1
export GTK_DIR=gtk-3.0
export ALWAYS_SOFTWARE=1

# Deploy dependencies
quick-sharun /usr/bin/plus42

# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --test ./dist/*.AppImage
