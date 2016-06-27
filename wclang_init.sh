#!/bin/bash

function make_symlink {
	$WINDIR\\System32\\cmd.exe /C "cmd /C mklink $1 $2" > /dev/null
	ret=$?

	if [ $ret -ne 0 ]; then
		return 1
	else
		return 0
	fi
}

function symlink_success {
	echo "Symlink $1 <==> $2 ."
}

function symlink_failed {
	echo "Cannot create symlink $1 !"
	exit
}

where wclang.exe > /dev/null
ret=$?

if [ $ret -ne 0 ]; then 
	echo "Cannot find wclang in Your PATH!"
	exit
fi

WCLANG_DIR=$(dirname `where wclang`)

WCLANG="$WCLANG_DIR\\wclang.exe"
W32CLANG="$WCLANG_DIR\\w32-clang.exe"
W32CLANGCXX="$WCLANG_DIR\\w32-clang++.exe"
W64CLANG="$WCLANG_DIR\\w64-clang.exe"
W64CLANGCXX="$WCLANG_DIR\\w64-clang++.exe"

if [ ! -f $W32CLANG ]; then
	if [ ! make_symlink $W32CLANG $WCLANG ]; then
		symlink_failed $W32CLANG
	else
		symlink_success $W32CLANG $WCLANG
	fi
else
	echo "$W32CLANG exist."
fi

if [! -f $W32CLANGCXX ]; then
	if [ ! make_symlink $W32CLANGCXX $WCLANG ]; then
		symlink_failed $W32CLANGCXX
	else
		symlink_success $W32CLANGCXX $WCLANG
	fi
fi

if [! -f $W64CLANG ]; then
	if [! make_symlink $W64CLANG $WCLANG ]; then
		symlink_failed $W64CLANG
	else
		symlink_success $W64CLANG $WCLANG
	fi
fi

if [! -f $W64CLANGCXX ]; then
	if [! make_symlink $W64CLANGCXX $WCLANG ]; then
		symlink_failed $W64CLANGCXX
	else
		symlink_success $W64CLANGCXX $WCLANG
	fi
fi

echo "Creating symlinks for wclang.exe..."


for i in "$@"
do
	WCLANG_SYM="$WCLANG_DIR\\$i-clang.exe"
	WCLANG_SYMCXX="$WCLANG_DIR\\$i-clang++.exe"

	if [! -f $WCLANG_SYM ]; then
		if [ ! make_symlink $WCLANG_SYM $WCLANG ]; then
			symlink_failed $WCLANG_SYM
		else
			symlink_success $WCLANG_SYM $WCLANG
		fi
	fi

	if [! -f $WCLANG_SYMCXX ]; then
		if [ ! make_symlink $WCLANG_SYMCXX $WCLANG ]; then
			symlink_failed $WCLANG_SYMCXX
		else
			symlink_success $WCLANG_SYMCXX $WCLANG
		fi
	fi
done