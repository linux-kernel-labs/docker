FROM ubuntu:16.04
LABEL authors="Octavian Purdila <tavi@cs.pub.ro>"

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:git-core/ppa && \
    apt-get update && \
    apt-get install -y sudo make git python python-pip ditaa npm nodejs-legacy && \
    rm -rf /var/lib/apt/lists/*

# binfmt requires priviledge execution which is not available on circleci
RUN rm /usr/bin/ditaa && \
    echo '#!/bin/sh' > /usr/bin/ditaa && \
    echo 'jarwrapper /usr/share/ditaa/ditaa.jar $@' >> /usr/bin/ditaa && \
    chmod a+rx /usr/bin/ditaa

RUN npm install -g github-status-reporter

RUN useradd -ms /bin/bash ubuntu && adduser ubuntu sudo && echo -n 'ubuntu:ubuntu' | chpasswd

# Enable passwordless sudo for users under the "sudo" group
RUN sed -i.bkp -e \
      's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' \
      /etc/sudoers

USER ubuntu
WORKDIR /home/ubuntu/

ENV PATH ${PATH}:/home/ubuntu/.local/bin

RUN pip install Sphinx==1.6.7 sphinx_rtd_theme hieroglyph==1.0
