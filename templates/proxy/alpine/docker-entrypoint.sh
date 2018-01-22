#!/bin/sh

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- stolon-proxy "$@"
fi

# Drop root privileges if we are running stolon-proxy
# allow the container to be started with `--user`
if [ "$1" = 'stolon-proxy' -a "$(id -u)" = '0' ]; then
	set -- su-exec stolon "$@"
fi

exec "$@"
