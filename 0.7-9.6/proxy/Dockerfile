FROM debian:stretch

RUN set -ex; \
		if ! command -v gpg > /dev/null; then \
			apt-get update; \
			apt-get install -y --no-install-recommends \
				gnupg \
				dirmngr \
			; \
			rm -rf /var/lib/apt/lists/*; \
		fi

RUN groupadd -r stolon && useradd -r -g stolon stolon

ENV GOSU_VERSION 1.10
RUN set -x \
    && apt-get update; \
			 apt-get install -y --no-install-recommends ca-certificates wget; \
			 rm -rf /var/lib/apt/lists/* \
    && wget -O /usr/local/bin/gosu \
			 "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
    && wget -O /usr/local/bin/gosu.asc \
			 "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
    && export GNUPGHOME="$(mktemp -d)"; \
			 gpg --keyserver keyserver.ubuntu.com --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 || \
			 gpg --keyserver pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 || \
			 gpg --keyserver pgp.rediris.es --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4; \
  	 	 gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && rm -rf "$GNUPGHOME" /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true \
    && apt-get purge -y --auto-remove ca-certificates wget

ENV STOLON_VERSION v0.7.0
RUN set -x \
    && apt-get update; \
       apt-get install -y --no-install-recommends ca-certificates wget; \
       rm -rf /var/lib/apt/lists/* \
    && wget -O release.tar.gz \
       "https://github.com/sorintlab/stolon/releases/download/${STOLON_VERSION}/stolon-${STOLON_VERSION}-linux-amd64.tar.gz" \
    && wget -O release.tar.gz.sig \
       "https://github.com/sorintlab/stolon/releases/download/${STOLON_VERSION}/stolon-${STOLON_VERSION}-linux-amd64.tar.gz.sig" \
    && export GNUPGHOME="$(mktemp -d)"; \
       gpg --keyserver keyserver.ubuntu.com --recv-keys FCCCD6F144408817550264AD2DCA73AB1C4F0069 || \
			 gpg --keyserver pool.sks-keyservers.net --recv-keys FCCCD6F144408817550264AD2DCA73AB1C4F0069 || \
			 gpg --keyserver pgp.rediris.es --recv-keys FCCCD6F144408817550264AD2DCA73AB1C4F0069; \
       gpg --batch --verify release.tar.gz.sig release.tar.gz \
    && rm -rf "$GNUPGHOME" release.tar.gz.sig \
    && tar xf release.tar.gz; \
       cp "stolon-${STOLON_VERSION}-linux-amd64/bin/stolon-proxy" "stolon-${STOLON_VERSION}-linux-amd64/bin/stolonctl" /usr/local/bin/; \
       chmod +x /usr/local/bin/stolon-proxy /usr/local/bin/stolonctl; \
       rm -rf "stolon-${STOLON_VERSION}-linux-amd64" release.tar.gz \
    && apt-get purge -y --auto-remove ca-certificates wget

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
