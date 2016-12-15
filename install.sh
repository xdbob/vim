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
./h2cppx-postinstall.sh
checkfail
echo "> Done."

echo Compiling YouCompleteMe...
./ycm-compile.sh
checkfail

echo Linking to vimrc to ~/.vimrc
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
if [ -z "$dir" ]; then
	echo Could not detect vimrc directory
	exit 1
fi
rm -f "$HOME/.vimrc"
checkfail
ln -s "$dir/init.vim" "$HOME/.vimrc"
checkfail

echo Installing vim-go
vim -c GoInstallBinaries -c q
checkfail

echo Linkging current dir to ~/.config/nvim
mkdir -p "$HOME/.config"
checkfail
ln -s "$dir" "$HOME/.config/nvim"
checkfail

exit 0
