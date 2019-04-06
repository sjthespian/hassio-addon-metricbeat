#!/bin/sh

BUILD_ARCH=$1
BUILD_VERSION=$2

cd /tmp

echo "Installing metricbeat $BUILD_VERSION for $BUILD_ARCH..."
UNTARDIR=/tmp
case ${BUILD_ARCH} in
  amd64)
    curl -s -o /tmp/metricbeat.tgz https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-${BUILD_VERSION}-linux-x86_64.tar.gz
    apk add gcompat	# Needed for linux binary on alpine
    ;;
  i386)
    curl -s -o /tmp/metricbeat.tgz https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-${BUILD_VERSION}-linux-x86.tar.gz
    apk add gcompat	# Needed for linux binary on alpine
    ;;
  armv7|armhf)
    curl -s o /tmp/metricbeat.tgz http://mirror.archlinuxarm.org/armv7h/community/metricbeat-${BUILD_VERSION}-1-armv7h.pkg.tar.xz
    UNTARDIR=/tmp/metricbeat-${BUILD_ARCH} && mkdir $UNTARDIR
    ;;
  *)
    echo "Unsupported architecture: ${BUILD_ARCH}!"
    exit 1
    ;;
esac

cd /tmp
if [ ! -f metricbeat.tgz ]; then
  echo "Unable to find metricbeat tar file!"
  exit 1
fi

# Untar and install metricbeat - use the same layout as the deb package
tar xf metricbeat.tgz -C $UNTARDIR
cd metricbeat-${BUILD_VERSION}*
mkdir /etc/metricbeat/ /usr/share/metricbeat/
cp metricbeat /usr/bin/
find kibana -print | cpio -pdm /usr/share/metricbeat/
cp *.txt /usr/share/metricbeat/
find modules.d -print | cpio -pdm /etc/metricbeat/
cp *.yml /etc/metricbeat/

# Cleanup after install
/bin/rm -fr metricbeat.tgz metricbeat
