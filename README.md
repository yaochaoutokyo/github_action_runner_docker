# Overview

The container will download the latest github actions runner image when it get started.
If there is a new version, the container will stop, set `restart=always` will auto restart the container.
Then the new generated container will download the new version of github actions runner. 

Command:

```bash
$ docker build -t action_runner .
$ docker run -d --name ${GITHUB_REPOSITORY} -e GITHUB_OWNER=${GITHUB_OWNER} -e GITHUB_REPOSITORY=${GITHUB_REPOSITORY} -e ENV GITHUB_PAT=${PERSOANL_GITHUB_TOKEN} --restart=always action_runner
```# github_action_runner_docker
