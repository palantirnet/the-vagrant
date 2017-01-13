# "The" Vagrant

Add a customizable vagrant environment into a project.

_Note: If you are instantiating a project, you likely want to start with [drupal-skeleton](https://github.com/palantirnet/drupal-skeleton)._

## Dependencies

This Vagrant configuration requires the following plugins:

* [vagrant-hostmanager](https://github.com/devopsgroup-io/vagrant-hostmanager)
* [vagrant-auto_network](https://github.com/oscar-stack/vagrant-auto_network)
* [vagrant-triggers](https://github.com/emyl/vagrant-triggers)

## Installation

## Adding the-vagrant with composer

Before you can add `the-vagrant` to your project, you need to it as a source in your `repositories` key:

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

## Installing the environment

From within your project, run:

```
vendor/bin/the-vagrant-installer
```

This will ask you for:

* A short name for your project; it will default to the name of the current directory.
* Whether to copy the provisioning Ansible roles into your project so that you can customize it. If you say no, your vagrant environment will use the default roles from `vendor/palantirnet/the-vagrant/conf/vagrant/provisioning`. You can always change your mind later -- just re-run the install command.
