define :overlay, :portage_path => '/engineyard/portage/engineyard', :files => [] do

  portage_path = params[:portage_path]
  ebuild_name  = params[:name]
  ebuild_file  = params[:ebuild]
  ebuild_dir   = File.join(portage_path, ebuild_name)
  files_dir    = File.join(portage_path, ebuild_name, 'files')
  ebuild_path  = File.join(portage_path, ebuild_name, ebuild_file)

  directory ebuild_dir do
    owner 'root'
    group 'root'
    mode 0644
    recursive true
  end

  directory files_dir do
    owner 'root'
    group 'root'
    mode  0644
    recursive true
  end

  remote_file ebuild_path do
    source ebuild_file
    owner 'root'
    group 'root'
    mode 0644
  end

  params[:files].each do |file|

    # if there's a dir in the name
    if File.basename(file) != file
      directory File.join(files_dir, file.gsub(File.basename(file), '')) do
        owner 'root'
        group 'root'
        mode  0644
        recursive true
      end
    end

    remote_file File.join(files_dir, file) do
      source file
      owner 'root'
      group 'root'
      mode 0644
    end
  end

  execute "rebuild-#{ebuild_name}-manifest" do
    command "cd #{ebuild_dir} && ebuild #{ebuild_file} digest"
  end
end
