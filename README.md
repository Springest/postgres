# Description

Installs and configures PostgreSQL.


# Recipes

## client

Installs postgres client tools.

## default_server

Installs postgres server (default settings)

## dedicated_server

Installs postgres server, using settings for a dedicated database machine

## default

Default points to client recipe


# Usage

Set postgresql.conf parameters

    node['postgresql']['postgresql.conf']['max_connections'] = 100

Configure pg_hba and pg_ident.conf

    node['postgresql']['pg_hba.conf'] = [ 'local all postgres trust']
    node['postgresql']['pg_ident.conf'] = []

Configure a recovery.conf for postgres slaves

    node['postgresql']['recovery.conf']['primary_conninfo'] = 'host=localhost port=5432'

Setup a certificate using the certificate cookbook

    node['postgresql']['certificate'] = true # use the systems hostname as search_id
    node['postgresql']['certificate'] = 'db-staging-master'