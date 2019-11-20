require 'yaml'


class TheVagrant

  DEFAULTS = {
    'extra_hostnames' => [],
    'playbook' => "vendor/palantirnet/the-vagrant/provisioning/drupal8-skeleton.yml",
    'ansible_solr_enabled' => true,
    'ansible_https_enabled' => true,
    'ansible_node_version' => '8',
    'ansible_project_web_root' => "web",
    'ansible_timezone' => "America/Chicago",
    'ansible_system_packages' => [],
    'ansible_custom_playbook' => "",
    'php_memory_limit' => "512M",
  }

  HIDE_DEFAULTS = [
    'playbook',
    'ansible_custom_playbook',
  ]

  def initialize(project_dir, config_file = '')
    @project_dir = project_dir
    @config_file = config_file.empty? ? "#{project_dir}/.the-vagrant.yml" : config_file

    config_load
    config_merge
  end


  def config_load
    @stored_config = {}

    if !File.exist?(@config_file)
      return
    end

    begin
      @stored_config = YAML.load_file(@config_file)
      if !(@stored_config.is_a? Hash)
        raise "Config file does not contain YAML keys and values"
      end
    rescue StandardError => e
      puts "Error loading the-vagrant config: couldn't parse file #{@config_file} as YAML"
      puts e
      exit
    end
  end


  def config_merge
    @config = DEFAULTS.merge(@stored_config)

    # The 'project' and 'hostname' should be based on the project directory if they're not
    # provided.
    if !@config.has_key?('project') or @config['project'].empty?
      @config['project'] = File.basename(@project_dir)
    end

    if !@config.has_key?('hostname') or @config['hostname'].empty?
      @config['hostname'] = "#{@config['project']}.local"
    end

    # Override the web root if the current value is not a directory within the project.
    if !@config.has_key?('ansible_project_web_root') or !File.directory?(@config['ansible_project_web_root'])
      @config['ansible_project_web_root'] = (File.directory?("#{@project_dir}/docroot") ? "docroot" : "web")
    end

    # If there's a custom playbook file, make sure that we're using it
    custom_playbook = Dir.glob("#{@project_dir}/provisioning/*.yml").delete_if {|yml| yml == 'requirements.yml' }.first
    if custom_playbook
      @config['ansible_custom_playbook'] = 'provisioning/' + File.basename(custom_playbook)
    elsif ! File.exist?("#{@project_dir}/#{@config['ansible_custom_playbook']}")
      @config['ansible_custom_playbook'] = ''
    end

    # Validate variable types of configuration values
    @config.each do |name, value|
      config_set(name, value);
    end
  end


  # Used by Wizard.rb, but it seemed appropriate to keep the type coersion together.
  def config_prompt
    @config.each do |name, value|
      if HIDE_DEFAULTS.include? name
        next
      end

      default = value.is_a?(Array) ? value.join(', ') : value

      puts "#{name} [#{default}]:"
      input = gets.strip

      config_set(name, input.empty? ? value : input)
    end
  end


  def config_set(name, value)
    # Fix variable types of string inputs
    if DEFAULTS.include? name and value.class != DEFAULTS[name].class
      if DEFAULTS[name].is_a? Array
        value = [value.split(',').map {|val| val.strip }]
      elsif (DEFAULTS[name].is_a? TrueClass or DEFAULTS[name].is_a? FalseClass) and not (value.is_a? TrueClass or value.is_a? FalseClass)
        value = value.downcase == 'true' ? true : false
      elsif DEFAULTS[name].is_a? Fixnum
        value = value.to_i
      else
        # In this case, we can't figure out how to make the type match, so we fall back to the default value.
        print "  the-vagrant: Configuration value '#{name}' is of type #{value.class}, should be #{DEFAULTS[name].class}: using '#{DEFAULTS[name]}' instead of '#{value}'\r\n"
        value = DEFAULTS[name]
      end
    end

    @config[name] = value
  end


  def config_write
    customized_config = {}

    @config.each do |name, value|
      if value != DEFAULTS[name]
        customized_config[name] = value
      end
    end

    if customized_config.empty?
      File.delete(@config_file)
    else
      File.open(@config_file, 'w') {|f| f.write customized_config.to_yaml }
    end

    @stored_config = customized_config
  end


  def config
    return @config
  end


  def stored_config
    return @stored_config
  end


  def config_file
    return @config_file
  end


  def project_dir
    return @project_dir
  end

end
