#
# Cookbook:: magento_demo_builder
# Attribute:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
default[:magento_demo_builder][:chef_files][:path] = "/var/chef/cache/cookbooks/magento_demo_builder/files/default"
default[:magento_demo_builder][:demo_shell][:path] = "vendor/skukla/module-custom-demo-shell"
default[:magento_demo_builder][:demo_shell][:patch_class] = %q[Skukla\CustomDemoShell\Setup\Patch\Data]
default[:magento_demo_builder][:demo_shell][:fixtures_path] = "fixtures"
default[:magento_demo_builder][:demo_shell][:files] = [
    {source: "composer.json", path: "", mode: "664"}, 
    {source: "Install.php", path: "Setup/Patch/Data", mode: "664"},
    {source: "InstallStore.php", path: "Setup/Patch/Data", mode: "644"}
]
default[:magento_demo_builder][:demo_shell][:media_map] = {
    catalog: {
        module: "media/catalog/product",
        codebase: "pub/media/catalog/product"
    },
    wysiwyg: {
        module: "media/wysiwyg",
        codebase: "pub/media/wysiwyg"
    },
    favicon: {
        module: "media/favicon",
        codebase: "pub/media/favicon"
    },
    logo: {
        module: "media/logo",
        codebase: "pub/media/logo"
    },
    theme: {
        module: "media/theme",
        codebase: "vendor/magento/theme-frontend-luma/etc"
    },
    template_manager: {
        module: "media/.template-manager",
        codebase: "pub/media/.template-manager"
    },
    downloadable_products: {
        module: "media/downloadable_products",
        codebase: "pub/media/import"
    }
}