#
# Cookbook:: custom_modules
# Attribute:: override
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
if node[:custom_demo][:custom_modules].is_a? Chef::Node::ImmutableMash
    override[:custom_modules][:module_list] = node[:custom_demo][:custom_modules]
end