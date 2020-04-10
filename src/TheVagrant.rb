# Read and write the JSON config file for the-vagrant. This is intended to make it hard to
# break the-vagrant with invalid config values or a broken or missing config file.
#
# - Only writes config that doesn't match the default. This means that when the default
#   values change, projects that haven't overridden the defaults will be updated.
#
# - Validates the data type of config values. If the config file contains an invalid
#   value, post a message and fall back to the default.
#
# - Manages contextual defaults:
#   - project: the parent directory name
#   - hostname: the project name + ".local"
#   - project_web_root: "web" or "docroot", whichever is present
#   - the_vagrant_custom_playbook: set if a playbook can be found at provisioning/*.yml
#
# Copyright 2019-2020 Palantir.net, Inc.

require 'json'


class TheVagrant

  DEFAULTS = {
    'extra_hostnames' => [],
    'the_vagrant_playbook' => "vendor/palantirnet/the-vagrant/provisioning/drupal8-skeleton.yml",
    'the_vagrant_custom_playbook' => "",
    'solr_enabled' => true,
    'https_enabled' => true,
    'project_web_root' => 'web',
    'timezone' => 'America/Chicago',
    'system_packages' => [],
    'php_ini_memory_limit' => '512M',
    'nvm_version' => 'v0.33.11',
    'nvm_default_node_version' => '8',
    'nvm_node_versions' => '8',
  }

  HIDE_DEFAULTS = [
    'the_vagrant_playbook',
    'the_vagrant_custom_playbook',
  ]

  def initialize(project_dir, config_file = '')
    @project_dir = project_dir
    @config_file = config_file.empty? ? "#{project_dir}/.the-vagrant.json" : config_file

    config_load
    config_merge
  end


  def config_load
    @stored_config = {}

    if !File.exist?(@config_file)
      return
    end

    begin
      @stored_config = JSON.load(File.open(@config_file))
      if !(@stored_config.is_a? Hash)
        raise "Config file does not contain JSON keys and values"
      end
    rescue StandardError => e
      puts "Error loading the-vagrant config: couldn't parse file #{@config_file} as JSON"
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
    if !@config.has_key?('project_web_root') or !File.directory?(@config['project_web_root'])
      @config['project_web_root'] = (File.directory?("#{@project_dir}/docroot") ? "docroot" : "web")
    end

    # If there's a custom playbook file, make sure that we're using it
    # Look for all the yml files not named 'requirements.yml'
    custom_playbook = Dir.glob("#{@project_dir}/provisioning/*.yml").delete_if {|yml| yml == 'requirements.yml' }.first
    if custom_playbook
      @config['the_vagrant_custom_playbook'] = 'provisioning/' + File.basename(custom_playbook)
    elsif ! File.exist?("#{@project_dir}/#{@config['the_vagrant_custom_playbook']}")
      # If there's a config value pointing to a nonexistant file, clean it up.
      @config['the_vagrant_custom_playbook'] = ''
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
      File.open(@config_file, 'w') {|f| f.write JSON.pretty_generate(customized_config) }
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
