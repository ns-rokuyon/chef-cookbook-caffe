#
# Cookbook Name:: caffe
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

caffe_mode = node["caffe"]["mode"]
begin
    include_recipe "caffe::common"
    include_recipe "caffe::#{caffe_mode}"
rescue Chef::Exceptions::RecipeNotFound
    Chef::Log.warn "recipe not found: caffe::#{caffe_mode}"
end
