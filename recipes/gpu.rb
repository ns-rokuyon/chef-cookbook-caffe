#
# Cookbook Name:: caffe
# Recipe:: gpu

cache_dir = Chef::Config["file_cache_path"]
prefix_path = node["caffe"]["prefix"]

