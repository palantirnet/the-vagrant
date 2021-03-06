# Change Log

## 2.7.0 - May 18, 2020

### Changed

* Removed the install wizard option to copy the Ansible roles into your project and customize. This can still be done, but in almost all cases adding a custom playbook is more maintainable. Existing setups that use this approach will continue to work. ([PR #76](https://github.com/palantirnet/the-vagrant/pull/76))

No update steps are required.

## 2.6.2 - May 12, 2020

### Fixed

* Update expired package sources on the drupalbox (fixes for drupalbox 1.4.0 and below, and 2.0.0)

No update steps are required.

_Note:_ If you chose the option to "Copy Ansible roles into your project for customization" during installation, you will need to manually copy the new steps into the "common" role. (See [PR #75](https://github.com/palantirnet/the-vagrant/pull/75/files))

## 2.6.1 - April 16, 2020

### Fixed

* Ansible 2.9 compatibility

No update steps are required.

## 2.6.0 - February 13, 2020

### Changed

* Removed user-specific provisioning and zsh configuration (#72)

This functionality is no longer used by our team, and causes issues with Mac OS 10.15 Catalina. No update steps are required.

## 2.5.2 - January 17, 2020

### Fixed

* The drupal-check installation was failing because `~/bin` did not yet exist.

No update steps are required.

## 2.5.1 - January 17, 2020

### Added

* Added a trigger to the default Vagrantfile that keeps the installed version of Composer up to date (#68)

### Changed

* Removed the custom drush wrapper in ~/bin. Drush 9 handles this itself.
* Removed the `vagrant up` trigger that ran `composer install` on the project

### Updating from 2.5

* This update does **not** require destroying your current vagrant box.
* This version includes changes to the `Vagrantfile` template. To get these changes, either re-run the-vagrant's installer with `vendor/bin/the-vagrant-installer`, OR manually apply the changes from the [diff from #70](https://github.com/palantirnet/the-vagrant/pull/70/files).
* As a developer, you may also want to:
  1. From your Vagrant box, `rm ~/bin/drush`
  2. Log out of your vagrant and then back in before continuing to work

## 2.5.0 - November 18, 2019

### Changed

* Switched the Ansible Galaxy role used to install nvm, since the previous role isn't compatible with Ansible 2.9

### Updating from 2.4.0

* No changes to your project are required.
* This update does **not** require destroying your current vagrant box.

## 2.4.0 - October 18, 2019

### Added

* Installed [drupal-check](https://github.com/mglaman/drupal-check) globally on the VM to prepare for Drupal 9 (#63)

### Changed

* Disabled audio on the VM to avoid a performance bug (#60)

### Updating from 2.3.0

This version includes changes to the `Vagrantfile` template. To get these changes, either re-run the-vagrant's installer with `vendor/bin/the-vagrant-installer`, OR manually apply the changes from the [diff from #60](https://github.com/palantirnet/the-vagrant/pull/60/files).

You will also need to re-run the provisioning with `vagrant reload --provision`; this will add `drupal-check` to your existing box.

This update does **not** require destroying your current vagrant box.

## 2.3.0 - November 28, 2018

### Changed

* The template `Vagrantfile` was changed to allow downloading roles from Ansible Galaxy

### Added

* Provisioning now installs [nvm](https://github.com/creationix/nvm), using the [leanbit.nvm](https://github.com/leanbit/ansible-nvm) role from Ansible Galaxy

### Updating from 2.2

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
