#
# Cookbook:: cli
# Attribute:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
default[:cli][:directories] = [
    {path: "cli", mode: "770"},
    {path: "cli/scripts", mode: "777"}
]
default[:cli][:files] = [
    {source: ".bashrc", path: "", mode: "644"}, 
    {source: "show_help.sh", path: "cli/scripts", mode: "777"},
    {source: "cache_warmer.sh", path: "cli/scripts", mode: "777"}
]