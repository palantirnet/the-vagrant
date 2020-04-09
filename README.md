# "The" Vagrant

Add a customizable vagrant environment into a project. This may be used in conjunction with the [drupal-skeleton](https://github.com/palantirnet/drupal-skeleton) and [the-build](https://github.com/palantirnet/the-build), or it may be used to retrofit an existing project with our current VM-based development environment.

_Note: If you are setting up a new project, you likely want to start with [drupal-skeleton](https://github.com/palantirnet/drupal-skeleton)._

## Dependencies

This Vagrant configuration requires the following plugins:

* [vagrant-hostmanager](https://github.com/devopsgroup-io/vagrant-hostmanager)
* [vagrant-auto_network](https://github.com/oscar-stack/vagrant-auto_network)

This setup will use a version of the [palantir/drupalbox](https://app.vagrantup.com/palantir/boxes/drupalbox) Vagrant box:

| the-vagrant version | palantir/drupalbox version | Vagrant provider | Vagrant version |
|---|---|---|---|
| 2.2.0 | >= 1.2.0, < 2.0 | virtualbox | >= 2.1.0 |
| 2.1.0 | >= 1.2.0, < 2.0 | virtualbox |
| 2.0.1 | 1.1.1, 1.2.0 | virtualbox |
| 2.0.0 | 1.1.0, 1.1.1 | virtualbox, vmware_desktop (drupalbox v1.1.0 only) |
| 0.6.0 - 1.1.1 | >= 0.2.4, < 1.0 | virtualbox, vmware_desktop |

\* Note that version 1.2.0 of the palantir/drupalbox VM requires updating to version 2.0.1 of palantirnet/the-vagrant.

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

## Upgrading

To upgrade the-vagrant in a project, you will need to:

1. `composer update palantirnet/the-vagrant`
2. Follow any steps from the [release notes](https://github.com/palantirnet/the-vagrant/releases).

*Note:* If you need to update your VM, such as [drupalbox](https://app.vagrantup.com/palantir/boxes/drupalbox), you will need to run `vagrant destroy` then `vagrant box update` and `vagrant up`. Updating the VM doesn't always require updating The Vagrant.

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

# Default Software

`the-vagrant` uses Vagrant boxes built with [palantirnet/devkit](https://github.com/palantirnet/devkit). You can find more information about the specifics of accessing default software like MySQL, Solr, and Mailhog in the [Drupalbox README](https://github.com/palantirnet/devkit/blob/develop/drupalbox/README.md).

----
Copyright 2016, 2017, 2018 Palantir.net, Inc.
