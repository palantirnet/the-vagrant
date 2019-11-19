require 'yaml'


# Handle the-vagrant configuration options
the_vagrant_config_defaults = {
  'extra_hostnames' => [],
  'ansible_solr_enabled' => true,
  'ansible_https_enabled' => true,
  'ansible_node_version' => 8,
  'ansible_project_web_root' => "web",
  'ansible_timezone' => "America/Chicago",
  'ansible_system_packages' => [],
  'ansible_custom_playbook' => "",
}

# Load configuration from disk
the_vagrant_config = the_vagrant_config_defaults
if File.file?($the_vagrant_config)
  the_vagrant_config = the_vagrant_config_defaults.merge(YAML.load_file($the_vagrant_config))
end

# Set required defaults
if !the_vagrant_config.has_key?('project')
  the_vagrant_config['project'] = File.basename($the_vagrant_project_dir)
  print "  the-vagrant: Configuration value 'project' not set: using '#{the_vagrant_config['project']}'\r\n"
end

if !the_vagrant_config.has_key?('hostname')
  the_vagrant_config['hostname'] = "#{the_vagrant_config['project']}.local"
  print "  the-vagrant: Configuration value 'hostname' not set: using '#{the_vagrant_config['hostname']}'\r\n"
end

# Validate variable types of configuration values
the_vagrant_config.each do |name, value|
  if the_vagrant_config_defaults.has_key?(name) && value.class != the_vagrant_config_defaults[name].class
    print "  the-vagrant: Configuration value '#{name}' is of type #{value.class}, should be #{the_vagrant_config_defaults[name].class}: using '#{the_vagrant_config_defaults[name]}' instead of '#{value}'\r\n"
    the_vagrant_config[name] = the_vagrant_config_defaults[name]
  end
end


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

    config.vm.define "#{the_vagrant_config['project']}" do |box|

        box.vm.box = "palantir/drupalbox"
        box.vm.box_version = ">= 1.2.0, < 2.0"

        box.vm.provider "virtualbox" do |vb|
            vb.customize ["modifyvm", :id, "--memory", "2048", "--audio", "none"]
        end

        box.vm.hostname = "#{the_vagrant_config['hostname']}"
        box.vm.network :private_network, :auto_network => true

        box.hostmanager.aliases = the_vagrant_config['extra_hostnames']

        box.vm.synced_folder ".", "/vagrant", :disabled => true
        box.vm.synced_folder ".", "/var/www/#{the_vagrant_config['hostname']}", :nfs => true

        box.ssh.forward_agent = true
    end

    config.vm.provision "the-vagrant", type: "ansible" do |ansible|
        ansible.playbook = "vendor/palantirnet/the-vagrant/conf/vagrant/provisioning/drupal8-skeleton.yml"

        ansible.groups = {
            "all:children" => ["#{the_vagrant_config['project']}"]
        }

        ansible.extra_vars = {
            "project" => the_vagrant_config['project'],
            "hostname" => the_vagrant_config['hostname'],
            "extra_hostnames" => the_vagrant_config['extra_hostnames'],
            "solr_enabled" => the_vagrant_config['ansible_solr_enabled'],
            "https_enabled" => the_vagrant_config['ansible_https_enabled'],
            "project_web_root" => the_vagrant_config['ansible_project_web_root'],
            "timezone" => the_vagrant_config['ansible_timezone'],
            "system_packages" => the_vagrant_config['ansible_system_packages'],
            "nvm_version" => "v0.33.11",
            "nvm_default_node_version" => the_vagrant_config['ansible_node_version'],
            "nvm_node_versions" => [ the_vagrant_config['ansible_node_version'] ],
        }

        ansible.galaxy_role_file = "vendor/palantirnet/the-vagrant/conf/vagrant/provisioning/requirements.yml"
        ansible.galaxy_roles_path = "vendor/palantirnet/the-vagrant/conf/vagrant/provisioning/roles/"
    end

    if (!the_vagrant_config['ansible_custom_playbook'].empty?)
        config.vm.provision "#{the_vagrant_config['project']}-provision", type: "ansible" do |ansible|
            ansible.playbook = the_vagrant_config['ansible_custom_playbook']
        end
    end

    config.trigger.before [:up, :reload] do |trigger|
        trigger.name = "Composer Install"
        trigger.run = {
            inline: "composer install --ignore-platform-reqs"
        }
    end

end
