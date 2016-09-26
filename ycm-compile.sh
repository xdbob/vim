#!/bin/bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd $BASEDIR

if [ ! -e bundle/YouCompleteMe/install.py ]; then
	echo YouCompleteMe not found...
	echo Have you run \"git submodule update --init --recursive\" ?
	exit 1;
fi
echo YouCompleteMe found.

cd bundle/YouCompleteMe

ARGS="--clang-completer"

echo -n "Is mono present ? "
which xbuild > /dev/null && which mono > /dev/null
if [ $? -eq 0 ]; then
	echo "yes"
	ARGS="${ARGS} --omnisharp-completer"
else
	echo "no"
fi

echo -n "Is go present ? "
which go > /dev/null
if [ $? -eq 0 ]; then
	echo "yes"
	ARGS="${ARGS} --gocode-completer"
else
	echo "no"
fi

echo -n "Is clang present ? "
which clang > /dev/null
if [ $? -eq 0 ]; then
	echo "yes"
	ARGS="${ARGS} --system-libclang"
else
	echo "no"
fi

REV=$(git rev-parse HEAD)
BFILE="$BASEDIR/.ycm_build"
if [ -f "$BFILE" -a "$1" != "-f" ]; then
	OPTS=$(tail -n 1 $BFILE)
	REV_FILE=$(head -n 1 $BFILE)
	if [ "$REV" = "$REV_FILE" -a "$OPTS" = "$ARGS" ]; then
		echo "Nothing to do..."
		exit 0
	fi
fi

rm -f "$BFILE"
python2 install.py $ARGS
ERR=$?

if [ $ERR -eq 0 ]; then
	echo $REV > $BFILE
	echo $ARGS >> $BFILE
fi

exit $ERR
