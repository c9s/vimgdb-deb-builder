#!/bin/bash
NAME=vimgdb

sudo apt-get build-deps vim-common

VERSION=7.2
PATCH_VERSION=72-1.14

wget -c ftp://ftp.vim.org/pub/vim/unix/vim-7.2.tar.bz2
tar xvf vim-7.2.tar.bz2

wget -c "http://downloads.sourceforge.net/project/clewn/vimGdb/vimgdb72-1.14/vimgdb72-1.14.tar.gz?use_mirror=nchc"
tar xvf vimgdb72-1.14.tar.gz

patch -d vim72 --backup -p0 < vimgdb/vim72.diff

mkdir vimgdb-runtime/
tar xvf vimgdb/vimgdb_runtime.tgz -C vimgdb-runtime/

rsync -rv vimgdb-runtime/ vim72/runtime/

cd vim72

# XXX: compiling vim from source on ubuntu needs the CFLAGS
CFLAGS="-O3 -D_FORTIFY_SOURCE=1" \
    EXTRA_ARGS="--with-vim-name=$NAME --disable-selinux --disable-acl --enable-gdb --disable-gtktest --disable-gui" \
    dpkg-buildpackage -rfakeroot

