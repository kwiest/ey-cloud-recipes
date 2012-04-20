swap_allocation_desired = 2097152 # 2GB in KB

ruby_block "add-swap" do
  block do
    if File.exists?("/dev/sdb") && !File.exists?("/dev/sdc") # No Swap exists.
      Chef::Log.info "Swap allocated by /mnt/engineyard/swapfile blocks: #{swap_allocation_desired}"
      system("/bin/bash -c 'mkdir -p /mnt/engineyard && dd if=/dev/zero of=/mnt/engineyard/swapfile bs=1024 count=#{swap_allocation_desired}'")
      system('mkswap /mnt/engineyard/swapfile')
      system('swapon /mnt/engineyard/swapfile')
      system('echo "/mnt/engineyard/swapfile swap swap sw 0 0 " >> /etc/fstab')
      if File.exists?("/dev/sdc")
        Chef::Log.info "Swap allocated by /dev/sdc blocks: #{swap_allocation_desired}"
        system("/bin/bash -c 'echo-e \"unit: sectors\n/dev/sdc1 : start=63, size=#{swap_allocation_desired}, Id=82\" | sfdisk --force /dev/sdc'")
        system('mkswap /dev/sdc1')
        system('swapon /dev/sdc1')
        system('echo "/dev/sdc1 swap swap sw 0 0 ">> /etc/fstab')
      else
        Chef::Log.info "If you are seeing this message, please create a ticket with support and attach this chef log to the ticket"
      end
    end
  end
  only_if {  node[:kernel][:machine] == 'x86_64' and node[:memory][:swap][:total] == '0kB' }
end
