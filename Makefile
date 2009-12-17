#!/bin/bash

VIM_NAME=vimgdb
VIM_DIR=vim72
VIMGDB_DIR=vimgdb

VIMDEBBUILD_DIR=vimgdb-72

CFLAGS="-O3 -D_FORTIFY_SOURCE=1"
EXTRA_OPTIONS='--with-vim-name=$(VIM_NAME) --disable-selinux --disable-acl --enable-gdb --disable-gtktest --disable-gui" dpkg-buildpackage -rfakeroot'

clean:
		rm -rf $(VIMDEBBUILD_DIR)
		rm -rf $(VIM_DIR)
		rm -rf $(VIMGDB_DIR)

deb:
		sudo apt-get build-dep vim-gnome
		wget -c ftp://ftp.vim.org/pub/vim/unix/vim-7.2.tar.bz2
		tar xvf vim-7.2.tar.bz2
		mv $(VIM_DIR) $(VIMDEBBUILD_DIR)
		wget -c "http://downloads.sourceforge.net/project/clewn/vimGdb/vimgdb72-1.14/vimgdb72-1.14.tar.gz?use_mirror=nchc"
		tar xvf vimgdb72-1.14.tar.gz
		patch -d $(VIMDEBBUILD_DIR) --backup -p0 < $(VIMGDB_DIR)/vim72.diff
		mkdir -p vimgdb-runtime/
		tar xvf $(VIMGDB_DIR)/vimgdb_runtime.tgz -C vimgdb-runtime/
		rsync -rv vimgdb-runtime/ $(VIMDEBBUILD_DIR)/runtime/
# XXX: compiling vim from source on ubuntu needs the CFLAGS
		cp -r debian $(VIMDEBBUILD_DIR)/
		sh -c 'cd $(VIMDEBBUILD_DIR) ; CFLAGS=$(CFLAGS) EXTRA_OPTIONS=$(EXTRA_OPTIONS) dpkg-buildpackage -rfakeroot'
