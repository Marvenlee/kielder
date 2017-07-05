
Shell scripts and patches for building the development environment
and libraries for the Kielder Operating System.  Also ports
the PDKSH shell, Coreutils and GNU Less.

Read the comments in buildall.sh and install.sh for more information.

buildall.sh can be cut and pasted to change what gets built or
to build things seperately.


REQUIRES

1) binutils-2.17.tar.bz2
2) gcc-core-4.1.1.tar.bz2
3) newlib-1.15.0.tar.gz
4) pdksh-5.2.12.tar.gz
5) coreutils-5.2.1.tar.bz2
6) less-381.tar.gz
7) mtools (only for installing onto a hard drive image)

Drop those files into this directory.



./buildall.sh

1) Build a binutils/gcc cross-compiler suite for the i386-kielder target.
2) Build Newlib for the i386-kielder target.
3) Cross compile several packages,  PDKSH shell, Coreutils and GNU Less

Or modify the buildall.sh file to build only what is needed.




./install.sh

Should be run after the above programs and libraries have been built.
Installs the executables and termcap file onto a FAT hard drive image
using "mtools".





Examine the patch files to see what is modified.
Use grep "^diff" patch_filename to get a list of files that are
modified then search for these files for "kielder".
