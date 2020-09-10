#!/bin/bash -x
# From https://hub.docker.com/_/node

QEMU_RELEASE="v5.1.0-2"

set -e

echo "QEMU resgistering ..."
# resgister qemu arch
docker run --rm --privileged multiarch/qemu-user-static:register --reset

echo "QEMU downloading ..."
# Download latest QEMU to add per image arch
QEMU_ARCH="x86_64 arm aarch64 i386"
for target_arch in ${QEMU_ARCH}; do
#  wget -Nq https://github.com/multiarch/qemu-user-static/releases/download/${QEMU_RELEASE}/x86_64_qemu-${target_arch}-static.tar.gz
#  tar -xvf x86_64_qemu-${target_arch}-static.tar.gz
done

ls qemu-*

echo "Docker image building ..."
# Build image per arch
IMAGE_ARCH="amd64 arm32v7 arm64v8 i386"
for arch in ${IMAGE_ARCH}; do
  QEMU_ARCH=${arch}
  if [[ ${arch} == arm32* ]] ;
  then
	QEMU_ARCH="arm"
  fi
  if [[ ${arch} == arm64* ]];
  then
	QEMU_ARCH="aarch64"
  fi
#  docker build \
#         --build-arg ARCH=${arch} \
#         --build-arg QEMU_BIN=qemu-${QEMU_ARCH}-static \
#         -t $DOCKER_USER/docker-gramps:${arch} \
#         -f gramps.Dockerfile .
  docker build \
         --build-arg ARCH=${arch} \
         --build-arg QEMU_BIN=qemu-${QEMU_ARCH}-static \
         -t $DOCKER_USER/docker-gramps-webapp:${QEMU_ARCH} \
         -f gramps-webapp.Dockerfile .
#  docker build \
#         --build-arg ARCH=${arch} \
#         --build-arg QEMU_BIN=qemu-${QEMU_ARCH}-static \
#         -t $DOCKER_USER/docker-gramps-webapi:${arch} \
#         -f gramps-webapi.Dockerfile .
done

echo "Manifest downloading ..."
# Download Docker Manifet tool
wget -Nq https://github.com/estesp/manifest-tool/releases/download/v1.0.2/manifest-tool-linux-amd64
mv manifest-tool-linux-amd64 manifest-tool
chmod +x manifest-tool
./manifest-tool --help # Just to check that it's working

#./manifest-tool push from-spec manifest.yaml
#./manifest-tool push from-spec gramps-manifest.yaml
#./manifest-tool push from-spec gramps-webapp-manifest.yaml
#./manifest-tool push from-spec gramps-webapi-manifest.yaml
