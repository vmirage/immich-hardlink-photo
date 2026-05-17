# Immich Hardlink Photo

A lightweight service that incrementally exports Immich photos using hardlinks. An example use case of this is to synchronize the hardlinked folders, via Syncthing for example, to Google Pixel to upload unlimited photos to Google Photos. After syncing, you can free up space Pixel without affecting Immich's photo library

---

## What it does

- Reads Immich PostgreSQL database
- Create hardlink of photos to the defined path map incrementally. 
- It only create hardlinks for photos in storage template folders and external libraries 
- Upload folder is ignore to create hardlink. 
- Photos that has been hardlinked will not be created again if files in the hardlink folders are deleted.
- Photos that doesn't match the path map will be ignored.

---

## Quick Start (Docker Compose)

Create a docker-compose.yml:

    services:
      immich-hardlink-photo:
        image: ghcr.io/vmirage/immich-hardlink-photo:latest
        container_name: immich_hardlink_photo
        environment:
          PG_HOST: database
          PG_PORT: "5432"
          PG_DB: immich
          PG_USER: postgres
          PG_PASSWORD: password
          SYNC_INTERVAL: "30"
          SQLITE_DB: /appdata/sync.db
          PATH_MAP: '{"/data/library": "/data/library.link"}'
        volumes:
          - /path/to/appdata:/appdata
          - /path/to/immich_data:/data
        restart: unless-restart

---

## Docker Run

docker run -d \
  --name immich_hardlink_photo \
  -e PG_HOST=(database) \
  -e PG_PORT=5432 \
  -e PG_DB=immich \
  -e PG_USER=postgres \
  -e PG_PASSWORD=(password) \
  -e SYNC_INTERVAL=30 \
  -e SQLITE_DB=/appdata/sync.db \
  -e FALLBACK_PATH=/export/unknown \
  -e PATH_MAP='{"/data/library": "/data/library.link"}' \
  -v /path/to/appdata:/appdata \
  -v /path/to/immich_data:/data \
  --restart unless-stopped \
  ghcr.io/vmirage/immich-hardlink-photo:latest

---

## Configuration

PostgreSQL:
PG_HOST
PG_PORT
PG_DB
PG_USER
PG_PASSWORD

Sync:
SYNC_INTERVAL (default 30 seconds)
SQLITE_DB (/data/sync.db)
FIRST_RUN_MIN_CREATE_DATE (minimum creation date for hardlinking on first run)

Path mapping:
PATH_MAP is JSON: {"/data\/library": "/data/library.link"}

---

## Volumes

/path/to/appdata -> SQLite state
/path/to/immich_data -> Immich source photos

---

## Important

Hardlinks only work on the same filesystem.

