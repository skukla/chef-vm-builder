#
# Cookbook:: vm_cli
# Attribute:: default
#
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
default[:vm_cli][:directories] = [
    {path: "cli", mode: "770"}
]
default[:vm_cli][:files] = [
    {source: ".bashrc", path: "", mode: "644"}
]