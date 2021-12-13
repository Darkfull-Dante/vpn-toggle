#!/bin/bash

SCRIPT_DIR="$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
INSTALL_DIR="/home/$USER/.local/share/plasma/plasmoids"
APP_NAME="com.darkfulldante.plasma.vpn-toggle"

rm -r "${INSTALL_DIR:?}/${APP_NAME:?}"
cp -r "${SCRIPT_DIR:?}/${APP_NAME:?}" "${INSTALL_DIR:?}/"
