# Catalog Models ChangeLog

## 1.7.1 : 2014-01-21

- add `StatusReport` status `unavailable`

## 1.7.0 : 2013-12-21

- add `ReportElement` control type `help_text`

## 1.6.0 : 2013-12-18

- add `ProjectSort` for catalog-UI's (sub)cat/plat sort add-on

## 1.5.1 : 2013-12-17

- add `ReportElement` control type `nominal_datetime`

## 1.5.0 : 2013-12-08

- add models for (facility) status reports
 * `StatusReport`
 * `StatusItem`
 * `Instrument`
- see zith branch `feature-facility-status`

## 1.4.2: 2013-12-05

- silence deprecation warning during rspec which was introduced
  by `v1.4.1`

## 1.4.1: 2013-12-04

- **ActiveRecord** `3.2.16`, part of **Rails** security fix

## 1.4.0: 2013-12-02

- add `ReportElement`
- break apart Dataset#get_all_related!() into create_with_metadata()
- Project.next_archive_ident() now accepts argument for the "middle" part

## 1.3.1: 2013-11-26

- use `ruby-1.9.3-p484`

## 1.3.0: 2013-11-15

- add `PlatformRunDate` model and corresponding migration

## 1.2.0: 2013-11-11

- use `ruby-1.9.3-p448`

## 1.1.0: 2013-09-16

- add `xlink` model
- add `has_and_belongs_to_many` relationship between `xlink` and `project` models

## 1.0.1: 2013-06-10

- remove executables, ie. `bin/finder`, from `gemspec` to resolve permissions
error when bundling multi-user repositories

## 1.0.0: 2013-06-03

- remove unused models

## 0.13.0: 2013-05-17

- security fix: `ruby 1.9.3-p429`

## 0.12.0: 2013-05-01

- hotfix bug where **CatalogModels** would load the wrong database when
the **Rails** environment was specified via `RACK_ENV` instead of
`RAILS_ENV`, which is the case for `unicorn`:

      % unicorn -E production # => RACK_ENV='production'

## 0.11.2: 2013-05-01

- hotfix approval's subcategory for Dataset creation during ingest
  when the approval has null subcat

## 0.11.1: 2013-04-23

- hotfix Dataset creation with new IngestApproval

## 0.11.0: 2013-04-22

- use parent_category.short_name, rather than relying on scrubbed category name prefixed w/ 'Catalog '

## 0.10.0: 2013-04-15

- branch `fix-67-plat-subcat` adds CatalogIngestApproval, requires zith version 9.4.0

## 0.9.1: 2013-04-16

- hotfix Project.platforms() and .products() SQL

## 0.9.0: 2013-04-12

- honor visible and purpose flags for project,dataset,file
  to play nice with archive and other apps on the production database
  - **requires** `zith` tag `v9.3.0`
    (`feature-13-visible` merged to branch `develop` at `b6f79f40`)

## 0.8.0

- fix is_image in Datafile and Format to handle null mime_type

## 0.7.0

- add some validations, esp. those related to ingest

## 0.6.2

- removing gem spec for `rubyforge-project`-- this is not a rubyforge project

## 0.6.1

- removing `geminabox` as a development dependency

## 0.6.0

- updating ActiveRecord dependent VERSION to `3.2.13` to apply **Rails** security fixes: <http://weblog.rubyonrails.org/2013/3/18/SEC-ANN-Rails-3-2-13-3-1-12-and-2-3-18-have-been-released/>

## 0.5.0

- **refactor initialization methods**:
remove old odd `init_for_apps()` and incorporate some of its usage patterns into `initialize!()`

## 0.4.0

- add `CatalogIngestItem` (refactored from **catalog_ingest_gem** `IngestEvents`)
  - requires `catalog_ingest_item` table, available @ **zith** `def/ingest.sql`

## 0.3.10

- updating ActiveRecord dependent VERSION to `3.2.12` to apply **Rails** security fixes: <http://weblog.rubyonrails.org/2013/2/11/SEC-ANN-Rails-3-2-12-3-1-11-and-2-3-17-have-been-released/>

## 0.3.9

- removing `datafile` relation to model that no longer exists: `line-items`

## 0.3.8

- renaming `menu_item` columns:
  - `target` => `href`
  - `name` => `label`

- renaming `menu_item_project` column
  - `sort` => `sort_key`

## 0.3.7

- renaming `menu_item_project` `order` column to `sort` because MySQL doesn't seem to like columns named `order` wrt order of rows returned by `SELECT... ORDER BY…`
- adding `MenuItemProject#default_scope{order()}` for default sorting of `MenuItemProjects` and `MenuItems`

## 0.3.6

- adding dedicated `MenuItemProject` model
- adding `PRIMARY KEY` to `menu_item_projects`
- refactoring `MenuItem`-`Project` relation to `has_many :through=>:menu_item_projects`
- moving migration `009` functionality to migrations `001` and `002`

## 0.3.5

- moving `order` column from `menu_item` table to `menu_item_project`
- `INDEX`ing `menu_item_project#order` column

## 0.3.4

