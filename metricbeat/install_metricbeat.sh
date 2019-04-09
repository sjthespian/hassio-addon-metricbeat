#!/bin/bash 

set -x
set -e		# Exit on error

BUILD_ARCH=$1
BUILD_VERSION=$2

cd /tmp

echo "Installing metricbeat $BUILD_VERSION for $BUILD_ARCH..."
UNTARDIR=/tmp
TAROPTS="zxf"
TARFILE="/tmp/metricbeat.tgz"
PKG=no		# no if installing from tar, yes if pkg directory structure
case ${BUILD_ARCH} in
  amd64)
    curl -sL -o ${TARFILE} https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-${BUILD_VERSION}-linux-x86_64.tar.gz
#    apk add gcompat	# Needed for linux binary on alpine
    ;;
  i386)
    curl -sL -o ${TARFILE} https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-${BUILD_VERSION}-linux-x86.tar.gz
#    apk add gcompat	# Needed for linux binary on alpine
    ;;
  armv7|armhf)
    TARFILE="/tmp/metricbeat.xz"
    curl -sL -o ${TARFILE} http://mirror.archlinuxarm.org/armv7h/community/metricbeat-${BUILD_VERSION}-1-armv7h.pkg.tar.xz
    UNTARDIR=/tmp/metricbeat-${BUILD_VERSION} && mkdir $UNTARDIR
    TAROPTS="-Jxf"
    PKG=yes
    ;;
  *)
    echo "Unsupported architecture: ${BUILD_ARCH}!"
    exit 1
    ;;
esac

cd /tmp
if [ ! -f ${TARFILE} ]; then
  echo "Unable to find metricbeat tar file!"
  exit 1
fi

tarcp() {
  tar cf - $1 | ( cd $2; tar xfp - )
}

# Untar and install metricbeat - use the same layout as the deb package
tar ${TAROPTS} ${TARFILE} -C ${UNTARDIR}
ls -R $UNTARDIR
cd metricbeat-${BUILD_VERSION}*
if [ "$PKG" = "yes" ]; then
  tarcp . /
  mkdir -p /usr/share/metricbeat/bin/
  if [ -f /usr/bin/metricbeat ]; then	# Move binary to the expected place
    mv /usr/bin/metricbeat /usr/share/metricbeat/bin/
  fi
else
  mkdir -p /etc/metricbeat/ /usr/share/metricbeat/bin/
  tarcp kibana /usr/share/metricbeat/
  cp metricbeat /usr/share/metricbeat/bin/metricbeat
  cp *.txt /usr/share/metricbeat/
  tarcp modules.d /etc/metricbeat/
  cp *.yml /etc/metricbeat/
fi

# Cleanup after install
/bin/rm -fr metricbeat.tgz metricbeat
