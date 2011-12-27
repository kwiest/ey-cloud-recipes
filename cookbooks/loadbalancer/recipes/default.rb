ey_cloud_report "load balancer" do
  message 'processing load balancer'
end

# We do the configure first so we get the correct config.
# The install recipe expects to be called second
# and will likely fail on clean instances if it's put first
if node[:instance_role] == "util" && node[:name] == "loadbalancer"
  require_recipe 'loadbalancer::configure'
  require_recipe 'loadbalancer::install' unless node[:quick]
  require_recipe 'loadbalancer::ssl'
  require_recipe 'loadbalancer::stunnel'
end
