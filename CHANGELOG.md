# Change Log

## [UNRELEASED]

### Added

### Fixed

* Fixed a bug where quoted drush arguments (e.g. passwords with spaces, SQL queries, PHP statements) were passed to drush incorrectly ([issue #36](https://github.com/palantirnet/the-vagrant/issues/36), [PR #53](https://github.com/palantirnet/the-vagrant/pull/53)

### Changed

* HTTPS is now enabled by default ([PR #49](https://github.com/palantirnet/the-vagrant/pull/49))
* The self-signed certificate generation now uses a configuration template, which includes a `subjectAltName` ([issue #50](https://github.com/palantirnet/the-vagrant/issues/50), [PR #51](https://github.com/palantirnet/the-vagrant/pull/51)
* The templated Vagrantfile now requires Vagrant >= 2.1.0 ([issue #52](https://github.com/palantirnet/the-vagrant/issues/52), [PR #54](https://github.com/palantirnet/the-vagrant/pull/54))

----
Copyright 2018 Palantir.net, Inc.
