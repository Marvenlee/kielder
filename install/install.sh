#!/bin/sh

# ***************************************************************************
# install.sh
#
# OVERVIEW:
#
# Run after running buildall.sh
#
# Installs the files onto a hard-drive imae.
#
# Copys the termcap file and the executable files from less, pdksh and
# coreutils to a hard drive image using mtools-mcopy.
#

mcopy -o termcap/etc/termcap c:/etc

i386-kielder-strip -s -R.comment pdksh-5.2.12/ksh
mcopy -o pdksh-5.2.12/ksh c:/bin


for filename in \
    less lesskey lessecho
do
    i386-kielder-strip -s -R.comment build_less/$filename
    mcopy -o build_less/$filename c:/bin
done

for filename in \
    [ basename cat chgrp chmod chown cksum comm cp csplit cut date dd \
    df dir dircolors dirname du echo env expand expr factor false fmt \
    fold ginstall groups head hostname id join kill link ln logname \
    ls md5sum mkdir mkfifo mknod mv nl nohup od paste pathchk pinky pr \
    printenv printf ptx pwd readlink rm rmdir seq setuidgid sha1sum shred \
    sleep sort split stat stty su sum sync tac tail tee test touch tr true \
    tsort tty unexpand uniq unlink users vdir wc who whoami yes
do
    i386-kielder-strip -s -R.comment build_coreutils/src/$filename
    mcopy -o build_coreutils/src/$filename c:/bin
done


