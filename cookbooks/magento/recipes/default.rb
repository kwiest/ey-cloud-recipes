#
# Cookbook Name:: magento
# Recipe:: default
#
# 
#  
app_name = "magtest" 
key_name = '0e0a307224ae08c01ab13c1d15581d6c'

if ['solo', 'app', 'app_master'].include?(node[:instance_role])
    template "/data/#{app_name}/current/app/etc/local.xml" do
    owner node[:owner_name]
    group node[:owner_name]
    mode 0644
    source "local.xml.erb"
    variables({
      :app_name => app_name,
      :dbuser => node[:owner_name],
      :dbpass => node[:owner_pass],
      :dbhost => node[:db_host],
      :key => key_name
    })

  end
  
end
  