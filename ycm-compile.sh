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
if which xbuild &> /dev/null && which mono &> /dev/null; then
	echo "yes"
	ARGS="${ARGS} --cs-completer"
else
	echo "no"
fi

echo -n "Is go present ? "
if which go &> /dev/null; then
	echo "yes"
	ARGS="${ARGS} --gocode-completer"
else
	echo "no"
fi

echo -n "Is clangd present ? "
if which clangd &> /dev/null; then
	echo "yes"
	ARGS="${ARGS} --clangd-completer"
else
	echo "no"
fi

if which clang &>/dev/null; then
	CLANG_VERSION="$(clang --version | head -n 1 | cut -d' ' -f 3)"
else
	CLANG_VERSION="0"
fi

echo -n "Is clang7 present ? "
if [ "$(cut -d'.' -f 1 <<< "${CLANG_VERSION}")" -ge "7" ]; then
	echo "yes"
	ARGS="${ARGS} --system-libclang"
else
	echo "no"
fi

echo -n "Is RUST present ? "
if which rustc cargo &> /dev/null; then
	echo "yes"
	ARGS="${ARGS} --rust-completer"
else
	echo "no"
fi

should_update() {
	REV="$(git rev-parse HEAD)"
	REV="${REV}+${CLANG_VERSION}"
	REV="${REV}+$(python -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')"
	BFILE="$BASEDIR/.ycm_build"
	if [ -f "$BFILE" ] && [ "$1" != "-f" ]; then
		OPTS=$(tail -n 1 "$BFILE")
		REV_FILE=$(head -n 1 "$BFILE")
		if [ "$REV" = "$REV_FILE" ] && [ "$OPTS" = "$ARGS" ]; then
			return 1
		fi
	fi
	return 0
}

if ! should_update $@; then
	echo "Nothing do do..."
	exit 0
fi

rm -f "$BFILE"
eval "python3 install.py $ARGS"
ERR=$?

if [ $ERR -eq 0 ]; then
	echo "$REV" > "$BFILE"
	echo "$ARGS" >> "$BFILE"
fi

exit $ERR
