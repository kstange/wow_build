#!/bin/bash
BASE=`pwd`/`dirname $0`
if [[ -d $1 ]] ; then
  DIR=$1
else
  DIR=`pwd`
fi
ADDON=`grep -s package-as ${DIR}/.pkgmeta | cut -d' ' -f2`
if [[ ${ADDON} == "" ]] ; then
  echo "ERROR: Addon name is not known! Bailing out..."
  exit
fi
echo "Checking addon ${ADDON}..."
`dirname $0`/luacheck.sh ${DIR}
if [[ $? -gt 1 ]] ; then
  echo "ERROR: LUA Check failed! Please fix errors and rebuild..."
  exit
fi
echo
echo "Building addon ${ADDON}..."
${BASE}/packager/release.sh -d -t ${DIR}
if [[ $? -ne 0 ]] ; then
  echo "ERROR: Failed to complete build! Giving up..."
  exit
fi
INTERFACE_MAJOR_MINOR_VERSIONS=$(grep "## Interface:" ${DIR}/${ADDON}.toc | cut -d':' -f2 | tr -d '[:space:]' | sed 's/[0-9]\{2\}\(,\|$\)/\n/g;' | sort -u -n)
CLIENTS=""
for CLIENT_DIR in $(basename -a ${BASE}/_*_); do
  CLIENT=${CLIENT_DIR:1:-1}
  WINDOWS_PATH=$(wslpath -w ${BASE}/${CLIENT_DIR})
  CLIENT_VERSION=$(powershell.exe \(Get-Item -Path \"${WINDOWS_PATH}\\Wow*.exe\"\).VersionInfo.FileVersion)
  CLIENT_MAJOR_VERSION=$(echo $CLIENT_VERSION | cut -d. -f1)
  CLIENT_MINOR_VERSION=$(echo $CLIENT_VERSION | cut -d. -f2)
  CLIENT_MAJOR_MINOR_VERSION=$(printf "%d%02d" ${CLIENT_MAJOR_VERSION} ${CLIENT_MINOR_VERSION})
  if [[ $( echo "${INTERFACE_MAJOR_MINOR_VERSIONS}" | grep "\b${CLIENT_MAJOR_MINOR_VERSION}" ) ]] ; then
    echo "Adding ${CLIENT} (${CLIENT_MAJOR_VERSION}.${CLIENT_MINOR_VERSION}.x)..."
    CLIENTS="${CLIENTS} ${CLIENT}"
  elif [[ ${CLIENT_VERSION} == "" ]] ; then
    echo "Skipping ${CLIENT} (not found)..."
  else
    echo "Skipping ${CLIENT} (${CLIENT_MAJOR_VERSION}.${CLIENT_MINOR_VERSION}.x)..."
  fi
done

for CLIENT in ${CLIENTS}; do
  if [[ -d ${BASE}/_${CLIENT}_ ]] ; then
    echo "Installing ${ADDON} for ${CLIENT}..."
    mkdir -p ${BASE}/_${CLIENT}_/Interface/Addons/
    rm -rf ${BASE}/_${CLIENT}_/Interface/Addons/${ADDON}/
    cp -ax ${DIR}/.release/${ADDON} ${BASE}/_${CLIENT}_/Interface/Addons/
  else
    echo "Skipping ${CLIENT} because it isn't available..."
  fi
done
