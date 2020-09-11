ARG ARCH=amd64
FROM xbgmsharp/docker-gramps:${ARCH}
ARG GRAMPS_RELEASE=5.0.0
ARG BUILD_DATE
LABEL build_version="Gramps version:- ${GRAMPS_RELEASE} Build-date:- ${BUILD_DATE}"
LABEL maintainer="xbgmsharp"

RUN echo "**** install packages ****" && \
    apt update && apt install -y python3-pip git

RUN echo "**** install gramps-webapi ****" && \
    python3 -m pip install --user git+https://github.com/gramps-project/web-api.git --upgrade && \
    pip3 install gunicorn

RUN echo "**** cleanup ****" && \
    apt-get clean && \
    rm -rf \
        /tmp/* \
        /var/lib/apt/lists/* \
        /var/tmp/* \
        /root/*

ENV TREE 'Family Tree 1'
ENV GRAMPSHOME=/gramps
ENV GUNICORN_CMD_ARGS "--bind=:8080 --workers=4"

EXPOSE 8080
VOLUME /gramps/

CMD ["gunicorn", "gramps_webapi.wsgi:app"]
