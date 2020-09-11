ARG ARCH
ARG BUILD_DATE
FROM ${ARCH}/ubuntu:latest

ARG QEMU_BIN=qemu-x86_64-static
ARG GRAMPS_RELEASE=5.0.0

LABEL build_version="Gramps version:- ${GRAMPS_RELEASE} Build-date:- ${BUILD_DATE}"
LABEL maintainer="xbgmsharp"

ENV DEBIAN_FRONTEND=noninteractive
ENV LC_ALL=C.UTF-8

ADD https://github.com/gramps-project/gramps/releases/download/v${GRAMPS_RELEASE}/gramps_${GRAMPS_RELEASE}-1_all.deb /tmp/gramps_latest.deb

RUN echo "**** install packages ****" && \
    apt-get update && apt -y upgrade && \
    apt-get install -y \
    graphviz gir1.2-gexiv2-0.10 gir1.2-osmgpsmap-1.0 python3-icu \
    locales gettext \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

#RUN echo "**** download latest release ****" && \
    #curl -s https://api.github.com/repos/gramps-project/gramps/releases/latest | \
    #jq -r ".assets[] | select(.name | contains(\"deb\")) | .browser_download_url" | \
    #wget -O /tmp/gramps_latest.deb https://github.com/gramps-project/gramps/releases/download/v${GRAMPS_RELEASE}/gramps_${GRAMPS_RELEASE}-1_all.deb

RUN echo "**** install gramps ****" && \
    apt-get install -y /tmp/gramps_latest.deb
 
RUN echo "**** cleanup ****" && \
    apt-get clean && \
    rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/* \
	/root/*

RUN gramps --version
