FROM debian:buster

# Install apt-fast to speed up downloading packages
ADD apt-fast/* /tmp/
RUN /tmp/install_apt-fast.sh

# Install basic utilities
RUN apt-fast update && apt-fast install -y time curl wget git ca-certificates

# Install build tools
RUN apt-fast update && \
    apt-fast upgrade -y && \
    apt-fast --purge autoremove -y && \
    apt-fast install -y build-essential g++ bash make patch gawk flex zsh re2c \
    			libncurses6 libncurses-dev libncurses5-dev zlib1g-dev rsync \
    			gettext unzip xz-utils python python-distutils-extra python3 python3-distutils-extra

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
