require 'FileUtils'
require_relative 'TheVagrant.rb'

$the_vagrant_dir = '/Users/white/repos/drupal-skeleton/vendor/palantirnet/the-vagrant'

# Location of the project directory
$the_vagrant_project_dir = '/Users/white/repos/drupal-skeleton'

# Location of the-vagrant's config file
$the_vagrant_config = '/Users/white/repos/drupal-skeleton/.the-vagrant.yml'


class Wizard

  def self.init(the_vagrant)

    options = [
      [:existing, 'Use existing configuration'],
      [:default, 'Install with default configuration'],
      [:show, 'Show configuration'],
      [:edit, 'Edit configuration'],
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
      FileUtils.copy_file("#{__dir__}/../conf/vagrant/Vagrantfile", "#{the_vagrant.project_dir}/Vagrantfile")
      puts "Installed with existing configuration"

    when :default
      if File.exist?(the_vagrant.config_file)
        File.delete(the_vagrant.config_file)
      end
      FileUtils.copy_file("#{__dir__}/../conf/vagrant/Vagrantfile", "#{the_vagrant.project_dir}/Vagrantfile")
      puts "Installed with default configuration"

    when :show
      puts "Existing configuration:"
      puts the_vagrant.config.to_yaml
      puts "---"
      self.init(the_vagrant)
      return

    when :edit
      puts "Editing configuration:"
      the_vagrant.config_prompt
      the_vagrant.config_write
      FileUtils.copy_file("#{__dir__}/../conf/vagrant/Vagrantfile", "#{the_vagrant.project_dir}/Vagrantfile")
      return

    else
      puts "Installation cancelled."
      return
    end
  end


end

the_vagrant = TheVagrant.new($the_vagrant_project_dir)

Wizard::init(the_vagrant)
