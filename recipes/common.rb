#
# Cookbook Name:: caffe
# Recipe:: common
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

cache_dir = Chef::Config["file_cache_path"]
prefix_path = node["caffe"]["prefix"]

# ------ yum_packages -------

node["caffe"]["yum_packages"].each do |pkg|
    package pkg do
        action :install
    end
end


# ------ python -------

version = node["caffe"]["python"]["version"]

make_install_from_source "python" do
    file "Python-#{version}.tgz"
    make_dir "Python-#{version}"
    url "https://www.python.org/ftp/python/#{version}/Python-#{version}.tgz"
    check "#{prefix_path}/bin/python"
    prefix prefix_path
end

bash "install pip" do
    cwd cache_dir
    code <<-EOC
        wget https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py
        python2.7 ez_setup.py
        easy_install-2.7 pip
    EOC
    not_if "ls #{prefix_path}/bin/pip"
end

# ------ autoconf ------

make_install_from_source "autoconf" do
    file "autoconf-2.69.tar.gz"
    make_dir "autoconf-2.69"
    url "ftp://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz"
    check "#{prefix_path}/bin/autoconf"
    prefix prefix_path
end

# ------ automake ------

make_install_from_source "automake" do
    file "automake-1.14.1.tar.xz"
    make_dir "automake-1.14.1"
    url "http://ftp.gnu.org/gnu/automake/automake-1.14.1.tar.xz"
    check "#{prefix_path}/bin/automake-1.14"
    prefix prefix_path
    tar_option "xvf"
end

# ------ glog -------

git "#{cache_dir}/glog" do
    repository "https://github.com/google/glog.git"
    action :checkout
    not_if "ls #{prefix_path}/lib | grep glog"
end

bash "make and install glog" do
    cwd "#{cache_dir}/glog"
    code <<-EOC
    automake --add-missing
    ./configure --prefix=#{prefix_path}
    make
    make install
    EOC
    not_if "ls #{prefix_path}/lib | grep glog"
end


# ------ gflags -------

git "#{cache_dir}/gflags" do
    repository "https://github.com/gflags/gflags.git"
    action :checkout
    not_if "ls #{prefix_path}/lib | grep gflags"
end

bash "make and install gflags" do
    cwd "#{cache_dir}/gflags"
    code <<-EOC
    cmake -DCMAKE_INSTALL_PREFIX=#{prefix_path} -DBUILD_SHARED_LIBS=true .
    make
    make install
    EOC
    not_if "ls #{prefix_path}/lib | grep gflags"
end


# ------ hdf5 ------

make_install_from_source "hdf5" do
    file "hdf5-1.8.14.tar.gz"
    make_dir "hdf5-1.8.14"
    url "http://www.hdfgroup.org/ftp/HDF5/current/src/hdf5-1.8.14.tar.gz"
    check "#{prefix_path}/lib/libhdf5.so"
    prefix prefix_path
end


# ------ leveldb -------

git "#{cache_dir}/leveldb" do
    repository "https://github.com/google/leveldb.git"
    action :checkout
    not_if "ls #{prefix_path}/lib | grep libleveldb"
end

bash "make leveldb" do
    cwd "#{cache_dir}/leveldb"
    code <<-EOC
    make
    cp -r include/leveldb #{prefix_path}/include/
    cp libleveldb* #{prefix_path}/lib/
    EOC
    not_if "ls #{prefix_path}/lib | grep libleveldb"
end