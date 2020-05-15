name "vm"
description "Configuration file for the Kukla Demo VM"
default_attributes({"vm"=>{"ip"=>"192.168.57.11", "name"=>"Luma Demo", "provider"=>"virtualbox"}, "custom_demo"=>{"structure"=>{"website"=>{"base"=>"luma.demo"}}, "admin_users"=>{"user_1"=>{"first_name"=>"Christine", "last_name"=>"Jacobs", "username"=>"christine", "password"=>"Password1", "email"=>"christine@luma.com"}, "user_2"=>{"first_name"=>"Fred", "last_name"=>"Mills", "username"=>"fred", "password"=>"Password1", "email"=>"fred@luma.com"}, "user_3"=>{"first_name"=>"Bill", "last_name"=>"Thomas", "username"=>"bill", "password"=>"Password1", "email"=>"bill@luma.com"}, "user_4"=>{"first_name"=>"Shelly", "last_name"=>"Smith", "username"=>"shelly", "password"=>"Password1", "email"=>"shelly@luma.com"}, "user_5"=>{"first_name"=>"Phil", "last_name"=>"Baker", "username"=>"phil", "password"=>"Password1", "email"=>"phil@luma.com"}}}, "application"=>{"authentication"=>{"composer"=>{"username"=>"b17aa908c13768cef2a5a3a043bb3c54", "password"=>"93f1f71fd779eb46af01fd7587e5fdba", "github_token"=>"ca5db95d8f9ebea677be19b5943475882682e1d7"}}, "installation"=>{"options"=>{"family"=>"Commerce", "version"=>"2.3.5-p1"}, "build"=>{"install"=>true, "base_code"=>true, "b2b_code"=>true, "custom_modules"=>true, "sample_data"=>true, "modules_to_remove"=>"magento/google-shopping-ads", "deploy_mode"=>true, "patches"=>false, "configuration"=>{"base"=>true, "b2b"=>true, "custom_modules"=>true, "admin_users"=>true}}, "settings"=>{"language"=>"en_US", "currency"=>"USD", "admin_firstname"=>"Steve", "admin_lastname"=>"Kukla", "admin_email"=>"admin@luma.com", "admin_user"=>"admin", "admin_password"=>"admin4tls"}}, "configuration"=>{"general"=>{"store_information"=>{"name"=>{"website"=>{"base"=>"Luma, Inc."}}, "phone"=>{"store_view"=>{"default"=>"1-310-945-0345"}}, "hours"=>{"store_view"=>{"default"=>"9AM - 5PM"}}, "street_line1"=>{"website"=>{"base"=>"Luma, Inc."}}, "street_line2"=>{"website"=>{"base"=>"3640 Holdrege Ave"}}, "city"=>{"website"=>{"base"=>"Los Angeles"}}, "region_id"=>{"website"=>{"base"=>"CA"}}, "postcode"=>{"website"=>{"base"=>"90016"}}, "country_id"=>{"website"=>{"base"=>"US"}}}}, "design"=>{"header"=>{"welcome"=>""}}, "cms"=>{"pagebuilder"=>{"google_maps_api_key"=>""}}, "btob"=>{"website_configuration"=>{"company_active"=>{"website"=>{"base"=>false}}, "sharedcatalog_active"=>{"website"=>{"base"=>false}}, "negotiablequote_active"=>{"website"=>{"base"=>false}}, "quickorder_active"=>{"website"=>{"base"=>false}}, "requisition_list_active"=>{"website"=>{"base"=>false}}}}, "catalog"=>{"youtube_api_key"=>""}, "customer"=>{"startup"=>{"redirect_dashboard"=>false}}, "shipping"=>{"origin"=>{"street_line1"=>{"website"=>{"base"=>"3640 Holdrege Ave"}}, "city"=>{"website"=>{"base"=>"Los Angeles"}}, "region_id"=>{"website"=>{"base"=>"CA"}}, "postcode"=>{"website"=>{"base"=>"90016"}}, "country_id"=>{"website"=>{"base"=>"US"}}}}, "carriers"=>{"flatrate"=>false}, "payment"=>{"checkmo"=>{"active"=>true}, "companycredit"=>{"active"=>{"website"=>{"base"=>true}}}}}}, "infrastructure"=>{"php"=>"7.3", "elasticsearch"=>true, "mailhog"=>true, "samba"=>true}, "provisioner"=>{"type"=>"chef_zero", "nodes_path"=>"nodes", "data_bags_path"=>"data_bags", "environments_path"=>"environments", "roles_path"=>"roles", "cookbooks_path"=>"cookbooks"}, "remote_machine"=>{"name"=>"Kukla-Machine", "box"=>"bento/ubuntu-18.04", "cpus"=>2, "ram"=>4096, "vram"=>16, "provider"=>{"vmware"=>{"gui"=>true, "linked_clones"=>true, "eth0_pcislotnumber"=>32, "eth1_pcislotnumber"=>33}, "virtualbox"=>{"gui"=>false, "linked_clones"=>false, "remote_display"=>"off", "default_nic_type"=>"82543GC", "auto_update"=>false}}}, "vagrant"=>{"plugins"=>{"all"=>["vagrant-multi-hostsupdater"], "vmware"=>["vagrant-vmware-desktop"]}}})
