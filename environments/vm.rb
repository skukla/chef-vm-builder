name "vm"
description "Configuration file for the Kukla Demo VM"
default_attributes({"custom_demo"=>{"verticals"=>{"fashion"=>{"b2c"=>{"use"=>true, "url"=>"luma.com", "scope"=>"website", "code"=>"base", "geos"=>{"us_en"=>true, "de_de"=>false, "pt_br"=>false, "jp_jp"=>false, "in_hn"=>false}}, "b2b"=>{"use"=>true, "url"=>"b2b.luma.com", "scope"=>"website", "code"=>"luma_b2b", "geos"=>{"us_en"=>true, "de_de"=>false, "pt_br"=>false, "jp_jp"=>false, "in_hn"=>false}}}, "custom"=>{"b2c"=>{"use"=>true, "url"=>"custom-demo.com", "scope"=>"website", "code"=>"custom_b2c", "geos"=>{"us_en"=>true, "de_de"=>false, "pt_br"=>false, "jp_jp"=>false, "in_hn"=>false}}, "b2b"=>{"use"=>true, "url"=>"b2b.custom-demo.com", "scope"=>"website", "code"=>"custom_b2b", "geos"=>{"us_en"=>true, "de_de"=>false, "pt_br"=>false, "jp_jp"=>false, "in_hn"=>false}}}}, "admin_users"=>{"user_1"=>{"enable"=>true, "first_name"=>"Christine", "last_name"=>"Jacobs", "username"=>"christine", "password"=>"Password1", "email"=>"christine@luma.com"}, "user_2"=>{"enable"=>false, "first_name"=>"Fred", "last_name"=>"Mills", "username"=>"fred", "password"=>"Password1", "email"=>"fred@luma.com"}, "user_3"=>{"enable"=>false, "first_name"=>"Bill", "last_name"=>"Thomas", "username"=>"bill", "password"=>"Password1", "email"=>"bill@luma.com"}, "user_4"=>{"enable"=>false, "first_name"=>"Shelly", "last_name"=>"Smith", "username"=>"shelly", "password"=>"Password1", "email"=>"shelly@luma.com"}, "user_5"=>{"enable"=>0, "first_name"=>"Phil", "last_name"=>"Baker", "username"=>"phil", "password"=>"Password1", "email"=>"phil@luma.com"}}, "custom_modules"=>{"module-sctools"=>{"vendor"=>"magentoese", "version"=>"dev-master", "repository_url"=>"git@github.com:PMET-public/module-sctools.git"}, "module-themecustomizer"=>{"vendor"=>"magentoese", "version"=>"dev-master", "repository_url"=>"git@github.com:PMET-public/module-themecustomizer.git"}, "module-autofill"=>{"vendor"=>"magentoese", "version"=>"dev-master", "repository_url"=>"git@github.com:PMET-public/module-autofill.git", "configuration"=>{"magentoese_autofill"=>{"enable_autofill"=>true, "persona_1"=>{"enable"=>true, "label"=>"Steve Kukla (Test User)", "email_value"=>"steve@example.com", "password_value"=>"Password1", "firstname_value"=>"Steve", "lastname_value"=>"Kukla", "address_value"=>"3640 Holdrege Ave", "city_value"=>"Los Angeles", "state_value"=>"CA", "zip_value"=>"90016", "country_value"=>"US", "telephone_value"=>"310-945-0345", "company_value"=>"Luma, Inc."}, "persona_2"=>{"enable"=>false, "label"=>"Michelle Ortiz (Purchasing Agent)", "email_value"=>"michelle@example.com", "password_value"=>"Password1", "firstname_value"=>"Michelle", "lastname_value"=>"Ortiz", "address_value"=>"3640 Holdrege Ave", "city_value"=>"Los Angeles", "state_value"=>"CA", "zip_value"=>"90016", "country_value"=>"US", "telephone_value"=>"310-932-0362", "company_value"=>"Luma, Inc."}, "persona_3"=>{"enable"=>false, "label"=>"Casey Kendall (Floor Manager)", "email_value"=>"casey@example.com", "password_value"=>"Password1", "firstname_value"=>"Casey", "lastname_value"=>"Kendall", "address_value"=>"3640 Holdrege Ave", "city_value"=>"Los Angeles", "state_value"=>"CA", "zip_value"=>"90016", "country_value"=>"US", "telephone_value"=>"310-936-0364", "company_value"=>"Luma, Inc."}, "persona_4"=>{"enable"=>false, "label"=>"Jack Fitz (Buyer)", "email_value"=>"jack@example.com", "password_value"=>"Password1", "firstname_value"=>"Jack", "lastname_value"=>"Fitz", "address_value"=>"3640 Holdrege Ave", "city_value"=>"Los Angeles", "state_value"=>"CA", "zip_value"=>"90016", "country_value"=>"US", "telephone_value"=>"310-937-0368", "company_value"=>"Luma, Inc."}}}}, "module-magento-framework-data-collection"=>{"vendor"=>"skukla", "version"=>"dev-master", "repository_url"=>"https://github.com/skukla/module-magento-framework-data-collection.git"}, "theme-frontend-custom"=>{"vendor"=>"skukla", "version"=>"dev-master", "repository_url"=>"git@github.com:skukla/theme-frontend-custom.git"}}}, "application"=>{"authentication"=>{"composer"=>{"username"=>"b17aa908c13768cef2a5a3a043bb3c54", "password"=>"93f1f71fd779eb46af01fd7587e5fdba", "github_token"=>"ca5db95d8f9ebea677be19b5943475882682e1d7"}, "ssh"=>{"private_key_files"=>["id_rsa.skukla.gitlab"], "public_key_files"=>["id_rsa.skukla.gitlab.pub"]}}, "installation"=>{"options"=>{"family"=>"Commerce", "version"=>"2.3.4", "directory"=>"/var/www/magento", "download"=>{"base_code"=>true, "b2b_code"=>true, "custom_modules"=>true, "modules_to_remove"=>{"temando"=>{"module"=>"module-shipping"}, "magento"=>{"module"=>"google-shopping-ads"}}}, "install"=>true, "sample_data"=>false, "deploy_mode"=>{"apply"=>true, "mode"=>"production"}, "patches"=>{"apply"=>true, "repository_url"=>"https://github.com/PMET-public/magento-cloud.git"}, "configuration"=>{"base"=>true, "b2b"=>true, "custom_modules"=>true, "admin_users"=>true}}, "settings"=>{"backend_frontname"=>"admin", "language"=>"en_US", "currency"=>"USD", "admin_firstname"=>"Admin", "admin_lastname"=>"Admin", "admin_email"=>"admin@luma.com", "admin_user"=>"admin", "admin_password"=>"admin4tls", "use_rewrites"=>true, "use_secure_frontend"=>true, "use_secure_admin"=>false, "cleanup_database"=>true, "session_save"=>"db"}}, "configuration"=>{"general"=>{"store_information"=>{"name"=>{"scopes"=>{"store"=>{"value"=>"Luma, Inc.", "code"=>"default"}}}, "phone"=>{"scopes"=>{"store"=>{"value"=>"1-310-945-0345", "code"=>"default"}}}, "hours"=>{"scopes"=>{"store"=>{"value"=>"9AM - 5PM", "code"=>"default"}}}, "street_line1"=>{"scopes"=>{"website"=>{"value"=>"Luma, Inc.", "code"=>"base"}}}, "street_line2"=>{"scopes"=>{"website"=>{"value"=>"3640 Holdrege Ave", "code"=>"base"}}}, "city"=>{"scopes"=>{"website"=>{"value"=>"Los Angeles", "code"=>"base"}}}, "region_id"=>{"scopes"=>{"website"=>{"value"=>"CA", "code"=>"base"}}}, "postcode"=>{"scopes"=>{"website"=>{"value"=>"90016", "code"=>"base"}}}, "country_id"=>{"scopes"=>{"website"=>{"value"=>"US", "code"=>"base"}}}}}, "cms"=>{"pagebuilder"=>{"google_maps_api_key"=>"AIzaSyCUpro8_IIHqsD1WKzadd2U0BJKsJDCrqk"}}, "btob"=>{"website_configuration"=>{"company_active"=>{"scopes"=>{"website"=>{"value"=>true, "code"=>"base"}}}, "sharedcatalog_active"=>{"scopes"=>{"website"=>{"value"=>true, "code"=>"base"}}}, "negotiablequote_active"=>{"scopes"=>{"website"=>{"value"=>true, "code"=>"base"}}}, "quickorder_active"=>{"scopes"=>{"website"=>{"value"=>true, "code"=>"base"}}}, "requisition_list_active"=>{"scopes"=>{"website"=>{"value"=>true, "code"=>"base"}}}}}, "catalog"=>{"youtube_api_key"=>"AIzaSyAIqr8akHR1G3qh9Z8vvJI34iITe59G3h0"}, "customer"=>{"startup"=>{"redirect_dashboard"=>true}}, "shipping"=>{"origin"=>{"street_line1"=>{"scopes"=>{"website"=>{"value"=>"3640 Holdrege Ave", "code"=>"base"}}}, "city"=>{"scopes"=>{"website"=>{"value"=>"Los Angeles", "code"=>"base"}}}, "region_id"=>{"scopes"=>{"website"=>{"value"=>"CA", "code"=>"base"}}}, "postcode"=>{"scopes"=>{"website"=>{"value"=>"90016", "code"=>"base"}}}, "country_id"=>{"scopes"=>{"website"=>{"value"=>"US", "code"=>"base"}}}}}, "carriers"=>{"ups"=>{"active"=>{"scopes"=>{"website"=>{"value"=>true, "code"=>"base"}}}, "username"=>{"scopes"=>{"website"=>{"value"=>"magento", "code"=>"base"}}}, "password"=>{"scopes"=>{"website"=>{"value"=>"magento200", "code"=>"base"}}}, "access_license_number"=>{"scopes"=>{"website"=>{"value"=>"ECAB751ABF189ECA", "code"=>"base"}}}, "shipper_number"=>{"scopes"=>{"website"=>{"value"=>"207W88", "code"=>"base"}}}, "allowed_methods"=>{"scopes"=>{"website"=>{"value"=>["Ground", "Next Day Air"], "code"=>"base"}}}}, "flatrate"=>{"active"=>true}}, "payment"=>{"braintree"=>{"active"=>true, "merchant_account_id"=>"magento", "merchant_id"=>"zkw2ctrkj75ndvkc", "public_key"=>"n2bt4844t6xrt56x", "private_key"=>"e6c98fd99fe699d4169475fef026d5b9", "payment_action"=>"authorize", "cctypes"=>["Visa", "MasterCard"]}, "companycredit"=>{"active"=>{"scopes"=>{"website"=>{"value"=>true, "code"=>"base"}}}}, "checkmo"=>{"active"=>false}}}}, "infrastructure"=>{"os"=>{"update"=>false}, "php"=>{"version"=>"7.3", "fpm_port"=>9000, "memory_limit"=>"2G", "upload_max_filesize"=>"2M", "timezone"=>"America/Los_Angeles"}, "webserver"=>{"http_port"=>80, "ssl_port"=>443}, "database"=>{"host"=>"localhost", "user"=>"magento", "password"=>"password", "name"=>"magento"}, "elasticsearch"=>{"use"=>true, "version"=>"6.x", "memory"=>"1g", "port"=>9200, "plugins"=>["analysis-phonetic", "analysis-icu"]}, "mailhog"=>{"use"=>true, "port"=>10000}, "webmin"=>{"use"=>true, "port"=>20000}, "samba"=>{"use"=>true, "shares"=>{"composer_credentials"=>true, "web_root"=>true, "image_drop"=>true, "application_modules"=>true, "multisite_configuration"=>true, "application_design"=>true}}}, "vm"=>{"ip"=>"192.168.57.11", "url"=>"luma.com", "name"=>"Luma VM"}, "provisioner"=>{"type"=>"chef_zero", "nodes_path"=>"nodes", "data_bags_path"=>"data_bags", "environments_path"=>"environments", "roles_path"=>"roles", "cookbooks_path"=>"cookbooks"}, "remote_machine"=>{"name"=>"Kukla-Machine", "user"=>"vagrant", "box"=>"bento/ubuntu-18.04", "cpus"=>2, "ram"=>4096, "vram"=>16, "provider"=>{"vmware"=>{"gui"=>true, "linked_clones"=>true, "eth0_pcislotnumber"=>32, "eth1_pcislotnumber"=>33}, "virtualbox"=>{"gui"=>false, "linked_clones"=>false, "remote_display"=>"off", "default_nic_type"=>"82543GC", "auto_update"=>false}}}, "vagrant"=>{"provider"=>"virtualbox", "plugins"=>{"all"=>["vagrant-hostsupdater"], "vmware"=>["vagrant-vmware-desktop"], "virtualbox"=>["vagrant-vbguest"]}}})
