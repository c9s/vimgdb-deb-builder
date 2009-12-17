#!/bin/bash
VIM_NAME=vimgdb
VIM_DIR=vim72

VIMGDB_DIR=vimgdb

VIMDEBBUILD_DIR=vimgdb-72

CFLAGS="-O3 -D_FORTIFY_SOURCE=1"
EXTRA_OPTIONS="--with-vim-name=$(VIM_NAME) \
	--disable-selinux \
	--enable-cscope --enable-multibyte --disable-acl --enable-gdb --disable-gtktest --disable-gui"

VIM_SOURCE_FILENAME=vim-7.2.tar.bz2
VIMGDB_FILENAME=vimgdb72-1.14.tar.gz


clean-build:
		rm -rf $(VIMDEBBUILD_DIR)
		rm -rf $(VIM_DIR)
		rm -rf $(VIMGDB_DIR)
		rm -rf *.deb
		rm -rf vimgdb_72*

build-deps:
		sudo apt-get build-dep vim-gnome
		sudo apt-get install dh-make build-essential autotools-dev fakeroot

clean:
		rm -rf $(VIMDEBBUILD_DIR)
		rm -rf $(VIM_DIR)
		rm -rf $(VIMGDB_DIR)
		rm -rf *.deb
		rm -rf vimgdb_72*
		rm -rf vimgdb-runtime/
		rm $(VIM_SOURCE_FILENAME)
		rm $(VIMGDB_FILENAME)
deb: clean-build build-deps
		echo $(EXTRA_OPTIONS)
		wget -c ftp://ftp.vim.org/pub/vim/unix/vim-7.2.tar.bz2 -O $(VIM_SOURCE_FILENAME)
		tar xvf $(VIM_SOURCE_FILENAME)
		mv $(VIM_DIR) $(VIMDEBBUILD_DIR)
		wget -c "http://downloads.sourceforge.net/project/clewn/vimGdb/vimgdb72-1.14/vimgdb72-1.14.tar.gz?use_mirror=nchc" \
				-O $(VIMGDB_FILENAME)
		tar xvf $(VIMGDB_FILENAME)
		patch -d $(VIMDEBBUILD_DIR) --backup -p0 < $(VIMGDB_DIR)/vim72.diff
		mkdir -p vimgdb-runtime/
		tar xvf $(VIMGDB_DIR)/vimgdb_runtime.tgz -C vimgdb-runtime/
		rsync -rv vimgdb-runtime/ $(VIMDEBBUILD_DIR)/runtime/
# XXX: compiling vim from source on ubuntu needs the CFLAGS
		cp -r debian $(VIMDEBBUILD_DIR)/
		sh -c 'cd $(VIMDEBBUILD_DIR) ; CFLAGS=$(CFLAGS) EXTRA_OPTIONS=$(EXTRA_OPTIONS) dpkg-buildpackage -us -uc -rfakeroot'
