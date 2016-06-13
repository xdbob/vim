#!/bin/sh

if [ ! -e bundle/YouCompleteMe/install.py ]; then
	echo YouCompleteMe not found...
	echo Have you run \"git submodule update --init --recursive\" ?
	exit 1;
fi
echo YouCompleteMe found.

cd bundle/YouCompleteMe

ARGS="--clang-completer"

echo -n "Is mono present ? "
which mono > /dev/null
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

python2 install.py $ARGS

exit $?
