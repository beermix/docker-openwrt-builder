FROM debian:buster

# Install apt-fast to speed up downloading packages
ADD apt-fast/* /tmp/
RUN /tmp/install_apt-fast.sh

# Install basic utilities
RUN apt-fast update && apt-fast install -y time curl wget git ca-certificates

# Install build tools
RUN apt-get update -qq &&\
    apt-get install -y \
        build-essential \
        curl \
        file \
        gawk \
        gettext \
        git \
        libncurses5-dev \
        libssl-dev \
        python2.7 \
        python3 \
        rsync \
        subversion \
        sudo \
        swig \
        unzip \
        wget \
        nano \
        zlib1g-dev \
        mc tig zsh \
        && apt-get -y autoremove \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

RUN /tmp/remove_apt-fast.sh

# Clean /tmp, cache of downloaded packages and apt indexes
RUN rm /tmp/* && apt-get clean && rm -rf /var/lib/apt/lists/*

# Add user as lede cannot be built as root
RUN useradd -m user && \
    ln -sf bash /bin/sh && \
    ln -sf bash /usr/bin/sh

# Add build.sh for building with ease
ADD build.sh /usr/local/bin/

USER user
WORKDIR /home/user/ledex
CMD ["/usr/local/bin/build.sh"]
