define :collectd_load_alert do
  mount = params[:load]
  warning_size = params[:warning]
  failure_size = params[:failure]
  config_file = params[:config] || "/etc/engineyard/#{mount}.disk.collectd.conf"

  template config_file do
    owner 'root'
    group 'root'
    mode 0644
    source "load.conf.erb"
    variables({
      :mount => mount,
      :warning => warning_threshold,
      :failure => failure_threshold
    })
  end

  execute "Include the new config" do
    command 'echo "Include \"'+config_file+'\"" >> /etc/engineyard/collectd.conf'
    notifies :run, "execute[ensure-collectd-has-fresh-config]"
    not_if { "grep '#{mount}.disk.collectd.conf' /etc/engineyard/collectd.conf" }
  end

  # Kill collectd (violently) to ensure that it has a fresh config
  execute "ensure-collectd-has-fresh-config" do
    command %Q{
      pkill -9 collectd;true
    }
  end
end