#!/bin/bash
# Takes 1 argument - which is the cmake install prefix
BASEDIR=$(dirname $0)
"${BASEDIR}/../construct/MantidPython-0.1.0-MacOSX-x86_64.sh" -u -b -p "$1/MWindowApp.app/Contents/Resources/mantid_python"

exit 0