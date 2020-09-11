ARG ARCH=amd64
FROM xbgmsharp/docker-gramps:${ARCH}

RUN echo "**** install packages ****" && \
    apt update && apt install -y git unzip python3-pip zlib1g-dev libjpeg-dev libpng-dev

RUN echo "**** install gramps-webapp ****" && \
    python3 -m pip install --user git+https://github.com/DavidMStraub/gramps-webapp.git --upgrade && \
    python3 -m pip install gunicorn

RUN echo "**** cleanup ****" && \
    apt-get purge -y openssh-client gcc g++ python3-xdg git build-essential libc6-dev linux-libc-dev python3-pip zlib1g-dev libjpeg-dev libpng-dev ubuntu-mono && \
    apt-get clean && \
    rm -rf \
        /tmp/* \
        /var/lib/apt/lists/* \
        /var/tmp/* \
        /root/*

ENV TREE 'Family Tree 1'
ENV GRAMPS_USER_DB_URI sqlite:////gramps/gramps_webapp_users.sqlite
ENV GRAMPS_S3_BUCKET_NAME false
ENV JWT_SECRET_KEY ''
ENV GRAMPS_EXCLUDE_PRIVATE false
ENV GRAMPS_EXCLUDE_LIVING false
ENV GRAMPS_AUTH_PROVIDER sql
ENV GUNICORN_CMD_ARGS "--bind=:8080 --workers=4"

EXPOSE 8080
VOLUME /root/.gramps/grampsdb/
VOLUME /gramps/

CMD ["gunicorn", "gramps_webapp.wsgi:app"]
