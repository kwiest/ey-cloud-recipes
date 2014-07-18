template "/home/#{node[:owner_name]}/.bashrc" do
    owner node[:owner_name]
    group node[:owner_name]
    mode 0644
    source ".bashrc.erb"
    variables({
      :php_env => node[:environment][:framework_env],
      :user => node[:owner_name],
      :dbuser => node[:owner_name],
      :dbpass => node[:owner_pass],
      :dbhost => node[:db_host],
    })
    not_if "grep DB_HOST /home/deploy/.bashrc"
  end
