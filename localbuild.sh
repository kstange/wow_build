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
echo "Building addon ${ADDON}..."
${BASE}/packager/release.sh -dz -t ${DIR}
if [[ $? -ne 0 ]] ; then
  echo "ERROR: Failed to complete build! Giving up..."
  exit
fi
CLIENTS="retail ptr xptr"
if [[ -e ${DIR}/${ADDON}_Vanilla.toc ]] ; then
  echo "Adding Classic Era clients..."
  CLIENTS="${CLIENTS} classic_era classic_era_ptr"
fi
if [[ -e ${DIR}/${ADDON}_Wrath.toc ]] ; then
  echo "Adding Wrath Classic clients..."
  CLIENTS="${CLIENTS} classic classic_ptr"
fi
if [[ -e ${DIR}/${ADDON}_Cata.toc ]] ; then
  echo "Adding Cata Classic clients..."
  CLIENTS="${CLIENTS} classic_beta"
fi
for CLIENT in ${CLIENTS}; do
  if [[ -d ${BASE}/_${CLIENT}_ ]] ; then
    echo "Installing ${ADDON} for ${CLIENT}..."
    rm -rf ${BASE}/_${CLIENT}_/Interface/Addons/${ADDON}/
    cp -ax ${DIR}/.release/${ADDON} ${BASE}/_${CLIENT}_/Interface/Addons/
  else
    echo "Skipping ${CLIENT} because it isn't available..."
  fi
done
