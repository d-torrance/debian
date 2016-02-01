#!/bin/sh
PACKAGE=$1
cd ~/src/$PACKAGE/$PACKAGE
dpkg-source -b .
VERSION=`dpkg-parsechangelog -S Version | sed 's/.\://'`
FIRSTLETTER=`echo $PACKAGE | cut -c1`
cd ~/tmp
dget http://incoming.debian.org/debian-buildd/pool/main/${FIRSTLETTER}/${PACKAGE}/${PACKAGE}_${VERSION}.dsc
debdiff ~/src/$PACKAGE/${PACKAGE}_${VERSION}.dsc ${PACKAGE}_${VERSION}.dsc
echo -n "continue? (y/n) "
read ANSWER
if echo "$ANSWER" | grep -iq "^y"
then
    cd ~/src/$PACKAGE/$PACKAGE
    TAG=`echo $VERSION | sed 's/~/_/'`
    git tag debian/$TAG
    git push origin debian/$TAG
fi
