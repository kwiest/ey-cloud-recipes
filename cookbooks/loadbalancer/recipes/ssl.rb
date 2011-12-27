ey_cloud_report "load balancer" do
  message 'generating ssl certs'
end

directory "/etc/nginx/ssl" do
  owner node.engineyard.ssh_username
  group node.engineyard.ssh_username
  mode 0775
end

node.engineyard.environment.apps.sort_by {|a,b| a.name}.each do |app|
  if app.https?
    cert = app.vhosts.first.ssl_cert

    template "/etc/nginx/ssl/#{app.name}.key" do
      owner node[:owner_name]
      group node[:owner_name]
      mode 0644
      source "sslkey.erb"
      variables(
        :key => cert.private_key
      )
      backup 0
      notifies :run, resources(:execute => 'reload-haproxy'), :delayed
    end

    template "/etc/nginx/ssl/#{app.name}.crt" do
      owner node[:owner_name]
      group node[:owner_name]
      mode 0644
      source "sslcrt.erb"
      variables(
        :crt => cert.certificate,
        :chain => cert.certificate_chain
      )
      backup 0
      notifies :run, resources(:execute => 'reload-haproxy'), :delayed
    end
  end
end
