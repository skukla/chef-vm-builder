name "vm"
description "Configuration file for the Kukla Demo VM"
default_attributes({"vm"=>{"ip"=>"192.168.57.11", "name"=>"Luma VM", "provider"=>"virtualbox"}, "custom_demo"=>{"structure"=>{"website"=>{"base"=>"luma.com", "luma_b2b"=>"b2b.luma.com", "custom_b2c"=>"custom-demo.com", "custom_b2b"=>"b2b.custom-demo.com"}, "store_view"=>{"luma_de"=>"luma.de"}}, "admin_users"=>{"user_1"=>{"first_name"=>"Christine", "last_name"=>"Jacobs", "username"=>"christine", "password"=>"Password1", "email"=>"christine@luma.com"}, "user_2"=>{"first_name"=>"Fred", "last_name"=>"Mills", "username"=>"fred", "password"=>"Password1", "email"=>"fred@luma.com"}, "user_3"=>{"first_name"=>"Bill", "last_name"=>"Thomas", "username"=>"bill", "password"=>"Password1", "email"=>"bill@luma.com"}, "user_4"=>{"first_name"=>"Shelly", "last_name"=>"Smith", "username"=>"shelly", "password"=>"Password1", "email"=>"shelly@luma.com"}, "user_5"=>{"first_name"=>"Phil", "last_name"=>"Baker", "username"=>"phil", "password"=>"Password1", "email"=>"phil@luma.com"}}, "custom_modules"=>{"module-sctools"=>{"vendor"=>"magentoese", "version"=>"dev-master", "repository_url"=>"git@github.com:PMET-public/module-sctools.git"}, "module-themecustomizer"=>{"vendor"=>"magentoese", "version"=>"dev-master", "repository_url"=>"git@github.com:PMET-public/module-themecustomizer.git"}, "module-autofill"=>{"vendor"=>"magentoese", "version"=>"dev-master", "repository_url"=>"git@github.com:PMET-public/module-autofill.git", "configuration"=>{"magentoese_autofill"=>{"persona_1"=>{"enable"=>true, "label"=>"Steve Kukla (Test User)", "email_value"=>"steve@example.com", "password_value"=>"Password1", "firstname_value"=>"Steve", "lastname_value"=>"Kukla", "address_value"=>"3640 Holdrege Ave", "city_value"=>"Los Angeles", "state_value"=>"CA", "zip_value"=>"90016", "country_value"=>"US", "telephone_value"=>"310-945-0345", "company_value"=>"Luma, Inc."}, "persona_2"=>{"enable"=>false, "label"=>"Michelle Ortiz (Purchasing Agent)", "email_value"=>"michelle@example.com", "password_value"=>"Password1", "firstname_value"=>"Michelle", "lastname_value"=>"Ortiz", "address_value"=>"3640 Holdrege Ave", "city_value"=>"Los Angeles", "state_value"=>"CA", "zip_value"=>"90016", "country_value"=>"US", "telephone_value"=>"310-932-0362", "company_value"=>"Luma, Inc."}, "persona_3"=>{"enable"=>false, "label"=>"Casey Kendall (Floor Manager)", "email_value"=>"casey@example.com", "password_value"=>"Password1", "firstname_value"=>"Casey", "lastname_value"=>"Kendall", "address_value"=>"3640 Holdrege Ave", "city_value"=>"Los Angeles", "state_value"=>"CA", "zip_value"=>"90016", "country_value"=>"US", "telephone_value"=>"310-936-0364", "company_value"=>"Luma, Inc."}, "persona_4"=>{"enable"=>false, "label"=>"Jack Fitz (Buyer)", "email_value"=>"jack@example.com", "password_value"=>"Password1", "firstname_value"=>"Jack", "lastname_value"=>"Fitz", "address_value"=>"3640 Holdrege Ave", "city_value"=>"Los Angeles", "state_value"=>"CA", "zip_value"=>"90016", "country_value"=>"US", "telephone_value"=>"310-937-0368", "company_value"=>"Luma, Inc."}}}}, "theme-frontend-custom"=>{"vendor"=>"skukla", "version"=>"dev-master", "repository_url"=>"git@github.com:skukla/theme-frontend-custom.git"}}}, "application"=>{"authentication"=>{"composer"=>{"username"=>"b17aa908c13768cef2a5a3a043bb3c54", "password"=>"93f1f71fd779eb46af01fd7587e5fdba", "github_token"=>"ca5db95d8f9ebea677be19b5943475882682e1d7"}}, "installation"=>{"options"=>{"family"=>"Commerce", "version"=>"2.3.4", "directory"=>"/var/www/magento", "download"=>{"base_code"=>true, "b2b_code"=>true, "custom_modules"=>true}, "modules_to_remove"=>["temando/module-shipping", "magento/google-shopping-ads"], "install"=>true, "sample_data"=>false, "deploy_mode"=>{"apply"=>true, "mode"=>"production"}, "patches"=>{"apply"=>true, "repository_url"=>"https://github.com/PMET-public/magento-cloud.git"}, "configuration"=>{"base"=>true, "b2b"=>true, "custom_modules"=>true, "admin_users"=>true}}, "settings"=>{"backend_frontname"=>"admin", "language"=>"en_US", "currency"=>"USD", "admin_firstname"=>"Admin", "admin_lastname"=>"Admin", "admin_email"=>"admin@luma.com", "admin_user"=>"admin", "admin_password"=>"admin4tls", "use_rewrites"=>true, "use_secure_frontend"=>true, "use_secure_admin"=>false, "cleanup_database"=>true, "session_save"=>"db", "key"=>"5fb338b139111ece4fd8d80fabc900b5"}}, "configuration"=>{"general"=>{"store_information"=>{"name"=>{"website"=>{"base"=>"Luma, Inc."}}, "phone"=>{"store_view"=>{"default"=>"1-310-945-0345"}}, "hours"=>{"store_view"=>{"default"=>"9AM - 5PM"}}, "street_line1"=>{"website"=>{"base"=>"Luma, Inc."}}, "street_line2"=>{"website"=>{"base"=>"3640 Holdrege Ave"}}, "city"=>{"website"=>{"base"=>"Los Angeles"}}, "region_id"=>{"website"=>{"base"=>"CA"}}, "postcode"=>{"website"=>{"base"=>"90016"}}, "country_id"=>{"website"=>{"base"=>"US"}}}}, "cms"=>{"pagebuilder"=>{"google_maps_api_key"=>"AIzaSyCUpro8_IIHqsD1WKzadd2U0BJKsJDCrqk"}}, "btob"=>{"website_configuration"=>{"company_active"=>{"website"=>{"base"=>true}}, "sharedcatalog_active"=>{"website"=>{"base"=>true}}, "negotiablequote_active"=>{"website"=>{"base"=>true}}, "quickorder_active"=>{"website"=>{"base"=>true}}, "requisition_list_active"=>{"website"=>{"base"=>true}}}}, "catalog"=>{"youtube_api_key"=>"AIzaSyAIqr8akHR1G3qh9Z8vvJI34iITe59G3h0"}, "customer"=>{"startup"=>{"redirect_dashboard"=>true}}, "shipping"=>{"origin"=>{"street_line1"=>{"website"=>{"base"=>"3640 Holdrege Ave"}}, "city"=>{"website"=>{"base"=>"Los Angeles"}}, "region_id"=>{"website"=>{"base"=>"CA"}}, "postcode"=>{"website"=>{"base"=>"90016"}}, "country_id"=>{"website"=>{"base"=>"US"}}}}, "carriers"=>{"flatrate"=>true}, "payment"=>{"checkmo"=>{"active"=>false}, "companycredit"=>{"active"=>{"website"=>{"base"=>false}}}}}}, "infrastructure"=>{"os"=>{"update"=>false, "timezone"=>"America/Los_Angeles"}, "php"=>{"version"=>"7.3", "port"=>9000, "memory_limit"=>"2G", "upload_max_filesize"=>"2M"}, "database"=>{"host"=>"localhost", "user"=>"magento", "password"=>"password", "name"=>"magento"}, "webserver"=>{"http_port"=>80, "ssl_port"=>443, "ssl_locality"=>"Los Angeles", "ssl_region"=>"CA", "ssl_country"=>"US"}, "elasticsearch"=>{"use"=>true, "version"=>"6.x", "memory"=>"1G", "plugins"=>["analysis-phonetic", "analysis-icu"]}, "mailhog"=>{"use"=>false, "port"=>10000}, "webmin"=>{"use"=>true, "port"=>20000}, "samba"=>{"use"=>true, "shares"=>{"web_root"=>"/var/www/magento", "image_drop"=>"/var/www/magento/var/import/images"}}}, "provisioner"=>{"type"=>"chef_zero", "nodes_path"=>"nodes", "data_bags_path"=>"data_bags", "environments_path"=>"environments", "roles_path"=>"roles", "cookbooks_path"=>"cookbooks"}, "remote_machine"=>{"name"=>"Kukla-Machine", "user"=>"vagrant", "box"=>"bento/ubuntu-18.04", "cpus"=>2, "ram"=>4096, "vram"=>16, "provider"=>{"vmware"=>{"gui"=>true, "linked_clones"=>true, "eth0_pcislotnumber"=>32, "eth1_pcislotnumber"=>33}, "virtualbox"=>{"gui"=>false, "linked_clones"=>false, "remote_display"=>"off", "default_nic_type"=>"82543GC", "auto_update"=>false}}}, "vagrant"=>{"plugins"=>{"all"=>["vagrant-hostsupdater", "vagrant-vbguest"], "vmware"=>["vagrant-vmware-desktop"], "virtualbox"=>["vagrant-vbguest"]}}})
