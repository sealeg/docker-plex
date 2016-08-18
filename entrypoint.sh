#!/bin/bash
set -e

if [ -z "$1" ]; then
    data_dir=/data
    if [ ! -d "$data_dir" ]; then
        printf 'Config dir (%s) is not present.\n' $data_dir

        exit 1
    fi

    media_dir=/media_library
    if [ ! -d "$media_dir" ]; then
        printf 'Media dir (%s) is not present.\n' $media_dir

        exit 1
    fi

    if [ ! -z "$MEDIA_MANAGER_GID" ]; then
        printf 'Adding media_mgr (%s) group...' $MEDIA_MANAGER_GID
        if ! groupadd --gid "$MEDIA_MANAGER_GID" media_mgr; then
            printf 'Unable to create media_mgr (%s) group.' $MEDIA_MANAGER_GID

            exit 1
        fi
        usermod -a -G media_mgr plex
        printf ' done\n'
    fi

    printf 'Setting permissions...'
    chown -R plex.plex /data
    printf ' done\n'

    LD_LIBRARY_PATH=/usr/lib/plexmediaserver \
    exec gosu plex /usr/lib/plexmediaserver/Plex\ Media\ Server
else
    exec "$@"
fi

