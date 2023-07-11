#!/bin/bash -e

BACKUP_FILE_PREFIX=mongodump
GCS_BUCKET=#GCS_BUCKET_LINK
GCS_KEYFILE_PATH=key.json
MONGO_HOST=127.0.0.1
MONGO_PORT=27017
MONGO_USER=#DB_USER
MONGO_PASSWORD=#DB_PASS
MONGO_AUTHENTICATION_DATABASE=admin
MONGO_DB=#DB_NAME

echo "Run backup"
date=$(date "+%Y-%m-%dT%H:%M:%SZ")
filename=${BACKUP_FILE_PREFIX}-${date}


if [[ -z "${MONGO_PASSWORD}" ]]; then
  mongodump --host $MONGO_HOST --port $MONGO_PORT --username $MONGO_USERNAME --authenticationDatabase $MONGO_AUTHENTICATION_DATABASE --out=/temp/backup
else
  mongodump --host $MONGO_HOST --port $MONGO_PORT --db $MONGO_DB  --authenticationDatabase $MONGO_AUTHENTICATION_DATABASE --username $MONGO_USER --password $MONGO_PASSWORD --out /temp/backup
fi

tar -czvf /temp/${filename}.tar.gz /temp/backup

gcloud auth activate-service-account --key-file=${GCS_KEYFILE_PATH}
gsutil -o "GSUtil:state_dir=/temp/.gsutil" cp /temp/${filename}.tar.gz ${GCS_BUCKET}/${filename}.tar.gz

echo "Finished backup"