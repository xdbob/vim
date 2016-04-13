#!/bin/bash

checkfail() {
	ret=$?

	if [ $ret != 0 ]; then
		echo "> FAILED"
		exit $ret
	fi
}

echo Updating submodules.
git submodule update --init --recursive
checkfail

echo Installing h2cppx dependancies.
bash ./h2cppx-postinstall.sh
checkfail
echo "> Done."

echo Compiling YouCompleteMe...
bash ./ycm-compile.sh
checkfail

echo Linking to vimrc to ~/.vimrc
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
if [ -z $dir ]; then
	echo Could not detect vimrc directory
	exit 1
fi
rm -f $HOME/.vimrc
checkfail
ln -s $dir/vimrc $HOME/.vimrc
checkfail

exit 0
