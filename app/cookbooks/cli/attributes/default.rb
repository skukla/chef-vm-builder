#
# Cookbook:: cli
# Attribute:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
default[:cli][:directories] = [
    {path: "cli", mode: "770"}
]
default[:cli][:files] = [
    {source: ".bashrc", path: "", mode: "644"}
]