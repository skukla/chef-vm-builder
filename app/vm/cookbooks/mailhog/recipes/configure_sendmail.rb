# Cookbook:: mailhog
# Recipe:: configure_sendmail
# Copyright:: 2020, Steve Kukla, All Rights Reserved.
# frozen_string_literal: true

php 'Configure mailhog sendmail path and restart PHP' do
  action %i[configure_sendmail restart]
end
