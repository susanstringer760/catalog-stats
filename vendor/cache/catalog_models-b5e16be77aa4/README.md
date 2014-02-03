# catalog_models gem

## About

The **catalog_models** gem provides ActiveRecord models for NCAR EOL Field-Catalog Development.

<https://github.com/ncareol/catalog_models>

## Gem Development

If you are developing the **catalog_models** gem, please reference and follow the gem workflow and guidelines described in `doc/DEVELOPMENT.md`

## Prerequisites

### Rubygems

rubygems version >= 1.8.10

    % gem update --system
    % gem --version
    1.8.10

### Bundler gem

    % gem install bundler

### Install required gems

    % bundle install --path vendor

### Zith schema, version 9, develop branch

<https://github.com/ncareol/zith/tree/develop>

Clone zith repository and checkout develop branch:

    % git clone git@github.com:ncareol/zith.git
    % cd zith
    % git checkout develop

Then follow steps outlined in zith's [docs/INSTALL.md](https://github.com/ncareol/zith/blob/develop/docs/INSTALL.md)

### Rails migrations

Migrations must be run from a Rails project. After **catalog_models** has been `bundle install`ed into a Rails project, symbolically link **catalog_models'** `db/migrate` into the Rails project's root directory.

`cd` to RAILS ROOT directory and:

    % rm -rf db/migrate
    % ln -s `bundle show catalog_models`/db/migrate `pwd`/db/migrate
    % bundle exec rake db:migrate

As `db/migrate` is updated in **catalog_models**, update **catalog_models** version in the Rails project's `Gemfile`, `bundle install`, and re-run the steps above.

However, not all (not many) models have migrations, and migrations
themselves have come and gone throughout development.
See the `zith` repo for SQL table definitions.
Experimental migrations consolidation has occurred on this repo's
`feature-migrations` branch and `zith`:`feature-rake-migrate`.

## Usage

### As a library

#### Installation

The **catalog_models** gem is installed by `bundler` and `git`.

Background and reference available @ `bundler`'s website:

- <http://gembundler.com/gemfile.html>
- <http://gembundler.com/git.html>

##### Gemfile

To install the **catalog_models** gem, add the following to your application's `Gemfile`:

    gem 'catalog_models', :git=>'git@github.com:ncareol/catalog_models.git', :tag=>'v0.2.6'

`:tag` references the version of **catalog_models** you would like to install into your application. Update `:tag` to the appropriate version as needed.

##### Bundle

Install gems w/ `bundler`:

    % bundle install --path vendor

#### Code

    require 'rubygems' # for ruby 1.8.7
    require 'bundler/setup'
    require 'catalog_models'
    CatalogModels.initialize!()

    # Project.find( :first, :conditions => { :name=>'predict' } )
    # => #<Project id: 222, name: "PREDICT", title: "Pre-Depression Investigation of Cloud-systems in th...", ...

    # Dataset.find( :all, :conditions => { :archive_ident: "999.xxx.20" } )
    # => [ #<Dataset id: 51418, archive_ident: "999.xxx.20", title: "clone foo bar", ..., row_revise_time: "2011-04-06 15:22:16"> ]

    # p = Project.find_by_name('predict')
    # c = Category.find_by_name('Catalog report')
    # l = Platform.find_by_name('Catalog pouch')
    # r = Product.find_by_name('synopsis')
    # d = Dataset.forStuff(p,c,l,r)
    # => [#<Dataset id: 9587, archive_ident: "p207.c402", title: "pouch synopsis (402 report)", ...]
    # e = Dataset.forStuff(l,c,r,p)
    # d==e
    # => true

### Command-line demo

    % ./bin/finder <model> <identifier>
    % ./bin/finder project predict
    % ./bin/finder project 222
       id:      222
       name:    PREDICT
       title:   Pre-Depression Investigation…
       summary: Prediction and understanding of tropical...


## TODO

- determine where to store database.yml
  - document use of DATABASE_YML environment variable
