#!/bin/bash

XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-~/.config}

if [[ -f $XDG_CONFIG_HOME/chromium-flags.conf ]]; then
	CHROME_USER_FLAGS="$(cat $XDG_CONFIG_HOME/chromium-flags.conf)"
fi

exec /bin/chromium $CHROME_USER_FLAGS "$@"
