require 'FileUtils'
require_relative 'TheVagrant.rb'


class Wizard

  def self.init(the_vagrant)

    options = [
      [:existing, 'Use existing configuration'],
      [:default, 'Install with default configuration'],
      [:show, 'Show configuration'],
      [:edit, 'Edit configuration'],
      [:playbook_template, 'Add custom Ansible playbook template'],
      [:cancel, 'Cancel'],
    ]

    if the_vagrant.stored_config.empty?
      options.shift
    end

    puts "\r\n Installation method [0]:"

    options.each_index do |i|
      puts "  #{i}) #{options[i][1]}"
    end

    selection = gets.strip.to_i
    puts

    case options[selection][0]
    when :existing
      FileUtils.copy_file("#{__dir__}/../install/Vagrantfile", "#{the_vagrant.project_dir}/Vagrantfile")
      puts "Installed with existing configuration"

    when :default
      if File.exist?(the_vagrant.config_file)
        File.delete(the_vagrant.config_file)
      end
      FileUtils.copy_file("#{__dir__}/../install/Vagrantfile", "#{the_vagrant.project_dir}/Vagrantfile")
      puts "Installed with default configuration"

    when :show
      puts "Existing configuration:"
      puts JSON.pretty_generate(the_vagrant.config)
      puts "---"
      self.init(the_vagrant)
      return

    when :edit
      puts "Editing configuration:"
      the_vagrant.config_prompt
      the_vagrant.config_write
      FileUtils.copy_file("#{__dir__}/../install/Vagrantfile", "#{the_vagrant.project_dir}/Vagrantfile")
      self.init(the_vagrant)
      return

    when :playbook_template
      if File.exist?("#{the_vagrant.project_dir}/provisioning")
        puts "Warning: #{the_vagrant.project_dir}/provisioning already exists."
      else
        FileUtils.cp_r("#{__dir__}/../install/provisioning-template", "#{the_vagrant.project_dir}/provisioning")
        FileUtils.mv("#{the_vagrant.project_dir}/provisioning/project.yml", "#{the_vagrant.project_dir}/provisioning/#{the_vagrant.config['project']}.yml")
        the_vagrant.config_set('the_vagrant_custom_playbook', "provisioning/#{the_vagrant.config['project']}.yml")
        the_vagrant.config_write
      end

      puts "Using #{the_vagrant.config['the_vagrant_custom_playbook']}"
      self.init(the_vagrant)
      return

    else
      puts "Installation cancelled."
      return
    end
  end


end
