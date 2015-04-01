#
# Cookbook Name:: caffe
# Recipe:: cpu

cache_dir = Chef::Config["file_cache_path"]
prefix_path = node["caffe"]["prefix"]

# ----- build caffe ------

caffe_dir = "#{cache_dir}/caffe"
build_dir = "#{caffe_dir}/build"

directory build_dir do
    action :create
end

cmake_options = node["caffe"]["cmake"]["cpu"]
bash "make install caffe" do
    cwd build_dir
    code <<-EOC
    cmake #{cmake_options} ..
    make all
    EOC
end
