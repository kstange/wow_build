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
${BASE}/packager/release.sh -dz -t ${DIR}
if [[ $? -ne 0 ]] ; then
  echo "ERROR: Failed to complete build! Giving up..."
  exit
fi
CLIENTS="retail ptr xptr beta"
VERSIONS=$(grep "## Interface:" ${DIR}/${ADDON}.toc | cut -d':' -f2 | tr -d '[:space:]' | sed 's/[0-9]\{4\}\(,\|$\)/\n/g' | sort -u)
for VERSION in ${VERSIONS}; do
  echo $CLIENTS | grep -q -v "\bclassic\b"; CLASSIC_ALREADY=$?
  echo $CLIENTS | grep -q -v "\bclassic_era\b"; CLASSIC_ERA_ALREADY=$?
  if [[ ${VERSION} -lt 2 && ${CLASSIC_ERA_ALREADY} -eq 0 ]] ; then
    echo "Adding Classic Era clients..."
    CLIENTS="${CLIENTS} classic_era classic_era_ptr"
  elif [[ ${VERSION} -ge 2 && ${VERSION} -lt 11 && ${CLASSIC_ALREADY} -eq 0 ]] ; then
    echo "Adding Classic clients..."
    CLIENTS="${CLIENTS} classic classic_ptr classic_beta"
  fi
done
for CLIENT in ${CLIENTS}; do
  if [[ -d ${BASE}/_${CLIENT}_ ]] ; then
    echo "Installing ${ADDON} for ${CLIENT}..."
    rm -rf ${BASE}/_${CLIENT}_/Interface/Addons/${ADDON}/
    cp -ax ${DIR}/.release/${ADDON} ${BASE}/_${CLIENT}_/Interface/Addons/
  else
    echo "Skipping ${CLIENT} because it isn't available..."
  fi
done
