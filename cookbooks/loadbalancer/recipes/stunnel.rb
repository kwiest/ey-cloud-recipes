ey_cloud_report "load balancer stunnel" do
  message 'building stunnel'
end

#Yuck
bash "download stunnel" do
  code "cd /engineyard/portage/distfiles && wget https://ey-cloud-misc-files.s3.amazonaws.com/stunnel-4.33.tar.gz"
  not_if "ls /engineyard/portage/distfiles/stunnel-4.33.tar.gz"
end

overlay 'net-misc/stunnel' do
  ebuild 'stunnel-4.33.ebuild'

  files %w[ stunnel-4.21-libwrap.patch stunnel-4.33-exceliance-aloha-sendproxy.patch stunnel.conf stunnel.rc6 ]
end

package 'net-misc/stunnel' do
  version '4.33'
  action :install
end

service "stunnel" do
  action :enable
  supports :restart => true, :status => true
end

template "/etc/stunnel/stunnel.conf" do
  owner 'root'
  group 'root'
  mode 0644
  source "stunnel.conf.erb"
  variables :app => node.engineyard.apps.detect { |a| a.https? }
  notifies :restart, resources(:service => "stunnel"), :immediately
  notifies :run, resources(:execute => 'reload-haproxy'), :immediately
end
