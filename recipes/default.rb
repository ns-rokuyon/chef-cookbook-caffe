#
# Cookbook Name:: caffe
# Recipe:: default

caffe_mode = node["caffe"]["mode"]
begin
    include_recipe "caffe::common"
    include_recipe "caffe::#{caffe_mode}"
rescue Chef::Exceptions::RecipeNotFound
    Chef::Log.warn "recipe not found: caffe::#{caffe_mode}"
end
