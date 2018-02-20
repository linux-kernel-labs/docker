FROM ubuntu:16.04
LABEL authors="Octavian Purdila <tavi@cs.pub.ro>"

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:git-core/ppa && \
    apt-get update && \
    apt-get install -y sudo make git python python-pip ditaa && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -ms /bin/bash ubuntu && adduser ubuntu sudo && echo -n 'ubuntu:ubuntu' | chpasswd

# Enable passwordless sudo for users under the "sudo" group
RUN sed -i.bkp -e \
      's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' \
      /etc/sudoers

USER ubuntu
WORKDIR /home/ubuntu/

ENV PATH ${PATH}:/home/ubuntu/.local

RUN git clone git://github.com/linux-kernel-labs/linux-kernel-labs.github.io.git

RUN git clone git://github.com/linux-kernel-labs/linux.git

RUN pip install -r linux/tools/labs/requirements.txt
