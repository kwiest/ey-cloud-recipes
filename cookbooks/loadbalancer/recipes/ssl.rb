ey_cloud_report "load balancer" do
  message 'generating ssl certs'
end

directory "/etc/nginx/ssl" do
  owner node.engineyard.ssh_username
  group node.engineyard.ssh_username
  mode 0775
end

node[:applications].map {|k,v| [k,v] }.sort_by {|a,b| a }.each do |app, data|
  template "/etc/nginx/ssl/#{app}.key" do
    owner node[:owner_name]
    group node[:owner_name]
    mode 0644
    source "sslkey.erb"
    variables(
      :key => data[:vhosts][1][:key]
    )
    backup 0
    notifies :restart, resources(:service => "haproxy"), :delayed
  end

  template "/etc/nginx/ssl/#{app}.crt" do
    owner node[:owner_name]
    group node[:owner_name]
    mode 0644
    source "sslcrt.erb"
    variables(
      :crt => data[:vhosts][1][:crt],
      :chain => data[:vhosts][1][:chain]
    )
    backup 0
    notifies :restart, resources(:service => "haproxy"), :delayed
  end
end
