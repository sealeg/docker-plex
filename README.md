# Plex Media Server

Plex Media Server docker image.

## Usage

To run on the default port 32400:

```
docker run -d -v <data_dir>:/data -v <media_dir>:/media_library -p 32400:32400 sealeg/plex
```

