# Change Log

## 2.3.0 - November 28, 2018

### Changed

* The template `Vagrantfile` was changed to allow downloading roles from Ansible Galaxy

### Added

* Provisioning now installs [nvm](https://github.com/creationix/nvm), using the [leanbit.nvm](https://github.com/leanbit/ansible-nvm) role from Ansible Galaxy

### Updating to 2.3.0

1. Updating to this version requires updates to your project's `Vagrantfile`:
  1. Re-run the-vagrant's installer with `vendor/bin/the-vagrant-installer` to get the latest version; this will overwrite any customizations you've made.
  2. _- OR -_ Add the changes to the `Vagrantfile` shown in [PR #56](https://github.com/palantirnet/the-vagrant/pull/56/files#diff-560ad909e5c24f0a4d43fed0aec59079) (the current default Node version is 8)
2. Re-run the provisioning with `vagrant reload --provision`; this will add `nvm` to your existing box.

This update does **not** require destroying your current vagrant box.

## 2.2.2 - November 28, 2018

### Fixed

* Fixed an issue with generating the self-signed certificate for HTTPS support when there are `extra_hostnames` in the Vagrantfile

### Added

* On provisioning, the git user name and email are now copied from the host into the `.gitconfig` on the VM

### Updating from 2.2.1 or 2.2.0

* This update does **not** require destroying your current vagrant box.
* After updating a project to 2.2.2, run `vagrant reload --provision`


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