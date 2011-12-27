# Expect this to run before haproxy::install
#

# We need to do an execute here because a service
# definition requires the init.d file to be in
# place at by this point. And since we configure first
# it won't be on clean instances
execute "reload-haproxy" do
  command "/etc/init.d/haproxy reload"
  action :nothing
end

directory "/etc/haproxy/errorfiles" do
  action :create
  owner 'root'
  group 'root'
  mode 0755
  recursive true
end

["400.http","403.http","408.http","500.http","502.http","503.http","504.http"].each do |p|
  remote_file "/etc/haproxy/errorfiles/#{p}" do
    owner 'root'
    group 'root'
    mode 0644
    backup 0
    source "errorfiles/#{p}"
    not_if { File.exists?("/etc/haproxy/errorfiles/keep.#{p}") }
  end
end

template "/etc/haproxy.cfg" do
  owner 'root'
  group 'root'
  mode 0644
  source "haproxy.cfg.erb"
  variables({
    :stunneled => true,
    :backends => node[:members],
    :haproxy_user => node[:haproxy][:username],
    :haproxy_pass => node[:haproxy][:password]
  })

  # We need to reload to activate any changes to the config
  # but delay it as haproxy may not be installed yet
  notifies :run, resources(:execute => 'reload-haproxy'), :delayed
end
