#
# Cookbook Name:: openssh_5.9p1
# Recipe:: default
#

ssh_desiredversion = "openssh-5.9p1"

  if ssh_desiredversion == "openssh-5.9p1"
    ssh_file = "openssh-5.9p1.tar.gz"
    ssh_dir = "openssh-5.9p1"
    ssh_url = "http://ftp3.usa.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-5.9p1.tar.gz"
  end

  remote_file "/data/#{ssh_file}" do
      source "#{ssh_url}"
      owner node[:owner_name]
      group node[:owner_name]
      mode 0644
      backup 0
      not_if { FileTest.exists?("/data/#{ssh_file}") }
  end
    
  execute "unarchive ssh" do
    command "cd /data && tar zxf #{ssh_file} && sync"
    not_if { FileTest.directory?("/data/#{ssh_dir}") }
  end
    
  execute "install ssh " do
    command "cd /data/#{ssh_dir} && ./configure --prefix=/usr && make && make install"
  end
  
