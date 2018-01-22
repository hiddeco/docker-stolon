#!/bin/sh

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- stolon-keeper "$@"
fi

# Drop root privileges if we are running stolon-keeper
# allow the container to be started with `--user`
if [ "$1" = 'stolon-keeper' -a "$(id -u)" = '0' ]; then
	if [ -n "$STOLON_DATA" ]; then
		chown stolon:stolon $STOLON_DATA
	fi

	set -- gosu stolon "$@"
fi

exec "$@"
