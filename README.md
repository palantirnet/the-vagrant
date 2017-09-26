# "The" Vagrant

Add a customizable vagrant environment into a project. This may be used in conjunction with the [drupal-skeleton](https://github.com/palantirnet/drupal-skeleton) and [the-build](https://github.com/palantirnet/the-build), or it may be used to retrofit an existing project with our current VM-based development environment.

_Note: If you are setting up a new project, you likely want to start with [drupal-skeleton](https://github.com/palantirnet/drupal-skeleton)._

## Dependencies

This Vagrant configuration requires the following plugins:

* [vagrant-hostmanager](https://github.com/devopsgroup-io/vagrant-hostmanager)
* [vagrant-auto_network](https://github.com/oscar-stack/vagrant-auto_network)
* [vagrant-triggers](https://github.com/emyl/vagrant-triggers)

## Installation

To use the-vagrant on a project, you will need to:

1. Require the `palantirnet/the-vagrant` package
2. Run the-vagrant's install script to add and configure the Vagrantfile

### Require the `palantirnet/the-vagrant` package with composer

```sh
$> composer require palantirnet/the-vagrant
```

### Runing the install script

1. From within your project, run `vendor/bin/the-vagrant-installer`
2. This will prompt you for project-specific configuration:
  * The project hostname
  * The project web root
  * Enable Solr
  * Enable HTTPS
  * Make a project-specific copy of the Ansible roles and a copy of the default playbook
  * OR make a project-specific Ansible playbook to be run _in addition_ to the default playbook
3. Check in and commit the new Vagrantfile to git

You can re-run the install script later if you need to change your configuration.

## Customizing your environment

Several things can be configured during the interactive installation:

* The project hostname
* The project web root
* Enable Solr
* Enable HTTPS

A few more things can be customized directly in your `Vagrantfile`:

* Extra hostnames for this VM (use this for multisite)
* Extra apt packages to install
* The PHP timezone

By default, the-vagrant references ansible roles from the package at `vendor/palantirnet/the-vagrant/conf/vagrant/provisioning`. If your project needs configuration beyond what is provided via in the `Vagrantfile`, you can re-run the install script and update the provisioning.

### Run a custom playbook in addition to the defaults

1. Re-run the install script: `vendor/bin/the-vagrant-installer`
2. When you are prompted to copy the Ansible roles, reply `n`
3. When you are prompted to add an additional Ansible playbook to your project, reply `Y`

  > Copy Ansible roles into your project for customization (Y,n) [n]? n
  >
  > OR add an additional Ansible playbook to your project  (Y,n) [n]? Y
3. This will create a new `provisioning` directory in your project that contains a simple Ansible playbook and example role. Your `Vagrantfile` will refer to this playbook in addition to the one in the `vendor` directory.
4. Check in and commit this new `provisioning` directory and updated `Vagrantfile` to git
5. Add or update the roles and playbook as necessary.

### 100% custom provisioning

1. Re-run the install script: `vendor/bin/the-vagrant-installer`
2. When you are prompted to copy the Ansible roles, reply `Y`:

  > Copy Ansible roles into your project for customization (Y,n) [n]?
3. This will create a new `provisioning` directory in your project that contains the Ansible playbook and roles. Your `Vagrantfile` will refer to this playbook instead of the one in the `vendor` directory.
4. Check in and commit this new `provisioning` directory and updated `Vagrantfile` to git
5. Add or update the roles and playbook as necessary.

# Default Software

`the-vagrant` uses Vagrant boxes built with [palantirnet/devkit](https://github.com/palantirnet/devkit). You can find more information about the specifics of accessing default software like MySQL, Solr, and Mailhog in the [Drupalbox README](https://github.com/palantirnet/devkit/blob/develop/drupalbox/README.md).

----
Copyright 2016, 2017 Palantir.net, Inc.
