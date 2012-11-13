# Description

This cookbook was inspired by [https://github.com/opscode-cookbooks/postgresql](https://github.com/opscode-cookbooks/postgresql).

<EXPLAIN DIFFERENCES>

# Attributes

Postgres version to install (tries using the highest available version for your distribution by default)

    node['postgresql']['version']

Packages to install (uses sane defaults for each distribution according to the specified version)

    node['postgresql']['client_packages']
    node['postgresql']['server_packages']

User and group the postgres user runs at (defaults to the default of your distribution)

    node['postgresql']['db_user']
    node['postgresql']['db_group']

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

    local all postgres trust


# Recipes

## default

Default points to client recipe

## install_client

Installs postgres client tools.

## install_server

Installs server packages, sets up configuration and data directories, enables service

## default_server

Installs postgres server, configuring it using default settings.

You can override the default settings using node/role attributes.
Your new settings will be merged with the default parameters.
All postgresql.conf parameters are supported

    node['postgresql']['postgresql.conf']['max_connections'] = 100

You can specify your pg_hba.conf and pg_ident.conf settings as well (below are the defaults)

    node['postgresql']['pg_hba.conf'] = [ 'local all postgres trust']
    node['postgresql']['pg_ident.conf'] = []

Configure a recovery.conf for postgres slaves (default is empty)

    node['postgresql']['recovery.conf']['primary_conninfo'] = 'host=localhost port=5432'

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


# Definitions

To use the definitions in your cookbook, add the following line to your manifest.rb

    depends "postgresql"

## pg_conf

This definition sets up postgresql.conf in (unless overridden by "path") postgresql configuration directory.

Setup postgresql configuration using the defaults.

    pg_conf 'postgresql.conf'

Setup postgresql configuration, merging default values with additional settings. All settings for postgresql.conf are supported.

    pg_conf 'postgresql.conf' do
      max_connections              100
      data_dir                     '/tmp'
      autovacuum                   'on'
      autovacuum_vacuum_cost_delay '5ms'
      autovacuum_vacuum_cost_limit 200
    end

You can specify your own templates as well

    pg_conf 'postgresql.conf' do
      cookbook 'mycookbook'
      source   'mytemplate.erb'
    end

Owner, group, mode and path will be set automatically according to your distribution. You can override the settings though

    pg_conf 'postgresql.conf' do
      path  '/path/to/postgresql.conf'
      mode  '0600'
      owner 'mypostgresuser'
      group 'mypostgresgroup'
    end

The postgresql service will be restarted automatically if needed.


## pg_certificate

Installs a certificate using the certificate cookbook.

    pg_certificate node['hostname']

    pg_certificate 'db-staging-master' do
      cert_path
      owner
      group
    end

## pg_hba

This definition sets up pg_hba.conf in (unless overridden by "path") postgresql configuration directory.

The default configuration uses a single rule (local all postgres trust)

    pg_hba 'pg_hba.conf'

You can specify your own

    pg_hba 'pg_hba.conf' do
      rules 'local all postgres trust'
    end

Multiple rules are supported using arrays

    pg_hba 'pg_hba.conf' do
      rules [ 'local all  postgres trust',
              'local mydb myuser   password' ]
    end

Additional settings like cookbook, template, owner are supported as well see the pg_conf definition for examples.
