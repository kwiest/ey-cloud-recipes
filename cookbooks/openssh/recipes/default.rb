
#
# Cookbook Name:: openssh
# Recipe:: default
#

 ssh_file = "openssh-#{node["openssh"]["version"]}.tar.gz"
 ssh_dir = "openssh-#{node["openssh"]["version"]}"
 ssh_url = "http://ftp3.usa.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-#{node["openssh"]["version"]}.tar.gz"


  remote_file "/opt/#{ssh_file}" do
      source "#{ssh_url}"
      owner node[:owner_name]
      group node[:owner_name]
      mode 0644
      backup 0
      not_if { FileTest.exists?("/opt/#{ssh_file}") }
  end

  execute "unarchive ssh" do
    command "cd /opt && tar zxf #{ssh_file} && sync"
    not_if { FileTest.directory?("/opt/#{ssh_dir}") }
  end

  execute "install ssh" do
    command "cd /opt/#{ssh_dir} && ./configure --prefix=/usr && make && make install"
    not_if { FileTest.exists?("/opt/#{ssh_dir}/ssh") }
  end

  execute "restart ssh" do
    command "pgrep -P 1 sshd | xargs kill -9 && /etc/init.d/sshd zap && /etc/init.d/sshd start"
    not_if { FileTest.exists?("/opt/#{ssh_dir}/ssh") }
  end
