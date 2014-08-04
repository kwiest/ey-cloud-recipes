
#
# Cookbook Name:: openssh-6.6p1
# Recipe:: default
#

ssh_desiredversion = "openssh-6.6p1"

  if ssh_desiredversion == "openssh-6.6p1"
    ssh_file = "openssh-6.6p1.tar.gz"
    ssh_dir = "openssh-6.6p1"
    ssh_url = "http://ftp3.usa.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-6.6p1.tar.gz"
  end

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
