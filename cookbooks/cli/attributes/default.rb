#
# Cookbook:: cli
# Attribute:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
user = node[:remote_machine][:user]
default[:cli][:directories] = [
    {path: "/home/#{user}/cli", mode: "770"},
    {path: "home/#{user}/cli/scripts", mode: "777"}
]
default[:cli][:files] = [
    {source: ".bashrc", path: "/home/#{user}/.bashrc", mode: "644"}, 
    {source: "show_help.sh", path: "/home/#{user}/cli/scripts/show_help.sh", mode: "777"},
    {source: "cache_warmer.sh", path: "/home/#{user}/cli/scripts/cache_warmer.sh", mode: "777"}
]