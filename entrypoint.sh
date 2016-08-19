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

    if [ ! -z "$MEDIA_MANAGER_UID" ]; then
        printf 'Changing plex gid to %s...' $MEDIA_MANAGER_UID
        if ! groupmod --gid "$MEDIA_MANAGER_UID" plex; then
            printf 'Unable to change plex gid to %s.' $MEDIA_MANAGER_UID

            exit 1
        fi
        printf ' done\n'
        printf 'Changing plex uid to %s...' $MEDIA_MANAGER_UID
        if ! usermod --uid $MEDIA_MANAGER_UID plex; then
            printf 'Unable to change plex uid to %s.' $MEDIA_MANAGER_UID

            exit 1
        fi
        printf ' done\n'
    fi

    printf 'Setting permissions...'
    chown -R plex.plex /var/lib/plexmediaserver
    chown -R plex.plex /data
    printf ' done\n'

    LD_LIBRARY_PATH=/usr/lib/plexmediaserver \
    exec gosu plex /usr/lib/plexmediaserver/Plex\ Media\ Server
else
    exec "$@"
fi

