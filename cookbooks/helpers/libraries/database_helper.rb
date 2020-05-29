#
# Cookbook:: helpers
# Library:: database_helper
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
module DatabaseHelper
    def self.patch_exists(patch_class, db_user, db_password, db_name)
        connection_string = "mysql --user=#{db_user} --password=#{db_password} --database=#{db_name}"
        vendor = patch_class.split("\\")[0]
        query_string = "\"SELECT * FROM patch_list WHERE patch_name LIKE '%#{vendor}%';\""
        select_result = %x[#{[connection_string, query_string].join(" -e ")}]
        return !select_result.empty?
    end

    def self.remove_data_patch(patch_class, db_user, db_password, db_name)
        connection_string = "mysql --user=#{db_user} --password=#{db_password} --database=#{db_name}"
        vendor = patch_class.split("\\")[0]
        query_string = "\"DELETE FROM patch_list WHERE patch_name LIKE '%#{vendor}%';\""
        %x[#{[connection_string, query_string].join(" -e ")}]
    end
end