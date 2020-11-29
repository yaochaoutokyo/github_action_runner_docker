# Overview
As described in the issue https://github.com/actions/runner/issues/485, when run github runner inside a docker container, the auto-update of runner will cause container to shut down, so runner inside the container will fail to update itself. Worse if you set the container to restart always or on-failure, the container will enter into a loop of "start -> auto-update -> shut down".

In order to bypass the issue, in this repo, I made the container to always download latest github actions runner image when it get started. If there is a new version, the container will obviously shut down, set `restart=always` will auto restart the container. Then the new generated container will download the new version of github actions runner. 

# Usage example
Command:
```bash
$ docker build -t github_action_runner:v0.1 .
$ docker run -d --name <runner_name> \
    -e GITHUB_OWNER=<owner_account_name> \
    -e GITHUB_REPOSITORY=<repoistory_name> \
    -e GITHUB_PAT=<owner_personal_access_token> \
    -e RUNNER_LABEL=<runner_label> 
    --restart=always github_action_runner:v0.1

Variables:
- GITHUB_REPOSITORY: name of github repository which the runner is attached to
- GITHUB_OWNER: github account name of the owner of the repository
- GITHUB_PAT: personal access token of the github account
- RUNNER_LABEL: label of the runner
```
