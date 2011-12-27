# Expects configuration to already be done.
#
# FIXME: remove overlay once ebuilds are present in-tree
#

enable_package 'net-proxy/haproxy' do
  version node.haproxy_version
end

package 'net-proxy/haproxy' do
  version node.haproxy_version
  action :install
end

service 'haproxy' do
  action :enable
  supports :status => true, :restart => true, :start => true
  subscribes :restart, resources(:package => 'net-proxy/haproxy'), :immediately
end
