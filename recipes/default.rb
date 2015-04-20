#
# Cookbook Name:: caffe
# Recipe:: default

caffe_mode = node["caffe"]["mode"]

# Common packages
#===========================

include_recipe "caffe::common"


# GPU
#===========================

Chef::Log.info "caffe mode: #{caffe_mode}"
include_recipe "caffe::gpu" if caffe_mode == 'gpu'


# caffe
#===========================

include_recipe "caffe::caffe"
