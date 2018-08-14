# Change Log

## 2.2.1 - August 14, 2018

### Fixed

* Fixed a where https provisioning failed for Vagrantfiles with multiple `extra_hostnames`

## 2.2.0 - August 1, 2018

### Fixed

* Fixed a bug where quoted drush arguments (e.g. passwords with spaces, SQL queries, PHP statements) were passed to drush incorrectly ([issue #36](https://github.com/palantirnet/the-vagrant/issues/36), [PR #53](https://github.com/palantirnet/the-vagrant/pull/53)

### Changed

* HTTPS is now enabled by default ([PR #49](https://github.com/palantirnet/the-vagrant/pull/49))
* The self-signed certificate generation now uses a configuration template, which includes a `subjectAltName` ([issue #50](https://github.com/palantirnet/the-vagrant/issues/50), [PR #51](https://github.com/palantirnet/the-vagrant/pull/51)
* The templated Vagrantfile now requires Vagrant >= 2.1.0 ([issue #52](https://github.com/palantirnet/the-vagrant/issues/52), [PR #54](https://github.com/palantirnet/the-vagrant/pull/54))

### Updating from 2.1.0

* This update does **not** require destroying your current vagrant box.
* These steps apply for projects that have not copied the full set of provisioning into their project; if there is a `provisioning/` directory in your project root, you may not receive the full set of fixes with these steps alone.

1. Uninstall the vagrant-triggers plugin with `vagrant plugin uninstall vagrant-triggers`
1. Update to Vagrant >= 2.1.0
1. In your project, require this new release of the-vagrant
1. In your project, run `vendor/bin/the-vagrant-installer`
1. Respond to the prompts to regenerate your `Vagrantfile`
1. Review the changes to make sure that you don't lose any customizations you had to this file
1. Run `vagrant up --provision` or `vagrant reload --provision` to update your box

----
Copyright 2018 Palantir.net, Inc.
