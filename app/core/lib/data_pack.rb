require_relative 'config'
require_relative 'demo_structure'
require_relative 'entry'

class DataPack
  def DataPack.list
    list = Config.value('custom_demo/data_packs')
    return [] if list.nil? || list.empty?
    list
  end

  def DataPack.data_format_error?
    return if list.empty? || list.select { |item| item.key?('data') }.empty?

    missing_source_values = list.select { |item| item['source'].nil? }
    missing_data_values = list.select { |item| item.key?('data').nil? }
    (missing_source_values.any? || missing_data_values.any?)
  end

  def DataPack.local_list
    return [] if list.empty?

    local_list =
      list.reject do |pack|
        pack['source'].include?('github') unless pack['source'].nil?
      end

    return [] if local_list.empty?

    local_list
  end

  def DataPack.source_values
    list.map { |item| item['source'] }
  end

  def DataPack.source_folders
    Entry.files_from('project/data-packs')
  end

  def DataPack.configured_data
    local_list.each_with_object([]) do |item, arr|
      next if item['data'].nil?

      paths = item['data'].map { |item| item['path'] }
      files = item['data'].map { |item| item['files'] }

      hash = {}
      hash['source'] = item['source']
      hash['paths'] = paths unless paths.empty?
      hash['files'] = files unless files.empty?
      arr << hash
    end
  end

  def DataPack.data_path_folders
    packs_path = File.join('project', 'data-packs')

    return [] if local_list.empty? || source_folders.nil?

    DataPack
      .source_values
      .each_with_object([]) do |source, arr|
        entries =
          Entry
            .files_from_paths(File.join(packs_path, source, 'data'))
            .reject { |entry| entry.to_s.include?('.DS_Store') }
            .reject { |entry| File.file?(entry) }
            .map { |entry| File.basename(entry).to_s }

        return [] if entries.empty?

        hash = {}
        hash['source'] = source
        hash['paths'] = entries
        arr << hash
      end
  end

  def DataPack.packs_missing_source_folders
    return source_values if source_folders.nil?
    return [] if local_list.empty?

    (
      local_list.map { |record| record['source'] } -
        Entry.files_from('project/data-packs')
    )
  end

  def DataPack.folders_missing_packs
    return [] if local_list.empty?
  end

  def DataPack.packs_missing_path_folders
    return [] if local_list.empty?

    configured_data.each_with_object([]) do |record, arr|
      return [] if record['paths'].nil?

      dpf_paths =
        data_path_folders
          .select { |dpf| dpf['source'] == record['source'] }
          .flat_map { |v| v['paths'] }

      missing_folders = (record['paths'] - dpf_paths)

      return [] if missing_folders.first.nil?

      hash = {}
      hash['source'] = record['source']
      hash['paths'] = missing_folders unless missing_folders.empty?
      arr << hash
    end
  end

  def DataPack.packs_with_spaces_in_names
    return [] if local_list.empty? || data_path_folders.empty?

    data_path_folders.flat_map do |record|
      record['paths'].reject { |path| path.match(/^[^\s]*$/) }
    end
  end
end
