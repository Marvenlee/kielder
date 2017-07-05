# Kielder OS

Kielder OS is a small Unix-like, command line based operating system for x86
based computers. The kernel provides a Unix-like System-call interface to
applications and has ports of the KSH shell and a number of GNU command line
utilities.

## License

The source code is released under the Apache 2.0 license, see the LICENSE.txt
for details. There are some exceptions, the files in the /install/termcap
directory are third-party sources that implement a basic curses and termcap
library with their own licenses. 

## Screenshots

Screenshots from Kielder OS running on VMWare:

![Login](/screenshots/3_login.jpg)

![Dungeon](/screenshots/7_dungeon.jpg)
You are likely to be eaten by a Grue

![Directories](/screenshots/4_directory.jpg)

![Pipes](/screenshots/5_pipes.jpg)

## Overview

* 256 priority round robin scheduler, preemptive kernel
* Nested interrupts run on separate interrupt stack.
* Mutexes, condition variables, r/w locks and message passing primitives
* Drivers and Filesystem handlers can run as separate threads
* Timers have 1ms precision
* Port of KSH shell and common command line tools
* FAT and ISO9660 filesystem handlers

The kernel is like a multithreaded RTOS. It is largely preemptive in design,
with only a few short sections around synchronization primitives having
interrupts disabled. The filesystem and device drivers are organised as two
types modules that share a similar interface. These are the device driver
modules and handler modules, Device drivers are self explanatory. Handlers are
used to implement filesystems and character devices such as pipes and terminals.


## Architecture

![Architecture](/screenshots/architecture.gif)

Device drivers and handlers are usually but not always implemented as separate
kernel threads that use IPC mechanisms to communicate with one another. Those
that have experience of programming on the Amiga will find the design of the IO
system familiar. In fact KielderOS borrows heavily from AmigaOS's message
passing mechanisms and overall device driver and handler structure. The most
notable difference in the IO system is the mechanisms used to copy data across
the user-kernel boundary due to KielderOS having memory protection.

The kernel provides a number of mechanisms to synchronize threads inside the
kernel. These include mutexes, condition variables, reader/writer locks and
the Amiga inspired message passing mechanisms used heavily in the IO system.
The kernel currently supports FAT and ISO9660 filesystems, PATA/ATAPI and Floppy
drives. A number of applications have been ported, including the PD-KSH Korn
Shell, GNU Coreutils, GNU Less and the Dungeon/Zork text adventure.


## Makefiles

The kernel and a few utilities located in the /bin directory are built using a
non-recursive makefile. Subdirectories contain their own 'makefile.in' that get
included into the root makefile.

make                - make everything, kernel and utilities
make depend         - update all dependencies
make clean          - remove all 
make disk           - copy all files to disk image with mtools
                       (ensure following directories exist in 
                        image; c:/bin, c:/etc and c:/home)

Specific parts of source tree can be built in isolation:

make kernel         - make the kernel
make kernel/depend  - update kernel dependencies
make kernel/clean   - remove kernel exe and object files
make kernel/disk    - Copy kernel to disk image with mtools


## Building Kielder OS

The environment used to build Kielder-OS is Cygwin on Windows. There are patches
on this page for GNU GCC and Binutils to create a cross compiler environment for
creating applications. Newlib is used as the link library.

The Intel ACPI-CA source library is needed to build the ACPI subsystem with the
files copied to the appropriate directories.  These functions could be stubbed if
the ACPI-CA is not included.


## Building the tool chain

The following files are needed and available from a number of mirror sites.

* binutils-2.17.tar.bz2
* gcc-core-4.1.1.tar.bz2
* newlib-1.15.0.tar.gz
* pdksh-5.2.12.tar.gz
* coreutils-5.2.1.tar.bz2
* less-381.tar.gz
* mtools (only for installing onto a hard drive image)

Newlib is also available via anonymous FTP from sources.redhat.com.
The GNU FTP mirror list can be found at www.gnu.org/prep/ftp.html. From there
you should be able to find the sources for binutils, gcc, coreutils and less.

Place these files in the 'install' directory and run the builall.sh script to
build and install the above packages.

cd install
./buildall.sh

The builall.sh script installs the i386-kielder cross compiler toolchain
(GCC,GAS, LD etc) and Newlib into the /kielder directory. You may want to add
the /kielder/bin directory to the $PATH enironment variable in the file
/etc/profile so it reads something like:

PATH="/usr/local/bin:/usr/bin:/bin:/usr/X11R6/bin:/kielder/bin:$PATH"
export PATH

The file install.sh is used to install the contents of coreutils, PD-KSH and GNU
less onto a hard drive image using mtools.

./install.sh


## Building the kernel

cd  kernel
make

This builds everything; kernel and command line utilities. Then copy the kernel
and other files to a hard drive image:

make disk

If a file is added or new header files are included then update the makefile
dependencies:

make depend

To clean the the project and delete all executables and object files:

make clean

Specific parts of source tree can be built in isolation, for example:

make kernel         - make only the kernel
make kernel/depend  - update kernel dependencies
make kernel/clean   - remove kernel exe and object files
make kernel/disk    - Copy kernel to disk image with mtools










