#!/bin/bash

# Test environment for Tryton ERP

# Taken from:
# https://discuss.tryton.org/t/how-to-run-tryton-using-docker/3200

source tryton.conf

TRYTON_DB="tryton"

if [[ ${1} != "" ]]; then
    TRYTON_DB=$1
fi

echo "Creating network"
podman network create tryton

echo "Starting database"
    #TODO: --mount source=tryton-database,target=/var/lib/postgresql/data \
podman run --replace                               \
    --name tryton-postgres                         \
    --env PGDATA=/var/lib/postgresql/data/pgdata   \
    --env POSTGRES_DB="${POSTGRES_DATABASE}"       \
    --env POSTGRES_PASSWORD="${POSTGRES_PASSWORD}" \
    --network tryton                               \
    --detach                                       \
    postgres

if [[ $1 == "--setup" ]]; then
    # This is done only once
    echo "Setup database for tryton"
    podman run --replace                              \
        --name trytond-admin                          \
        --env DB_HOSTNAME=tryton-postgres             \
        --env DB_PASSWORD="${POSTGRES_PASSWORD}"      \
        --network tryton                              \
        --interactive                                 \
        --tty                                         \
        --rm                                          \
        tryton/tryton                                 \
        trytond-admin -d ${TRYTON_DB} --all
fi

echo "Starting tryton"
    #TODO: --mount source=tryton-data,target=/var/lib/trytond/db \
podman run --replace                             \
    --name tryton                                \
    --env DB_HOSTNAME=tryton-postgres            \
    --env DB_PASSWORD="${POSTGRES_PASSWORD}"     \
    --network tryton                             \
    --publish 8080:8000                          \
    --detach                                     \
    tryton/tryton
