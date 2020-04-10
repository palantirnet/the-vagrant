# Load configuration for the-vagrant
require_relative 'src/TheVagrant.rb'
the_vagrant = TheVagrant.new($the_vagrant_project_dir, $the_vagrant_config)


# Ensure Vagrant requirements are present
Vagrant.require_version ">= 2.1.0"

%w{ vagrant-hostmanager vagrant-auto_network }.each do |plugin|
    unless Vagrant.has_plugin?(plugin)
        raise "#{plugin} plugin is not installed. Please install with: vagrant plugin install #{plugin}"
    end
end


# Vagrant setup
Vagrant.configure(2) do |config|

    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true

    config.vm.define "#{the_vagrant.config['project']}" do |box|

        box.vm.box = "palantir/drupalbox"
        box.vm.box_version = ">= 1.2.0, < 2.0"

        box.vm.provider "virtualbox" do |vb|
            vb.customize ["modifyvm", :id, "--memory", "2048", "--audio", "none"]
        end

        box.vm.hostname = "#{the_vagrant.config['hostname']}"
        box.vm.network :private_network, :auto_network => true

        box.hostmanager.aliases = the_vagrant.config['extra_hostnames']

        box.vm.synced_folder ".", "/vagrant", :disabled => true
        box.vm.synced_folder ".", "/var/www/#{the_vagrant.config['hostname']}", :nfs => true

        box.ssh.forward_agent = true
    end

    config.vm.provision "the-vagrant", type: "ansible" do |ansible|
        ansible.playbook = the_vagrant.config['the_vagrant_playbook']

        ansible.groups = {
            "all:children" => ["#{the_vagrant.config['project']}"]
        }

        ansible.extra_vars = the_vagrant.config

        ansible.galaxy_role_file = "vendor/palantirnet/the-vagrant/provisioning/requirements.yml"
        ansible.galaxy_roles_path = "vendor/palantirnet/the-vagrant/provisioning/roles/"
    end

    if (!the_vagrant.config['the_vagrant_custom_playbook'].empty?)
        config.vm.provision "#{the_vagrant.config['project']}-provision", type: "ansible" do |ansible|
            ansible.playbook = the_vagrant.config['the_vagrant_custom_playbook']
        end
    end

    config.trigger.before [:up, :reload] do |trigger|
        trigger.name = "Composer Install"
        trigger.run = {
            inline: "composer install --ignore-platform-reqs"
        }
    end

end
