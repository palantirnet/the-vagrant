# "The" Vagrant

Add a customizable vagrant environment into a Drupal project. This may be used in conjunction with the [drupal-skeleton](https://github.com/palantirnet/drupal-skeleton) and [the-build](https://github.com/palantirnet/the-build), or it may be used to retrofit an existing project with a VM-based development environment.

_Note: If you are setting up a new project, you likely want to start with [drupal-skeleton](https://github.com/palantirnet/drupal-skeleton)._

## Why the-vagrant?

* Start from [a base box that comes with the basics installed](https://app.vagrantup.com/palantir/boxes/drupalbox) for fast, consistent startup
* Use a thin layer of configuration to set up your project, without masking Vagrant itself
* Customize with [Ansible playbooks](https://docs.ansible.com/ansible/latest/user_guide/playbooks.html) when necessary
* Separate your local development environment from your build tools

## Dependencies

* [Vagrant](https://www.vagrantup.com/) >= 2.1.0
* Vagrant plugins:
  * [vagrant-hostmanager](https://github.com/devopsgroup-io/vagrant-hostmanager)
  * [vagrant-auto_network](https://github.com/oscar-stack/vagrant-auto_network)
* [Virtualbox](https://www.virtualbox.org/wiki/Downloads) >= 5.0
* [Ansible](https://github.com/ansible/ansible) >= 2.9

## Installation

To use the-vagrant on a project, you will need to:

1. Use composer to add the package to your project:

    ```
    composer require --dev palantirnet/the-vagrant
    ```
2. Run the-vagrant's install script to add and configure the Vagrantfile:

    ```
    vendor/bin/the-vagrant-installer
    ```
  * This will prompt you for project-specific configuration:
    * The project hostname
    * The project web root
    * Enable Solr
    * Enable HTTPS
    * Add a project-specific Ansible playbook to be run in addition to the default playbook
3. Check in and commit the new Vagrantfile to git

If you need to change your configuration later, you can re-run the install script, or edit the `Vagrantfile` directly.

## Updating

To update an existing installation of `the-vagrant` in a project, you will need to:

1. `composer update palantirnet/the-vagrant`
2. Follow any steps from the [release notes](https://github.com/palantirnet/the-vagrant/releases).

*Note:* If you need to update the underlying VM (the Vagrant box [drupalbox](https://app.vagrantup.com/palantir/boxes/drupalbox), which includes PHP, Apache, MySQL, and Solr), you will need to run `vagrant destroy` then `vagrant box update` and `vagrant up`. Updating the VM doesn't always require updating `the-vagrant`, and vice versa.

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

### Tips for developing Ansible playbooks and roles

* The Ansible documentation has an [Intro to Playbooks](https://docs.ansible.com/ansible/latest/user_guide/playbooks_intro.html)
* Check the syntax of a playbook:

  ```
    ansible-playbook --syntax-check provisioning/my_playbook.yml
  ```
* Run a playbook against a Vagrant box without re-provisioning the box:

  ```
    ansible-playbook -u vagrant -i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory provisioning/my_playbook.yml
  ```
* Debug step outputs and variables within a role using the [debug module](https://docs.ansible.com/ansible/devel/modules/debug_module.html):

  ```
    - name: Some command
      command: ls
      register: my_command_output
    - name: Some debugging
      debug:
        var: my_command_output
  ```
* Add third-party roles from Ansible Galaxy:
  1. Create a [requirements.yml file](https://docs.ansible.com/ansible/devel/reference_appendices/galaxy.html?highlight=requirements%20yml#installing-multiple-roles-from-a-file) at `provisioning/requirements.yml`
  2. Configure the `ansible.galaxy_role_file` and `ansible.galaxy_roles_path` properties for the custom playbook in your `Vagrantfile`:

  ```
    if (defined?(ansible_custom_playbook) && !ansible_custom_playbook.empty?)
        config.vm.provision "myproject-provision", type: "ansible" do |ansible|
            ansible.playbook = ansible_custom_playbook
            ansible.galaxy_role_file = "provisioning/requirements.yml"
            ansible.galaxy_roles_path = "provisioning/roles/"
        end
    end
  ```
* In the Vagrantfile, pass additional configuration through to the Ansible provisioners. A great use case for this is setting the `php_ini_memory_limit` when using the default `palantirnet/the-vagrant` provisioning:

  ```
    ansible.extra_vars = {
      "project" => project,
      "hostname" => hostname,
      "extra_hostnames" => extra_hostnames,
      "solr_enabled" => ansible_solr_enabled,
      "https_enabled" => ansible_https_enabled,
      "project_web_root" => ansible_project_web_root,
      "timezone" => ansible_timezone,
      "system_packages" => ansible_system_packages,
      "php_ini_memory_limit" => "512M",
    }
  ```

## Default Software

`the-vagrant` uses Vagrant boxes built with [palantirnet/devkit](https://github.com/palantirnet/devkit). Releases of this Vagrant base box [are on Vagrant Cloud](https://app.vagrantup.com/palantir/boxes/drupalbox). You can find more information about the specifics of accessing default software like MySQL, Solr, and Mailhog in the [Drupalbox README](https://github.com/palantirnet/devkit/blob/develop/drupalbox/README.md).

### Compatibility between the-vagrant and base boxes
Some versions of the-vagrant are coordinated with releases of the [palantir/drupalbox](https://app.vagrantup.com/palantir/boxes/drupalbox) Vagrant box:

| the-vagrant version | palantir/drupalbox version | Vagrant provider | Vagrant version |
|---|---|---|---|
| 2.2.0 | >= 1.2.0, < 2.0 | virtualbox | >= 2.1.0 |
| 2.1.0 | >= 1.2.0, < 2.0 | virtualbox |
| 2.0.1 | 1.1.1, 1.2.0 | virtualbox |
| 2.0.0 | 1.1.0, 1.1.1 | virtualbox, vmware_desktop (drupalbox v1.1.0 only) |
| 0.6.0 - 1.1.1 | >= 0.2.4, < 1.0 | virtualbox, vmware_desktop |

\* Note that version 1.2.0 of the palantir/drupalbox VM requires updating to version 2.0.1 of palantirnet/the-vagrant.


----
Copyright 2016 - 2020 Palantir.net, Inc.
