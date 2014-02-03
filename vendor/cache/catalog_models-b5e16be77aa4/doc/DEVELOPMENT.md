# catalog_models gem development

## About

**catalog_models**' development workflow is based on:

- [Git-branching workflow](http://nvie.com/posts/a-successful-git-branching-model/)
- [Bundler loading from gem repository](http://gembundler.com/git.html)
- [Git Tags](http://www.kernel.org/pub/software/scm/git/docs/git-tag.html)

## Git-branching workflow

### Development branches

Development branch names are prefixed w/:

- `feature-`
- `enhance-`
- `fix-`

Development branches are branched from `develop`

    % git checkout develop
    % git checkout -b feature-awesomeness

### Merge

When completed, development branches are merged back into `develop`:

    % git checkout develop
    % git merge --no-ff feature-awesomeness

Merge `develop` into `master`:

    % git checkout master
    % git merge --no-ff develop

### Push

Push to `origin`:

    % git push origin

### Clean-up

Clean-up by deleting feature branch:

    % git branch -d feature-awesomeness

## Bundle

Update your Rails application's `Gemfile` to point to the **catalog_models** Git repository and commit that contain your candidate **catalog_models** enhancements:

Local repository:

    gem 'catalog_models', :git=>'/Users/ej/NCAR/catalog_models', :ref=>'a3d1cff'

Remote repository

    gem 'catalog_models', :git=>'git@github.com:ncareol/catalog_models.git', :ref=>'a3d1cff'

Run `bundler` to install updated **catalog_models** gem:

    % bundle install --local --path=vendor

Execute appropriate code in your Rails application to verify that changes to **catalog_models** had intended effect.

## Testing

Catalog Models has some tests. To run, install `rspec` globally:

    % gem install rspec

setup the `test` section of `config/database.yml`.
Then run the tests:

    % rspec

## Release

When ready to release an updated version of **catalog_models**:

- update `lib/catalog_models/version.rb`
- add version and description to `CHANGELOG.md`
- add new git tag
- push new git tag to origin

### Git tags

Gem versions are referenced and managed via git tags.

#### Reference

- <http://git-scm.com/book/en/Git-Basics-Tagging>
- <http://gitready.com/beginner/2009/02/03/tagging.html>

#### Tagging

Add tag:

    % git checkout master
    % git tag -a v0.0.1 -m "description of this gem version goes here"

Verify:

    % git describe --tags
    % git show v0.0.1

Push to origin:

    % git push --tags origin

### Verify

Update your Rails application's `Gemfile` for the newly tagged gem version:

    gem 'catalog_models', :git=>'git@github.com:ncareol/catalog_models.git', :ref=>'v0.0.1'

Run `bundler` to install updated **catalog_models** gem:

    % bundle

Execute appropriate code in your Rails application to verify that changes to **catalog_models** had intended effect.
