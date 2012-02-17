define :collectd_disk_alert do
  mount = params[:disk]
  warning_size = params[:warning]
  failure_size = params[:failure]

  template "/etc/engineyard/#{mount}.disk.collectd.conf" do
    owner 'root'
    group 'root'
    mode 0644
    source "disk.conf.erb"
    variables({
      :mount => mount,
      :warning => warning_size,
      :failure => failure_size
    })
  end

  execute "Include the new config" do
    command "echo \"Include /etc/engineyard/#{mount}.disk.collectd.conf\" >> /etc/engineyard/collectd.conf"
    # not_if { "grep '#{mount}.disk.collectd.conf' /etc/engineyard/collectd.conf" }
    action :run
  end

  # Kill collectd (violently) to ensure that it has a fresh config
  execute "ensure-collectd-has-fresh-config" do
    command %Q{
      pkill -9 collectd;true
    }
    action :run
  end
end