- updating ActiveRecord dependent VERSION to `3.2.11` which fixes [Unsafe Query Generation Risk in Ruby on Rails (CVE-2013-0155)](https://groups.google.com/forum/?fromgroups=#!topic/rubyonrails-security/t1WFuuQyavI)

## 0.3.3

- updating ActiveRecord dependent VERSION to `3.2.10`, which fixes SQL-injection vulnerability in dynamic `find_by_()` finders. [further information](<https://groups.google.com/forum/?fromgroups=#!topic/rubyonrails-security/DCNTNp_qjFM>)

## 0.3.2

- improving SQL query used in `Datafile#products_at_same_time()`

## 0.3.1

- fixing `Project#get_subcategories_platforms_datasets_images()`  error when no datasets are found

## 0.3.0

- no changes, incrementing minor version to indicate wrap-up of major development of **catalog-nagios** models

## 0.2.16

- adding `NagiosDatasetCheck#enabled_projects()` method that returns the `projects` for which a `NagiosDatasetCheck` is enabled

## 0.2.15

- splitting **catalog-nagios** migrations into `NagiosDatasetOptions` and `NagiosDatasetContact`
- adding `nagios_contactgroup` table with join table, `nagios_contact_contactgroup`

## 0.2.14

- changing `recent-products` query to use `dataset.latest_file_id/_begin_date`, for better / acceptable performance in **catalog_ui**

## 0.2.13

- updating `ActiveRecord` version to `3.2.8` for updated **catalog_ui**

## 0.2.12

- renaming `nagios_dataset_options` column `label` to `service_description`
- filtering out invalid characters, e.g. parens, quotes, etc. from `service_description` to avoid breaking nagios config

## 0.2.11

- refactoring nagios-check-enabled boolean:
  - moving to `JOIN` table
  - renaming `JOIN` table to `nagios_project`
  - adding `NagiosProject` `JOIN` model in accordance with [*You should use has_many :through if you need validations, callbacks, or extra attributes on the join model.*](http://guides.rubyonrails.org/association_basics.html#choosing-between-has_many-through-and-has_and_belongs_to_many)

## 0.2.10

- adding `many_files` boolean column back to `nagios_dataset_options` table

## 0.2.9

- adding test for presence of service_name (`label` for non-dataset checks, `dataset.title` for dataset checks) as validation of `NagiosDatasetOptions`

## 0.2.8

- refactoring `nagios_dataset_options` table to work without multiple columns, in lieu of one unified `:path_strftime` column.

## 0.2.7

- updating to latest Rails version, 3.2.7:
  - <http://weblog.rubyonrails.org/2012/7/26/ann-rails-3-2-7-has-been-released/>

## 0.2.6

- adding uniqueness check for `service_description`'s related to `catalog-nagios`' `NagiosDatasetChecks` /  `nagios_dataset_options`

## 0.2.5

- adding `NagiosContact` model and `nagios_contact` table which `JOIN` `Contact` and `NagiosDatasetCheck`

## 0.2.4

- adding `nagios_dataset_options.label` column to provide a human-friendly identifier for non-dataset checks

## 0.2.3

- support disabled nagios checks via `nagios_dataset_options.enabled` boolean column

## 0.2.2

- support for nagios checks that don't correspond to datasets:
  - adding `project_nagios` table and relation between `Project` and `NagiosDatasetCheck` models
  - allowing `nagios_dataset_options.dataset_id` to be `NULL`

## 0.2.1

- integrating `nagios_dataset_options` table and `NagiosDatasetCheck` model for catalog-nagios.

## 0.2.0

- capping off initial development of models for catalog-maps

## 0.1.7

- adding `map_dataset_options.label` for displaying custom map-layer labels

## 0.1.6

- adding `map_dataset_options.reference_filepath` for reference layers in catalog-maps

## 0.1.5

- adding `map_dataset_options.platform_id` for layers that don't have corresponding dataset, e.g. wms and reference layers

## 0.1.4

- removing database migration for user, role, user_role tables, now handled by zith9 schema

## 0.1.3

support multiple map-views for a project.

map views represent a series of layers displayed in a specific view-mode for a browser, e.g. `standard`, `mobile`, `low`, etc.

- moving `map_layer` table to `map_dataset_options`
- adding `map` model and table
- adding `map_view` join table

## 0.1.2

- adding indices to map-layer table for columns:
  - `project_id`
  - `dataset_id`
  - `layer_type`

## 0.1.1

- adding MapLayer model and map_layer schema, for support of catalog-maps

## 0.1.0

- upgrading to Rails 3.2.3

## 0.0.10

- adds new methods for (parent_category,platform) -> subcategory mappings
  - `Category.[insert_]subcat_for_plat()`
  - `Dataset.related_or_create!(project,category,platform,product)`
  - `Project.next_archive_ident()`

## 0.0.9

- removing `image_url()` instance method from Datafile, functionality moved to **catalog_ui** Datafile helper method `datafile_url`

## 0.0.8

- adds and calls Dataset.in_other_subcats, for finding datasets that belong to a parent category and belong to none of that parent's subcategories

## 0.0.7

- Fixing hard-coded version dependency for ActiveRecord

## 0.0.6

- Adding remaining CTM developers and stakeholders to contacts.

## 0.0.5

- Refactored/renamed Dataset::findForRelations to Dataset::related and
Format::findByExtensions to Format::match_extension

## 0.0.4

- adds format-extensions features

## 0.0.3

- adds dennis' hack init_for_app()

## 0.0.2

- adds cart-related models

## 0.0.1

- sprint-1 release, November 2011
- models for basic catalog_ui

