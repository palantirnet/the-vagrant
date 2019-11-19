require 'yaml'


class TheVagrant

  DEFAULTS = {
    'extra_hostnames' => [],
    'playbook' => "vendor/palantirnet/the-vagrant/conf/vagrant/provisioning/drupal8-skeleton.yml",
    'ansible_solr_enabled' => true,
    'ansible_https_enabled' => true,
    'ansible_node_version' => 8,
    'ansible_project_web_root' => "web",
    'ansible_timezone' => "America/Chicago",
    'ansible_system_packages' => [],
    'ansible_custom_playbook' => "",
  }


  def initialize(config_file, project_dir)
    @config = DEFAULTS

    # Load configuration from yaml
    if File.file?(config_file)
      @config = @config.merge(YAML.load_file(config_file))
    end

    # The 'project' and 'hostname' should be based on the project directory if they're not
    # provided.
    if !@config.has_key?('project')
      @config['project'] = File.basename(project_dir)
      print "  the-vagrant: Configuration value 'project' not set: using '#{@config['project']}'\r\n"
    end

    if !@config.has_key?('hostname')
      @config['hostname'] = "#{@config['project']}.local"
      print "  the-vagrant: Configuration value 'hostname' not set: using '#{@config['hostname']}'\r\n"
    end

    # Validate variable types of configuration values
    @config.each do |name, value|
      if DEFAULTS.has_key?(name) && value.class != DEFAULTS[name].class
        print "  the-vagrant: Configuration value '#{name}' is of type #{value.class}, should be #{DEFAULTS[name].class}: using '#{DEFAULTS[name]}' instead of '#{value}'\r\n"
        @config[name] = DEFAULTS[name]
      end
    end
  end


  def config
    return @config
  end

end
