#!/bin/bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$BASEDIR" || exit 2

if [ ! -e bundle/YouCompleteMe/install.py ]; then
	echo YouCompleteMe not found...
	echo "Have you run \"git submodule update --init --recursive\" ?"
	exit 1;
fi
echo YouCompleteMe found.

cd bundle/YouCompleteMe || exit 2

ARGS="--clang-completer"

echo -n "Is mono present ? "
if which xbuild > /dev/null && which mono > /dev/null; then
	echo "yes"
	ARGS="${ARGS} --omnisharp-completer"
else
	echo "no"
fi

echo -n "Is go present ? "
if which go > /dev/null; then
	echo "yes"
	ARGS="${ARGS} --gocode-completer"
else
	echo "no"
fi

echo -n "Is clang present ? "
if which clang > /dev/null; then
	echo "yes"
	ARGS="${ARGS} --system-libclang"
else
	echo "no"
fi

REV=$(git rev-parse HEAD)
BFILE="$BASEDIR/.ycm_build"
if [ -f "$BFILE" ] && [ "$1" != "-f" ]; then
	OPTS=$(tail -n 1 "$BFILE")
	REV_FILE=$(head -n 1 "$BFILE")
	if [ "$REV" = "$REV_FILE" ] && [ "$OPTS" = "$ARGS" ]; then
		echo "Nothing to do..."
		exit 0
	fi
fi

rm -f "$BFILE"
eval "python2 install.py $ARGS"
ERR=$?

if [ $ERR -eq 0 ]; then
	echo "$REV" > "$BFILE"
	echo "$ARGS" >> "$BFILE"
fi

exit $ERR
