#!/bin/sh

# install github runner and its dependencies
echo "checking github runner latest version"
GITHUB_RUNNER_VERSION=$(curl --silent https://api.github.com/repos/actions/runner/releases/latest | grep '"tag_name":' | cut -d'"' -f4|sed 's/^.//')
echo "latest version of github runner is ${GITHUB_RUNNER_VERSION}"
echo "installing github runner ${GITHUB_RUNNER_VERSION}"
curl -Ls https://github.com/actions/runner/releases/download/v${GITHUB_RUNNER_VERSION}/actions-runner-linux-x64-${GITHUB_RUNNER_VERSION}.tar.gz | tar -zx
echo "installing github runner dependencies"
sudo ./bin/installdependencies.sh
echo "latest github runner has been successfully installed"

registration_url="https://github.com/${GITHUB_OWNER}"
if [ -z "${GITHUB_REPOSITORY}" ]; then
    echo "Requesting repogistry token of account ${GITHUB_OWNER}"
    token_url="https://api.github.com/orgs/${GITHUB_OWNER}/actions/runners/registration-token"
else
    echo "Requesting repogistry token of ${GITHUB_REPOSITORY} belong to the account ${GITHUB_OWNER}"
    token_url="https://api.github.com/repos/${GITHUB_OWNER}/${GITHUB_REPOSITORY}/actions/runners/registration-token"
    registration_url="${registration_url}/${GITHUB_REPOSITORY}"
fi

payload=$(curl -sX POST -H "Authorization: token ${GITHUB_PAT}" ${token_url})
export RUNNER_TOKEN=$(echo $payload | jq .token --raw-output)
echo "Repogistry token has been successfully requested"

# configure github runner to connect with specific repo
./config.sh \
    --name $(hostname) \
    --token ${RUNNER_TOKEN} \
    --url ${registration_url} \
    --work ${RUNNER_WORKDIR} \
    --labels ${RUNNER_LABELS} \
    --unattended \
    --replace

remove() {
    ./config.sh remove --unattended --token "${RUNNER_TOKEN}"
}

trap 'remove; exit 130' INT
trap 'remove; exit 143' TERM

./run.sh "$*" &

wait $!