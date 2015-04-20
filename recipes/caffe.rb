#
# Cookbook Name:: caffe
# Recipe:: cpu

cache_dir = Chef::Config["file_cache_path"]

caffe_mode = node["caffe"]["mode"]
make_parallels = node["caffe"]["parallels"]

# ----- build caffe ------

caffe_dir = "#{cache_dir}/caffe"
build_dir = "#{caffe_dir}/build"

directory build_dir do
    action :create
end

cmake_options = node["caffe"]["cmake"][caffe_mode]
bash "make install caffe" do
    cwd build_dir
    code <<-EOC
    export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
    cmake #{cmake_options} ..
    make all
    cd python
    make -j#{make_parallels}
    cd ..
    make install
    EOC
end
