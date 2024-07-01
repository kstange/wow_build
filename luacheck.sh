#!/bin/bash
BASE=`pwd`/`dirname $0`
if [[ -d $1 ]] ; then
  DIR=$1
else
  DIR=`pwd`
fi
DIRS="${DIR}/*.lua"
if [[ -d ${DIR}/Locales/ ]] ; then
  DIRS="${DIRS} ${DIR}/Locales/*.lua"
fi
${BASE}/lua_modules/bin/luacheck ${DIRS} --config ${BASE}/.luacheckrc
