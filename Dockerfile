FROM debian:buster

# Install apt-fast to speed up downloading packages
ADD apt-fast/* /tmp/
RUN /tmp/install_apt-fast.sh

# Install basic utilities
RUN apt-fast update && apt-fast install -y time curl wget git subversion ca-certificates

# Install build tools
RUN apt-fast update && \
    apt-fast install -y sudo time git-core subversion build-essential g++ bash make \
    			libssl-dev patch libncurses5 libncurses5-dev zlib1g-dev gawk flex \
    			gettext wget unzip xz-utils python python-distutils-extra python3 python3-distutils-extra \
    			rsync nano zsh

RUN /tmp/remove_apt-fast.sh

# Clean /tmp, cache of downloaded packages and apt indexes
RUN rm /tmp/* && apt-get clean && rm -rf /var/lib/apt/lists/*

# Add user as lede cannot be built as root
RUN useradd -m user

# Add build.sh for building with ease
ADD build.sh /usr/local/bin/

USER user
WORKDIR /home/user
CMD ["/usr/local/bin/build.sh"]
