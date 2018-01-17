FROM ubuntu:16.04
# Modified from James O'Beirne <j@jameso.be>
MAINTAINER Brian Woodward <brian.woodward@gmail.com>

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 8842ce5e && \
    echo "deb http://ppa.launchpad.net/bitcoin/bitcoin/ubuntu xenial main" \
    > /etc/apt/sources.list.d/bitcoin.list

RUN apt-get update && \
    apt-get install -y bitcoind && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV HOME /bitcoin

ADD ./bin /usr/local/bin
RUN chmod a+x /usr/local/bin/*

VOLUME ["/bitcoin"]
EXPOSE 18332 18333
WORKDIR /bitcoin

ENTRYPOINT ["/usr/local/bin/docker_entrypoint.sh"]
