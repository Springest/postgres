# Description

This cookbook was inspired by [https://github.com/opscode-cookbooks/postgresql](https://github.com/opscode-cookbooks/postgresql).

<EXPLAIN DIFFERENCES>

# Attributes

Postgres version to install (tries using the highest available version for your distribution by default)

    node['postgresql']['version']

Packages to install (uses sane defaults for each distribution according to the specified version)

    node['postgresql']['client_packages']
    node['postgresql']['server_packages']

User the postgres service runs as (defaults to the default of your distribution)

    node['postgresql']['user']['name']
    node['postgresql']['user']['home']

Configuration and data directories (defaults to the default of your distribution)

    node['postgresql']['conf_dir']
    node['postgresql']['data_dir']

Service name (defaults to the default of your distribution)

    node['postgresql']['service_name']


Default postgresql settings

    max_connections 100,
    datestyle 'iso, mdy',
    lc_messages 'en_US.UTF-8',
    lc_monetary 'en_US.UTF-8',
    lc_numeric  'en_US.UTF-8',
    lc_time 'en_US.UTF-8',
    default_text_search_config  'pg_catalog.english',
    log_line_prefix '%t [%p] %u@%d ',
    data_directory  node['postgresql']['data_dir']

Default pg_hba setting

    local all postgres peer


# Recipes

## default

Default points to client recipe

## install_client

Installs postgres client tools.

## install_server

Installs postgres server packages.

## install_client

Installs postgres contrib packages.


## default_server

Installs postgres server, configuring it using default settings.

Setup certificates using the certificate cookbook (defaults to false)

    node['postgresql']['certificate'] = true # use the systems hostname as search_id
    node['postgresql']['certificate'] = 'db-staging-master'

## postgis_package

Installs postgis from packages. You can modify the default (postgis) using this attribute

    node['postgis']['packages'] = 'postgis'

## postgis_source

Installs postgis from source, you can override the default version (2.0.1) using this attribute

    node['postgis']['version'] = '2.0.1'

Only tested on ubuntu so far.


# Providers

To use the providers in your cookbook, add the following line to your manifest.rb

    depends "postgresql"

## postgresql_config

This definition sets up postgresql.conf in (unless overridden by "path") postgresql configuration directory.

Setup postgresql configuration using the defaults.

    postgresql_config 'postgresql.conf'

You can specify your own templates

    postgresql_config 'postgresql.conf' do
      cookbook 'mycookbook'
      source   'mytemplate.erb'
    end

Owner, group, mode and path will be set automatically according to your distribution. You can override the settings though

    postgresql_config 'postgresql.conf' do
      path  '/path/to/postgresql.conf'
      mode  '0600'
      owner 'mypostgresuser'
      group 'mypostgresgroup'
    end

The postgresql service will be restarted automatically if needed.


## postgresql_certificate

Installs a certificate using the certificate cookbook.

    postgresql_certificate node['hostname']

You can override the defaults if needed

    postgresql_certificate 'db-staging-master' do
      cert_path '/my/path/mycert.crt'
      owner     'postgres'
      group     'postgres'
    end

## postgresql_hba

This definition sets up pg_hba.conf in (unless overridden by "path") postgresql configuration directory.

The default configuration uses a single rule (local all postgres peer)

    postgresql_hba 'pg_hba.conf'

Or use your own template

    postgresql_hba 'pg_hba.conf' do
      cookbook 'mycookbook'
      source   'mytemplate.erb'
    end


## postgresql_ident

Sets up the pg_ident.conf analog to the postgresql_hba provider.

## postgresql_recovery

Maintains your recovery.conf (only deploying it to slaves)

This definition sets up pg_hba.conf in (unless overridden by "path") postgresql configuration directory.

Deploy an empty recovery.conf (not very useful)

    postgresql_recovery 'recovery.conf'

Better use your own template

    postgresql_recovery 'recovery.conf' do
      cookbook 'mycookbook'
      source   'mytemplate.erb'
    end
