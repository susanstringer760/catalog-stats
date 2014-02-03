# Catalog Stats README

## About

** Catalog Stats is a ruby application that generates information from the catalog database consisting of file counts and sizes by product category.

## Prerequisites

- [zith9](https://github.com/ncareol/zith) schema and data in MySQL database.

## Initialization:

### Bundle

ROOT directory is defined as the local directory where the application resides.

Install **Bundler**.

In the ROOT directory:

    $ gem install bundler
    > Successfully installed bundler-[version]
    > 1 gem installed

Install required gems w/ **Bundler**:

    $ bundle install --path=vendor

### Database configuration

In the ROOT directory:

    $ cp config/database.yml.sample config/database.yml

update **config/database.yml** to reflect necessary parameters to connect the database


## Invocation

    $ rails server

## Development

### Gems

This project follows
['vendor-everything'](http://ryan.mcgeary.org/2011/02/09/vendor-everything-still-applies/)
procedures and manages gems with **[Bundler](http://gembundler.com)**, caching gems with `bundle package`.

Install new gems to `vendor`:

    $ bundle install --path=vendor

or update as normal:

    $ bundle update

If this is your first time bundling, you will also
need to update the stub executable scripts in `bin/`:

    $ bundle install --binstubs

Package all the proper gems into the application.
You should do this on a Linux box before committing and deploying to production.

    $ bundle package --all

### Models for Active Record

**Catalog_UI** models are provided by the [**catalog_models**](https://github.com/ncareol/catalog_models) gem, which is specified in `Gemfile` and installed by `bundler`.
