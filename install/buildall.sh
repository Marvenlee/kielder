#!/bin/sh

# ***************************************************************************
# buildall.sh
#
# OVERVIEW:
#
# The script has 3 purposes
#
# 1) Build a binutils/gcc cross-compiler suite for the i386-kielder target.
# 2) Build Newlib for the i386-kielder target.
# 3) Cross compile several packages,  PDKSH shell, Coreutils and GNU Less
#
#
# Place the following tar archives into this folder and run ./buildall.sh
# (Or cut and chop this file to run each bit seperately)
#
# binutils-2.17.tar.bz2
# gcc-core-4.1.1.tar.bz2
# newlib-1.15.0.tar.gz
# pdksh-5.2.12.tar.gz
# coreutils-5.2.1.tar.bz2
# less-381.tar.gz
#
# Simple way of listing modified files from a patch is...
# > grep "^diff" patch_filename




# ***************************************************************************
# GNU Binutils
#
# Builds and installs an i386-kielder Binutils on the current build system.
#
# The major change is the addition of the file
# "binutils-2.17/ld/emulparams/elf_i386_kielder.sh"
# 
# The lines "TEXT_START_ADDR=0xA0000000" and
# "NONPAGED_TEXT_START_ADDR=0xA0000000" sets the default start address to
# 0xA0000000 as the Kielder kernel resides in the lower half of the address
# space.
#

tar jxf binutils-2.17.tar.bz2
patch -p0 <binutils.patch

mkdir build_binutils
cd build_binutils

../binutils-2.17/configure \
--target=i386-kielder \
--prefix=/kielder -v

make all install

cd ..




# ***************************************************************************
# Append the cross-compiler bin directory to the current
# search path. 
#

PATH="/kielder/bin:$PATH"




# ***************************************************************************
# Uncomment out the following line to permanently add the "/kielder/bin"
# directory to the search path.  Or manually alter "/etc/profile" later.
#

# printf '\nPATH="/kielder/bin:$PATH"\nexport PATH\n' >>/etc/profile




# ***************************************************************************
# GNU GCC (running on Cygwin)
#
# Builds and installs an i386-kielder GCC cross-compiler on the current
# build system.
#
# Major change is the addition of "gcc-4.1.1/gcc/config/i386/kielder.h"
# This file specifies what the "crt" files are named and what default
# libraries are linked when creating executables with i386-kielder-gcc.

tar jxf gcc-core-4.1.1.tar.bz2
patch -p0 <gcc.patch

mkdir build_gcc
cd build_gcc

../gcc-4.1.1/configure \
--target=i386-kielder \
--with-newlib \
--with-included-gettext \
--enable-languages=c \
--disable-libssp \
--prefix=/kielder -v

make all install

cd ..




# ***************************************************************************
# Newlib (for i386-kielder target)
#
# Builds and installs Newlib 1.15 for the i386-kielder target.
# libraries are placed in /kielder/i386-kielder/lib
# includes are placed in /kielder/i386-kielder/include
#
# Added "kielder" directory that contains the glue code between Newlib and
# the operating system as well as features that Newlib doesn't provide.
# This is located at "newlib-1.15.0_new\newlib\libc\sys\kielder"
#
# crt0.o at this moment doesn't handle constructors or destructors.
#
#
# A major configuration point is in "newlib-1.14.0/newlib/configure.host"
# Search for "kielder" in the above file.  Various configuration switches
# are set in the line starting with "newlib_cflags="${newlib_cflags}"
# 
# For Kielder, the following is used...
#
# -DPREFER_SIZE_OVER_SPEED -D_I386MACH_ALLOW_HW_INTERRUPTS
# -DHAVE_GETTIMEOFDAY -DMALLOC_PROVIDED -DEXIT_PROVIDED
# -DMISSING_SYSCALL_NAMES -DSIGNAL_PROVIDED -DHAVE_OPENDIR
# -DHAVE_FCNTL -DHAVE_RENAME
#
# When files are changed, added or removed from the
# "newlib-1.15.0/newlib/libc/sys/kielder" directory then add or remove
# the filename from "makefile.am" and run the following
# commands from the directory to update the makefiles.
#
# aclocal -I ../../..
# autoconf
# automake --cygnus Makefile
#

