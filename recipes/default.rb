#
# Cookbook Name:: caffe
# Recipe:: default

# Common packages
#===========================

include_recipe "caffe::common"


# GPU
#===========================

Chef::Log.info "caffe mode: #{node["caffe"]["mode"]}"
if node["caffe"]["mode"] == 'gpu'
    include_recipe "caffe::gpu" 
end


# caffe
#===========================

include_recipe "caffe::caffe"
