# Poise-Ruby-Build Changelog

## v1.1.0

* Chef 13 support.
* Switch to `poise-git` and `poise-build-essential` rather than the traditional
  cookbooks to ensure support for older Chef and clean up lingering bugs.

## v1.0.2

* Fix a typo that prevented uninstalling `ruby_build` runtimes.
* Ensure bzip2 is installed as some minimal Linux images do not include it.

## v1.0.1

* Install bundler in the same way as other `ruby_runtime` providers.
* New integration test harness.

## v1.0.0

* Initial release!