tar zxf newlib-1.15.0.tar.gz
patch -p0 <newlib.patch

mkdir build_newlib
cd build_newlib

../newlib-1.15.0/configure --target=i386-kielder --prefix=/kielder

make all install

cd ..




# ***************************************************************************
# Libraries "termcap" and "curses"
# Basic termcap and curses libraries,  used mostly by GNU Less and other
# editors like vim/elvis.
#
# "libtermcap.a" and "libcurses.a" are placed in /kielder/i386-kielder/lib
# "termcap.h" and "curses.h" are placed in /kielder/i386-kielder/include
#
# The file "etc/termcap" configuration file should be copied to the Kielder
# disk image.
# 
# The Kielder tty driver is based on/inspired by the Minix tty driver, so look
# at the source code of Kielder's /kernel/drivers/console/tty.c or the Minix
# source for how the following escape sequiences are implemented.
#
# If n and/or m are omitted, they default to 1.
# Space after ESC is there for clarity.
#
# ESC [nA moves up n lines
# ESC [nB moves down n lines
# ESC [nC moves right n spaces
# ESC [nD moves left n spaces
# ESC [m;nH moves cursor to (m,n)
# ESC [J clears screen from cursor
# ESC [K clears line from cursor
# ESC [nL inserts n lines at cursor
# ESC [nM deletes n lines at cursor
# ESC [nP deletes n chars at cursor
# ESC [n@ inserts n chars at cursor
# ESC [nm enables rendition n (0=normal, 4=bold, 5=blinking, 7=reverse)
# ESC M scrolls the screen backwards if the cursor is on the top line
#

cd termcap
make all install
cd ..




# ***************************************************************************
# PD-KSH 5.2.12 for (i386-kielder)
#
# PD-KSH is the shell used on Kielder.  It is relatively easy to support
# and has many configuration options in the "config.h" file.  It can be
# compiled to not need signal-handling, Emacs/Vi non-canonical handling
# can be removed, job control can be disabled.
#
# Biggest problem is PDKSH can't be "configured" the normal way as it tries
# to run tests that it compiles to determine things such as size of variables.
#
# Instead the patch adds a custom makefile and preconfigured "config.h",
# "emacs.out" and "siglist.out".
#
# For Kielder, PDKSH is configured to not use Job-Control,  so does not
# used the process-group/session functions.  A few other slight modifications
# have been made such as setting the default shell to "ksh" instead of "sh".
#

tar zxf pdksh-5.2.12.tar.gz
patch -p0 <pdksh.patch

cd pdksh-5.2.12
make
cd ..




# ***************************************************************************
# GNU Coreutils (i386-kielder)
#
# Coreutils provides the bread & butter command line tools.   Only slight
# modifications were needed to the configuration files to support the
# kielder host.
#
# "make -i" is used as one or two commands fail to compile due to the lack of
# select() and some other functions.  The commands need to be manually
# installed onto the Kielder OS disk image.
#

tar jxf coreutils-5.2.1.tar.bz2
patch -p0 <coreutils.patch

mkdir build_coreutils
cd build_coreutils

../coreutils-5.2.1/configure CFLAGS="-D_POSIX_VERSION -D__mempcpy=mempcpy" \
       --host=i386-kielder

make -i

cd ..




# ***************************************************************************
# GNU Less (i386-kielder)
# 
# GNU Less is a text file viewer like the old "more" command.  It makes use
# of the curses and termcap libraries compiled earlier.  No patch is needed
# for GNU Less.  Again, it has to be installed to Kielder manually.
#

tar zxf less-381.tar.gz

mkdir build_less
cd build_less

CC=i386-kielder-gcc LIBS="-lcurses -ltermcap" ../less-381/configure
        --host=i386-kielder

make all

cd ..



# ***************************************************************************
#
# Binutils and GCC can be cross-compiled to run on Kielder natively.
# This should only require the gcc and binutils to use --host=i386-kielder
# and --target=i386-kielder to be set when compiling.
#
# ---- THE END ----


