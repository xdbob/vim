#!/bin/sh

if [ ! -d bundle/YouCompleteMe ]; then
  echo YouCompleteMe not found...
  echo Have you run \"git submodule update --init --recursive\" ?
  exit 1;
fi
echo YouCompleteMe found.

cd bundle/YouCompleteMe
python2 install.py --clang-completer --omnisharp-completer --gocode-completer

exit $?
