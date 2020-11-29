FROM debian:buster-slim

ENV RUNNER_NAME "runner"
ENV GITHUB_PAT ""
ENV GITHUB_OWNER ""
ENV GITHUB_REPOSITORY ""
ENV RUNNER_WORKDIR "_work"
ENV RUNNER_LABEL ""

RUN apt-get update \
    && apt-get install -y \
        curl \
        sudo \
        git \
        jq \
        python3 \
        python3-nacl \
        python3-pip \
        libffi-dev \
        iputils-ping \
        net-tools \
        unzip \
# install ansible
RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && pip3 install ansible \
    && useradd -m github \
    && usermod -aG sudo github \
    && echo "%sudo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
# install terraform
RUN curl -O -J -L https://releases.hashicorp.com/terraform/0.13.4/terraform_0.13.4_linux_amd64.zip \
    && unzip terraform_0.13.4_linux_amd64.zip && rm -rf ./terraform_0.13.4_linux_amd64.zip \
    && mv terraform /usr/local/bin/terraform

USER github
WORKDIR /home/github

COPY --chown=github:github entrypoint.sh ./entrypoint.sh
RUN sudo chmod u+x ./entrypoint.sh

ENTRYPOINT ["/home/github/entrypoint.sh"]
