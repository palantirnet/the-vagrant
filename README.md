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

    ```sh
    composer require palantirnet/the-vagrant
    ```
    
2. Run the install script

    ```
    vendor/bin/the-vagrant-installer
    ```

3. Check in and commit the new `Vagrantfile` and `.the-vagrant.yml` files to git

You can re-run the install script later if you need to change your configuration. The default installation will provision a Vagrant machine using the name of the project directory, with Solr, https, nvm, gulp, drupal-check, and drush.

## Customizing your environment

Several things can be configured during the interactive installation:

* The project hostname
* The project web root
* Extra hostnames for this VM (use this for multisites)

| Name | Default Value | Description |
|---|---|---|
| `project` | *project_directory* | The name to use for the Vagrant box. Typically the same as the project directory. |
| `hostname` | *project_directory*.local | The URL to provide for the box. |
| `extra_hostnames` | | An array of additional URLs to provide for the box. In the installation wizard, enter this as a comma separated list. |
| `ansible_solr_enabled` | true | Whether Solr should be enabled on the box. |
| `ansible_https_enabled` | true | Whether HTTPS should be configured on the box. |
| `ansible_node_version` | 8 | The version of Node.js to install on the box. You can use numbered versions, or `stable` -- this is passed to nvm. |
| `ansible_project_web_root` | `web` | The web root to serve via Apache. the-vagrant will automatically detect if `docroot` is present instead. |
| `ansible_timezone` | America/Chicago | The timezone to use for PHP on the box. |
| `ansible_system_packages` |  | An array of additional packages to install using apt. |
| `php_memory_limit` | 512M | The PHP memory limit string. |
| `ansible_custom_playbook` |  | Path to a custom playbook, relative to the project. If there's a playbook within the project at `provisioning/*.yml`, the-vagrant will automatically detect it. |


### Run a custom playbook in addition to the defaults

the-vagrant uses an Ansible playbook for provisioning, which you can find in the `provisioning` directory of the project.

1. Re-run the install script: `vendor/bin/the-vagrant-installer`
2. When you are prompted for the installation method, select `Add custom Ansible playbook template`
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

# Default Software

`the-vagrant` uses Vagrant boxes built with [palantirnet/devkit](https://github.com/palantirnet/devkit). You can find more information about the specifics of accessing default software like MySQL, Solr, and Mailhog in the [Drupalbox README](https://github.com/palantirnet/devkit/blob/develop/drupalbox/README.md).

----
Copyright 2016, 2017, 2018 Palantir.net, Inc.
