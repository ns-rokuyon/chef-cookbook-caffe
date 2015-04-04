define :make_install_from_source, :tar_option => "zxvf", :prefix => "/usr/local" do
    cache_dir = Chef::Config["file_cache_path"]

    file = params[:file]
    dir = params[:make_dir]
    url = params[:url]
    check = params[:check]
    check_file = check.split('/').last

    remote_file "#{cache_dir}/#{file}" do
        source url
        not_if "ls #{check} | grep #{check_file}"
    end

    bash "make #{params[:name]}" do
        cwd cache_dir
        code <<-EOC
            export PATH=#{params[:prefix]}/bin:$PATH
            tar #{params[:tar_option]} #{file}
            cd #{dir}
            ./configure --prefix=#{params[:prefix]} --enable-shared
            make
            make install
        EOC
        not_if "ls #{check} | grep #{check_file}"
    end
end
