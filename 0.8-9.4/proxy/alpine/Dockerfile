FROM alpine:3.6

RUN addgroup -S stolon && adduser -S -G stolon stolon

RUN apk add --no-cache -U su-exec

ENV STOLON_VERSION v0.8.0
RUN set -x \
    && apk add --no-cache --virtual build-dependencies -U ca-certificates wget gnupg \
    && wget -O release.tar.gz \
       "https://github.com/sorintlab/stolon/releases/download/${STOLON_VERSION}/stolon-${STOLON_VERSION}-linux-amd64.tar.gz" \
    && wget -O release.tar.gz.sig \
       "https://github.com/sorintlab/stolon/releases/download/${STOLON_VERSION}/stolon-${STOLON_VERSION}-linux-amd64.tar.gz.sig" \
    && export GNUPGHOME="$(mktemp -d)"; \
       gpg --keyserver keyserver.ubuntu.com --recv-keys FCCCD6F144408817550264AD2DCA73AB1C4F0069 || \
			 gpg --keyserver pool.sks-keyservers.net --recv-keys FCCCD6F144408817550264AD2DCA73AB1C4F0069 || \
			 gpg --keyserver pgp.rediris.es --recv-keys FCCCD6F144408817550264AD2DCA73AB1C4F0069; \
       gpg --batch --verify release.tar.gz.sig release.tar.gz; \
       # ensure gpg-agent does not keep the GNUPGHOME hostage
       pkill -9 gpg-agent; \
       pkill -9 dirmngr \
    && rm -rf "$GNUPGHOME" release.tar.gz.sig \
    && tar xf release.tar.gz; \
       cp "stolon-${STOLON_VERSION}-linux-amd64/bin/stolon-proxy" "stolon-${STOLON_VERSION}-linux-amd64/bin/stolonctl" /usr/local/bin/; \
       chmod +x /usr/local/bin/stolon-proxy /usr/local/bin/stolonctl; \
       rm -rf "stolon-${STOLON_VERSION}-linux-amd64" release.tar.gz \
    && apk del build-dependencies

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
