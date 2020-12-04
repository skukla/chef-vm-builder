# frozen_string_literal: true

require 'pathname'
require 'json'
require 'English'

# Application class
class App
  attr_accessor :dirs, :files, :paths, :entries, :colors, :settings

  def initialize
    @dirs = {
      root: File.expand_path('..', Dir.pwd).to_s,
      app: Pathname.new("#{File.expand_path('..', Dir.pwd)}/app"),
      environments: 'environments',
      workspace: 'project',
      backup: 'backup',
      data_packs: 'data_packs',
      patches: 'patches',
      certificate: 'certificate'
    }
    @files = {
      environment: 'vm.rb',
      config: 'config.json'
    }
    @paths = {
      backups: Pathname.new("#{@dirs[:root]}/#{@dirs[:workspace]}/#{@dirs[:backup]}"),
      data_packs: Pathname.new("#{@dirs[:root]}/#{@dirs[:workspace]}/#{@dirs[:data_packs]}"),
      patches: Pathname.new("#{@dirs[:root]}/#{@dirs[:workspace]}/#{@dirs[:patches]}"),
      chef_backup_files: Pathname.new("#{@dirs[:app]}/cookbooks/magento_restore/files/default"),
      chef_data_pack_files: Pathname.new("#{@dirs[:app]}/cookbooks/magento_demo_builder/files/default"),
      chef_patch_files: Pathname.new("#{@dirs[:app]}/cookbooks/magento_patches/files/default"),
      ssl_certificates: Pathname.new("#{@dirs[:app]}/#{@dirs[:certificate]}"),
      environment_file: Pathname.new("#{@dirs[:app]}/#{@dirs[:environments]}/#{@files[:environment]}"),
      config_file: Pathname.new("#{@dirs[:root]}/#{@files[:config]}")
    }
    @entries = {
      user_backups: Dir.entries(@paths[:backups]) - %w[. .. .gitignore .DS_Store],
      user_data_packs: Dir.entries(@paths[:data_packs]) - %w[. .. .gitignore .DS_Store],
      user_patches: Dir.entries(@paths[:patches]) - %w[. .. .gitignore],
      chef_backup_files: Dir.entries(@paths[:chef_backup_files]) - %w[. .. .gitignore .DS_Store],
      chef_data_pack_files: Dir.entries(@paths[:chef_data_pack_files]) - %w[. .. .gitignore .DS_Store],
      chef_patch_files: Dir.entries(@paths[:chef_patch_files]) - %w[. .. .gitignore .DS_Store],
      ssl_certificates: Dir.entries(@paths[:ssl_certificates]) - %w[. .. .gitignore .DS_Store]
    }
    @colors = {
      bold: `tput bold`,
      reg: `tput sgr0`,
      green: `tput setaf 2`,
      magenta: `tput setaf 5`,
      cyan: `tput setaf 6`
    }
    @settings = JSON.parse(File.read(@paths[:config_file]))
  end

  def check_for_authentication
    message = %W[
      #{@colors[:magenta]}[OOPS]: #{@colors[:reg]}It looks like you're missing your
      #{@colors[:bold]}#{@colors[:cyan]}composer keys #{@colors[:reg]}or
      #{@colors[:bold]}#{@colors[:cyan]}github oauth token#{@colors[:reg]}.
      Please check your config.json file.\n\n
    ].join(' ')
    %w[public_key private_key github_token].each do |setting|
      if @settings['application']['authentication'][setting].nil? || @settings['application']['authentication'][setting].empty?
        abort(message)
      end
    end
  end

  def check_for_build_action
    build_action_list = %w[install force_install restore update reinstall]
    if @settings['application']['build']['action'].nil? || @settings['application']['build']['action'].empty?
      message = %W[
        #{@colors[:magenta]}[OOPS]: #{@colors[:reg]}It looks like your
        #{@colors[:bold]}#{@colors[:cyan]}build action#{@colors[:reg]} is
        #{@colors[:bold]}#{@colors[:cyan]}missing or empty#{@colors[:reg]}.
        Please check your config.json file.\n\n
      ].join(' ')
      abort(message)
    elsif !build_action_list.find { |action| @settings['application']['build']['action'] == action }
      message = %W[
        #{@colors[:magenta]}[OOPS]: #{@colors[:reg]}It looks like you've got an incorrect build action:
        #{@colors[:bold]}#{@colors[:cyan]}#{@settings['application']['build']['action']}.#{@colors[:reg]}
        \n\nAcceptable values are:\n\n#{build_action_list.join("\n")}\n\nPlease check your config.json file.\n\n
      ].join(' ')
      abort(message)
    end
  end

  def check_for_plugins
    completed = []
    plugins = @settings['vagrant']['plugins']['all']
    if @settings['vm']['hypervisor'] == 'virtualbox'
      plugins.push(*@settings['vagrant']['plugins']['virtualbox'])
    else
      plugins.push(*@settings['vagrant']['plugins']['vmware'])
    end
    plugins.each do |plugin|
      unless Vagrant.has_plugin?(plugin.to_s)
        system("vagrant plugin install #{plugin}", chdir: '/tmp') || exit!
        completed << plugin
      end
    end
    unless plugins.difference(completed).any?
      abort("#{@colors[:green]}[SUCCESS]: #{@colors[:reg]}Plugins have been installed. Please run the #{@colors[:bold]}#{@colors[:cyan]}vagrant up #{@colors[:reg]}command again to continue.\n")
    end
  end

  def check_for_data_pack_errors
    return if @settings['application']['build']['action'] == 'restore'

    if @settings['custom_demo'].key?('data_packs') &&
       (!@settings['custom_demo']['data_packs'].nil? && !@settings['custom_demo']['data_packs'].empty?)

      if @settings['custom_demo']['custom_modules'].nil? || @settings['custom_demo']['custom_modules'].empty?
        message = %W[
          #{@colors[:magenta]}[OOPS]: #{@colors[:reg]}You've specified a data pack but it looks like
          you're missing the #{@colors[:bold]}#{@colors[:cyan]}data install custom module
          #{@colors[:reg]}in your config.json file.\n\n
        ].join(' ')
        abort(message)
      elsif (!@settings['custom_demo']['custom_modules'].nil? ||
            !@settings['custom_demo']['custom_modules'].empty?) &&
            @settings['custom_demo']['custom_modules'].find { |_key, value| value['name'].split('/')[1] == 'module-data-install' }.nil? ||
            @settings['custom_demo']['custom_modules'].find { |_key, value| value['repository_url'] == 'https://github.com/PMET-public/module-data-install.git' }.nil?
        message = %W[
          #{@colors[:magenta]}[OOPS]: #{@colors[:reg]}You've specified a data pack but it looks like
          you're missing the #{@colors[:bold]}#{@colors[:cyan]}data install custom module
          #{@colors[:reg]}or have the wrong values for it \nin your config.json file.\n\n
        ].join(' ')
        abort(message)
      end

      @settings['custom_demo']['data_packs'].each do |_key, data_pack|
        %w[name repository_url].each do |field|
          message = %W[
            #{@colors[:magenta]}[OOPS]: #{@colors[:reg]}It looks like you're missing a
            #{@colors[:bold]}#{@colors[:cyan]}value#{@colors[:reg]} for a
            #{@colors[:bold]}#{@colors[:cyan]}data pack #{field.sub('_', ' ')}
            #{@colors[:reg]}in your config.json file.\n\n
          ].join(' ')
          abort(message) if data_pack[field].nil? || data_pack[field].empty?
        end
      end

      configured_local_data_packs = @settings['custom_demo']['data_packs'].values.reject { |value| value['repository_url'].include?('github') }

      return if configured_local_data_packs.nil?

      unless configured_local_data_packs.nil?
        if @entries[:user_data_packs].empty?
          missing_data_packs = configured_local_data_packs.map { |value| value['repository_url'] }
        else
          missing_data_packs = ((configured_local_data_packs.map { |value| value['repository_url'] }) - @entries[:user_data_packs])
        end
        message = %W[
          #{@colors[:magenta]}[OOPS]: #{@colors[:reg]}Make sure the following folders are in your project's workspace and properly configured in your config.json file:
          \n\n#{@colors[:bold]}#{@colors[:cyan]}#{missing_data_packs.join("\n")}\n\n
        ].join(' ')
        abort(message) unless missing_data_packs.nil? || missing_data_packs.empty?
      end
    end
  end

  def copy_data_packs
    unless @entries[:chef_data_pack_files].empty?
      @entries[:chef_data_pack_files].each do |entry|
        FileUtils.rm_r("#{@paths[:chef_data_pack_files]}/#{entry}")
      end
    end
    @entries[:user_data_packs].each do |entry|
      FileUtils.cp_r("#{@paths[:data_packs]}/#{entry}", @paths[:chef_data_pack_files])
    end
  end

  def copy_patches
    unless @entries[:chef_patch_files].empty?
      @entries[:chef_patch_files].each do |entry|
        FileUtils.rm_r("#{@paths[:chef_patch_files]}/#{entry}")
      end
    end
    @entries[:user_patches].each do |entry|
      FileUtils.cp_r("#{@paths[:patches]}/#{entry}", @paths[:chef_patch_files])
    end
  end

  def check_for_backup_errors
    return unless @settings['application']['build']['action'] == 'restore'

    if ['.zip', '.tgz', '.sql'].none? { |type| @entries[:user_backups].find { |file| file.include?(type) } } &&
       (@settings['custom_demo'].key?('backup') && @settings['custom_demo']['backup'].empty?)
      message = %W[
        #{@colors[:magenta]}[OOPS]: #{@colors[:reg]}You have a build action of
        #{@colors[:bold]}#{@colors[:cyan]}restore#{@colors[:reg]}, but you haven't added any
        #{@colors[:bold]}#{@colors[:cyan]}local backup files#{@colors[:reg]}\nor specified a
        #{@colors[:bold]}#{@colors[:cyan]}remote backup #{@colors[:reg]}to download.
        You silly goose, you.\n\n
      ].join(' ')
      abort(message)
    end
  end

  def copy_local_backup_files
    unless @entries[:chef_backup_files].empty?
      @entries[:chef_backup_files].each do |entry|
        FileUtils.rm_r("#{@paths[:chef_backup_files]}/#{entry}")
      end
    end
    zip_file = @entries[:user_backups].find { |file| file.include?('.zip') }
    if zip_file
      FileUtils.cp_r("#{@paths[:backups]}/#{zip_file}", @paths[:chef_backup_files])
    else
      @entries[:user_backups].each do |entry|
        ['.tgz', '.sql'].any? do |extension|
          FileUtils.cp_r("#{@paths[:backups]}/#{entry}", @paths[:chef_backup_files]) if entry.include?(extension)
        end
      end
    end
  end

  def create_environment_file
    environment_file_content = [
      'name "vm"',
      'description "Configuration file for the Kukla Demo VM"',
      "default_attributes(#{@settings})"
    ]
    File.open(@paths[:environment_file], 'w+') do |file|
      file.puts(environment_file_content)
    end
  end

  def define_urls
    result = {}
    demo_urls = []
    @settings['custom_demo']['structure'].each do |scope, scope_hash|
      scope_hash.each do |code, url|
        if scope == 'website' && code == 'base'
          result[:hostname] = @settings['custom_demo']['structure']['website'][code]
        elsif scope == 'store_view' && code == 'default'
          result[:hostname] = @settings['custom_demo']['structure']['store_view'][code]
        else
          demo_urls << url
        end
      end
      result[:demo_urls] = demo_urls
    end
    result
  end

  def clean_up_chef_cache
    %i[chef_data_pack_files chef_backup_files chef_patch_files].each do |entry_group|
      system("find '#{@paths[entry_group]}' -name '.DS_Store' -type f -delete")
      FileUtils.rm_rf Dir.glob("#{@paths[entry_group]}/*")
    end
  end

  def has_ssl_certificates
    data = {}
    base_website = @settings.dig('custom_demo', 'structure', 'website', 'base')
    default_store_view = @settings.dig('custom_demo', 'structure', 'store_view', 'default')

    data[:status] = if (base_website.nil? && default_store_view.nil?) || @entries[:ssl_certificates].empty?
                      nil
                    else
                      true
                    end

    if File.exist?("#{@paths[:ssl_certificates]}/#{base_website}.crt")
      data[:crt_file] = "#{@paths[:ssl_certificates]}/#{base_website}.crt"
    elsif File.exist?("#{@paths[:ssl_certificates]}/#{default_store_view}.crt")
      data[:crt_file] = "#{@paths[:ssl_certificates]}/#{default_store_view}.crt"
    end
    data
  end

  def clean_up_ssl_certificates
    return if has_ssl_certificates[:status].nil?

    @entries[:ssl_certificates].each do |entry|
      system("sudo security find-certificate -c #{"#{@paths[:ssl_certificates]}/#{entry}"} > /dev/null 2>&1")
      if $CHILD_STATUS.exitstatus.zero?
        system("sudo security delete-certificate -c #{entry} /Library/Keychains/System.keychain")
      end
    end
  end

  def remove_local_ssl_certificates
    return if has_ssl_certificates[:status].nil?

    FileUtils.rm_rf(has_ssl_certificates[:crt_file])
  end

  def set_up_ssl_certificates
    return if has_ssl_certificates[:status].nil?

    clean_up_ssl_certificates
    puts "Adding certificate: '#{has_ssl_certificates[:crt_file]}'"
    system("sudo security add-trusted-cert -d -r trustAsRoot -k /Library/Keychains/System.keychain '#{has_ssl_certificates[:crt_file]}'")
  end
end
