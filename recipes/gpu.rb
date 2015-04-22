#
# Cookbook Name:: caffe
# Recipe:: gpu

cache_dir = Chef::Config["file_cache_path"]
prefix_path = node["caffe"]["prefix"]


# Driver
#--------------------------------

nvidia_installer = node["caffe"]["gpu"]["driver"].split('/').last

remote_file "#{cache_dir}/#{nvidia_installer}" do
    mode "0755"
    source node["caffe"]["gpu"]["driver"]
end

bash "install kernel src" do
    code <<-EOC
        yum install -y kernel-devel-`uname -r`
    EOC
end

bash "install NVIDIA driver" do
    cwd cache_dir
    code <<-EOC
        ./#{nvidia_installer} --silent
    EOC
end


# CUDA
#--------------------------------

cuda_installer = node["caffe"]["gpu"]["cuda"].split('/').last

remote_file "#{cache_dir}/#{cuda_installer}" do
    mode "0755"
    source node["caffe"]["gpu"]["cuda"]
end

bash "install cuda" do
    cwd cache_dir
    code <<-EOC
        ./#{cuda_installer} -silent
    EOC
end


# cuDNN
#--------------------------------

if node["caffe"]["gpu"]["cudnn"]
    cudnn_tgz = node["caffe"]["gpu"]["cudnn"]

    remote_file "#{cache_dir}/#{cudnn_tgz}" do
        source cudnn_tgz
    end

    bash "install cudnn" do
        cwd cache_dir
        code <<-EOC
            tar zxvf #{cudnn_tgz}
            cd #{cudnn_tgz.sub(".tgz","")}
            cp cudnn.h #{prefix_path}/include/
            cp libcudnn* #{prefix_path}/lib/
        EOC
    end
end


