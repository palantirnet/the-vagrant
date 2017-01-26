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

Before you can add `the-vagrant` to your project, you need to it as a source in the `repositories` key of your `composer.json`:

```json
    "repositories": {
        "palantirnet/the-vagrant": {
            "type": "vcs",
            "url": "git@github.com:palantirnet/the-vagrant.git"
        }
    },
```

Then you can require the package:

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
  * Make a project-specific copy of the Ansible roles
3. Check in and commit the new Vagrantfile to git

You can re-run the install script later if you need to change your configuration.

## Customizing your environment

Several things can be configured during the interactive installation:

* The project hostname
* The project web root
* Enable Solr
* Enable HTTPS

A few more things can be customized directly in your `Vagrantfile`:

* Extra hostnames for this VM (hello, multisite)
* Extra apt packages to install
* The PHP timezone

By default, the-vagrant references ansible roles from the package at `vendor/palantirnet/the-vagrant/conf/vagrant/provisioning`. If your project needs configuration beyond what is provided via in the `Vagrantfile`, you can:

1. Re-run the install script: `vendor/bin/the-vagrant-installer`
2. When are prompted to copy the Ansible roles, reply `Y`:

  > Copy Ansible roles into your project for customization (Y,n) [n]?
3. This will create a new `provisioning` directory in your project that contains the Ansible playbook and roles. Your `Vagrantfile` will refer to this playbook instead of the one in the `vendor` directory.
4. Check in and commit this new `provisioning` directory and updated `Vagrantfile` to git
5. Add or update the roles and playbook as necessary.
