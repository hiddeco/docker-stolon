FROM postgres:9.4-alpine

RUN addgroup -S stolon && adduser -S -G stolon stolon

RUN apk add --no-cache -U musl-dev \
    # https://stackoverflow.com/a/35613430/4754775
    && mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2

ENV STOLON_VERSION v0.7.0
RUN set -x \
    && cd /tmp \
    && apk add --no-cache --virtual build-dependencies -U ca-certificates wget gnupg \
    && wget -O release.tar.gz "https://github.com/sorintlab/stolon/releases/download/${STOLON_VERSION}/stolon-${STOLON_VERSION}-linux-amd64.tar.gz" \
    && wget -O release.tar.gz.sig "https://github.com/sorintlab/stolon/releases/download/${STOLON_VERSION}/stolon-${STOLON_VERSION}-linux-amd64.tar.gz.sig" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver 176.9.147.41 --recv-keys FCCCD6F144408817550264AD2DCA73AB1C4F0069 \
    && gpg --batch --verify release.tar.gz.sig release.tar.gz \
    && rm -rf "$GNUPGHOME" release.tar.gz.sig \
    && tar xf release.tar.gz \
    && cp "stolon-${STOLON_VERSION}-linux-amd64/bin/stolon-keeper" "stolon-${STOLON_VERSION}-linux-amd64/bin/stolonctl" /usr/local/bin/ \
    && chmod +x /usr/local/bin/stolon-keeper /usr/local/bin/stolonctl \
    && rm -rf "stolon-${STOLON_VERSION}-linux-amd64" release.tar.gz \
    && apk del build-dependencies

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
