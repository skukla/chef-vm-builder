name "vm"
description "Configuration file for the Kukla Demo VM"
default_attributes({"custom_demo"=>{"verticals"=>{"fashion"=>{"b2c"=>{"use"=>true, "url"=>"luma.com", "scope"=>"website", "code"=>"base", "geos"=>{"us_en"=>true, "de_de"=>false, "pt_br"=>false, "jp_jp"=>false, "in_hn"=>false}}, "b2b"=>{"use"=>true, "url"=>"b2b.luma.com", "scope"=>"website", "code"=>"luma_b2b", "geos"=>{"us_en"=>true, "de_de"=>false, "pt_br"=>false, "jp_jp"=>false, "in_hn"=>false}}}, "custom"=>{"b2c"=>{"use"=>false, "url"=>"custom-demo.com", "scope"=>"website", "code"=>"custom_b2c", "geos"=>{"us_en"=>true, "de_de"=>false, "pt_br"=>false, "jp_jp"=>false, "in_hn"=>false}}, "b2b"=>{"use"=>false, "url"=>"b2b.custom-demo.com", "scope"=>"website", "code"=>"custom_b2b", "geos"=>{"us_en"=>true, "de_de"=>false, "pt_br"=>false, "jp_jp"=>false, "in_hn"=>false}}}}, "custom_modules"=>{"module-sctools"=>{"vendor"=>"magentoese", "version"=>"dev-master", "repository_url"=>"git@github.com:PMET-public/module-sctools.git"}, "module-themecustomizer"=>{"vendor"=>"magentoese", "version"=>"dev-master", "repository_url"=>"git@github.com:PMET-public/module-themecustomizer.git"}, "module-autofill"=>{"vendor"=>"magentoese", "version"=>"dev-master", "repository_url"=>"git@github.com:PMET-public/module-autofill.git"}, "module-magento-framework-data-collection"=>{"vendor"=>"skukla", "version"=>"dev-master", "repository_url"=>"https://github.com/skukla/module-magento-framework-data-collection.git"}, "theme-frontend-custom"=>{"vendor"=>"skukla", "version"=>"dev-master", "repository_url"=>"git@github.com:skukla/theme-frontend-custom.git"}}}, "application"=>{"authentication"=>{"composer"=>{"username"=>"b17aa908c13768cef2a5a3a043bb3c54", "password"=>"93f1f71fd779eb46af01fd7587e5fdba", "github_token"=>"391e909d929bb9f99717ee5cfe590abd777f254b"}}, "installation"=>{"options"=>{"family"=>"Commerce", "version"=>"2.3.4", "b2b_version"=>"^1.1", "download"=>{"base_code"=>true, "b2b_code"=>true, "custom_modules"=>true, "modules_to_replace"=>{"temando"=>{"module"=>"module-shipping-m2"}, "magento"=>{"module"=>"google-shopping-ads"}}}, "install"=>true, "sample_data"=>false, "deploy_mode"=>{"apply"=>true, "mode"=>"production"}, "patches"=>{"apply"=>true, "repository_url"=>"https://github.com/PMET-public/magento-cloud.git"}, "configuration"=>{"base"=>true, "b2b"=>true, "custom_modules"=>true, "overrides"=>true}}, "settings"=>{"backend_frontname"=>"admin", "language"=>"en_US", "currency"=>"USD", "admin_firstname"=>"Admin", "admin_lastname"=>"Admin", "admin_email"=>"admin@luma.com", "admin_user"=>"admin", "admin_password"=>"admin4tls", "use_rewrites"=>true, "use_secure_frontend"=>false, "use_secure_admin"=>false, "cleanup_database"=>true, "session_save"=>"db"}}}, "infrastructure"=>{"os"=>{"update"=>false}, "php"=>{"version"=>"7.3", "fpm_port"=>9000, "memory_limit"=>"2G", "upload_max_filesize"=>"2M", "timezone"=>"America/Los_Angeles"}, "webserver"=>{"http_port"=>80, "ssl_port"=>443}, "database"=>{"host"=>"localhost", "user"=>"magento", "password"=>"password", "name"=>"magento"}, "elasticsearch"=>{"use"=>true, "version"=>"6.x", "memory"=>"1g", "port"=>9200, "plugins"=>["analysis-phonetic", "analysis-icu"]}, "mailhog"=>{"use"=>true, "port"=>10000}, "webmin"=>{"use"=>true, "port"=>20000}, "samba"=>{"use"=>true, "shares"=>{"composer_credentials"=>true, "web_root"=>true, "image_drop"=>true, "application_modules"=>true, "multisite_configuration"=>true, "application_design"=>true}}}, "vm"=>{"provider"=>"virtualbox", "ip"=>"192.168.57.11", "url"=>"luma.com", "name"=>"Luma VM", "box"=>"bento/ubuntu-18.04"}, "provisioner"=>{"type"=>"chef_zero", "nodes_path"=>"nodes", "data_bags_path"=>"data_bags", "environments_path"=>"environments", "roles_path"=>"roles", "cookbooks_path"=>"cookbooks"}, "remote_machine"=>{"name"=>"Kukla-Machine", "cpus"=>2, "ram"=>4096, "vram"=>16, "remote_display"=>"off", "eth0_pcislotnumber"=>32, "eth1_pcislotnumber"=>33}, "vagrant"=>{"plugins"=>{"all"=>["vagrant-hostsupdater", "vagrant-vbguest"], "vmware_desktop"=>["vagrant-vmware-desktop"], "virtualbox"=>["vagrant-vbguest"]}}})
