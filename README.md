Docker Gramps [![Docker Pulls](https://img.shields.io/docker/pulls/xbgmsharp/docker-gramps.svg)](https://hub.docker.com/r/xbgmsharp/docker-gramps/)[![Build Status](https://travis-ci.com/xbgmsharp/docker-gramps.svg?branch=master)](https://travis-ci.com/xbgmsharp/docker-gramps)

Docker GrampsWebAPI [![Docker Pulls](https://img.shields.io/docker/pulls/xbgmsharp/docker-gramps-webapi.svg)](https://hub.docker.com/r/xbgmsharp/docker-gramps/)[![Build Status](https://travis-ci.com/xbgmsharp/docker-gramps.svg?branch=master)](https://travis-ci.com/xbgmsharp/docker-gramps-webapi)

Docker GrampsWebApp [![Docker Pulls](https://img.shields.io/docker/pulls/xbgmsharp/docker-gramps-webapp.svg)](https://hub.docker.com/r/xbgmsharp/docker-gramps/)[![Build Status](https://travis-ci.com/xbgmsharp/docker-gramps.svg?branch=master)](https://travis-ci.com/xbgmsharp/docker-gramps-webapp)

# Docker Gramps

This multi architecture Ubuntu Linux based Docker image allows you to run [Gramps: A genealogy program that is both intuitive for hobbyists and feature-complete for professional genealogists.](https://github.com/gramps-project/gramps)

* [Gramps](https://github.com/gramps-project/gramps)

* [Gramps Web API](https://github.com/gramps-project/web-api)

* [Gramps Web App](https://github.com/DavidMStraub/gramps-webapp)

# Supported tags:

- `latest` - Latest Gramps version ([Dockerfile](https://github.com/xbgmsharp/docker-gramps/blob/master/gramps.Dockerfile))

> The docker images are updated monthly by a cron job from ([Travis CI](https://travis-ci.com/xbgmsharp/docker-gramps)).

> This docker image is based on the popular Ubuntu Linux project, available in the ubuntu official image.

# Supported architectures: ([more info](https://github.com/docker-library/official-images#architectures-other-than-amd64))
`amd64`, `arm32v7`, `arm64v8`, `i386`

| **Docker** | **uname -m architecture** | **Annotate flage** | **Boards** |
| --- | --- | --- | --- |
| amd64 | x86_64 | (none) |
| arm32v6 | armhf | Raspberry Pis | --os linux --arch arm |
| arm64v8 | aarch64 | A53, H3, H5 ARMs |--os linux --arch arm64 --variant armv8 |

If you compiled for other architectures and know other combinations, let me know!

> The docker image tag `latest` is available for all supported architectures.

# Run Gramps WebApp
After a successful [Docker installation](https://docs.docker.com/engine/installation/) you just need to execute the following command in the shell:

```bash
docker pull xbgmsharp/docker-gramps-webapp
docker run  -d \
        -e TREE='Family Tree 1' \
        -e GRAMPS_USER_DB_URI=sqlite:////gramps/gramps_webapp_users.sqlite \
	--publish 80:8080 \
	--restart always \
	--volume ~/gramps:/root/.gramps/grampsdb/ \
	--volume ~/gramps:/gramps \
	--name gramps_webapp \
	xbgmsharp/docker-gramps-webapp
```

# Parameters
Container images are configured using parameters passed at runtime (such as those above). These parameters are separated by a colon and indicate `<external>:<internal>` respectively. For example, `-p 8080:80` would expose port `80` from inside the container to be accessible from the host's IP on port `8080` outside the container.

| Parameter | Function |
| :----: | --- |
| `-p 8080` | require for gramps to function |
| `-e TREE='Family Tree 1'` | (require) **Important:**. Family tree to open (can also be set by the -O tag on the command line, see above |
| `-e GRAMPS_USER_DB_URI=sqlite:////gramps/gramps_webapp_users.sqlite` | (require) **Important:**SQLAlchemy compatible URI for the user database when using SQL authentication. |
| `-e PUID=1000` | for UserID (optional) |
| `-e PGID=1000` | for GroupID (optional) |
| `-e TZ=Europe/Paris` | TimeZone (optional) |
| `-v /root/.gramps/grampsdb/` | Mount this folder to insert your own gramps config into the docker container. |
| `-v /gramps` | Mount this folder to add your own user db into the docker container. |

# Config
You need to configure your Gramps Web App to manage your tree and users.

Add user `myuser` with password `mypassword`.
```bash
docker run -i \ 
  -e TREE='Family Tree 1' \
  -e GRAMPS_USER_DB_URI=sqlite:////gramps/gramps_webapp_users.sqlite \
  -v $(pwd):/gramps \
  -v $(pwd):/root/.gramps/grampsdb/ \
  -e GUNICORN_CMD_ARGS='--bind=:4200 --workers=4' \
  -t xbgmsharp/gramps-webapp:latest \
  python3 -m gramps_webapp user sqlite:////gramps/gramps_webapp_users.sqlite add myuser mypassword
```
# Updating Info

The images are static, versioned, and require an image update and container recreation to update the app inside. 

Below are the instructions for updating containers:

## Via Docker Run/Create
* Update the image: `docker pull xbgmsharp/docker-gramps-webapp`
* Stop the running container: `docker stop gramps_webapp`
* Delete the container: `docker rm gramps_webapp`
* Recreate a new container with the same docker create parameters as instructed above (if mapped correctly to a host folder, your `config` and `modules` folder with settings will be preserved)
* Start the new container: `docker start gramps_webapp`
* You can also remove the old dangling images: `docker image prune`

```bash
docker pull xbgmsharp/docker-gramps-webapp
docker stop gramps_webapp
docker rm gramps_webapp
docker create \
  -e TREE='Family Tree 1' \
  -e GRAMPS_USER_DB_URI=sqlite:////gramps/gramps_webapp_users.sqlite \
  -e PUID=1000 \
  -e PGID=100 \
  -e TZ=Europe/Paris \
  --restart unless-stopped \
  --publish 8181:8080 \
  --volume ~/gramps_webapp/modules:/opt/gramps_webapp/modules \
  --volume ~/gramps_webapp/css:/opt/gramps_webapp/css \
  --name gramps_webapp xbgmsharp/docker-gramps-webapp
docker start gramps_webapp
```

# Contribution
I'm happy to accept Pull Requests!

# License
