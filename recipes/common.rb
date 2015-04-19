#
# Cookbook Name:: caffe
# Recipe:: common

cache_dir = Chef::Config["file_cache_path"]
prefix_path = node["caffe"]["prefix"]

make_parallels = node["caffe"]["parallels"]

# ------ yum_packages -------

if platform?("redhat", "amazon")
    template "/etc/yum.repos.d/CentOS-Base.repo" do
        source "CentOS-Base.repo.erb"
        variables({
            arch: "x86_64",
            enabled: 1
        })
    end
end

node["caffe"]["yum_packages"].each do |pkg|
    package pkg do
        action :install
    end
end

# ------ checkout caffe ------

git "#{cache_dir}/caffe" do
    repository "https://github.com/BVLC/caffe.git"
    action :checkout
end


# ------ python -------

version = node["caffe"]["python"]["version"]

if platform? "amazon"
    link "#{prefix_path}/lib/libpython2.7.so" do
        to "/usr/lib64/libpython2.7.so"
    end

    link "#{prefix_path}/include/python2.7" do
        to "/usr/include/python2.7"
    end

    link "#{prefix_path}/bin/python" do
        to "/usr/bin/python2.7"
    end

    link "#{prefix_path}/bin/python2.7" do
        to "/usr/bin/python2.7"
    end
else
    make_install_from_source "python" do
        file "Python-#{version}.tgz"
        make_dir "Python-#{version}"
        url "https://www.python.org/ftp/python/#{version}/Python-#{version}.tgz"
        check "#{prefix_path}/bin/python"
        parallels make_parallels
        prefix prefix_path
    end

    file "/etc/ld.so.conf.d/python.conf" do
        content "/usr/local/lib"
    end

    bash "ldconfig python.conf" do
        code <<-EOC
        ldconfig
        EOC
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
end

# ------ autoconf ------

make_install_from_source "autoconf" do
    file "autoconf-2.69.tar.gz"
    make_dir "autoconf-2.69"
    url "http://ftpmirror.gnu.org/autoconf/autoconf-2.69.tar.gz"
    check "#{prefix_path}/bin/autoconf"
    prefix prefix_path
end

# ------ automake ------

make_install_from_source "automake" do
    file "automake-1.14.1.tar.xz"
    make_dir "automake-1.14.1"
    url "http://ftpmirror.gnu.org/automake/automake-1.14.1.tar.xz"
    check "#{prefix_path}/bin/automake-1.14"
    prefix prefix_path
    tar_option "xvf"
end

# ------ boost -------

remote_file "#{cache_dir}/boost_1_57_0.tar.gz" do
    source "http://downloads.sourceforge.net/project/boost/boost/1.57.0/boost_1_57_0.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fboost%2Ffiles%2Fboost%2F1.57.0%2F&ts=1427975290&use_mirror=jaist"
    not_if "ls #{prefix_path}/lib | grep libboost_"
end

bash "install boost" do
    cwd cache_dir
    code <<-EOC
    tar zxvf boost_1_57_0.tar.gz
    cd boost_1_57_0
    ./bootstrap.sh --with-python-version=2.7 --with-python-root=#{prefix_path}
    ./b2 install -j#{make_parallels} --prefix=#{prefix_path}
    EOC
    not_if "ls #{prefix_path}/lib | grep libboost_"
end

# ------ opencv ------

remote_file "#{cache_dir}/opencv-2.4.9.zip" do
    source "http://sourceforge.net/projects/opencvlibrary/files/opencv-unix/2.4.9/opencv-2.4.9.zip"
    not_if "ls #{prefix_path}/lib | grep libopencv_"
end

bash "install opencv" do
    cwd cache_dir
    code <<-EOC
    unzip opencv-2.4.9.zip
    cd opencv-2.4.9; mkdir build; cd build
    cmake #{node["caffe"]["opencv"]["cmake"]} ..
    make -j#{make_parallels}
    make install
    EOC
    not_if "ls #{prefix_path}/lib | grep libopencv_"
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
    export PATH=#{prefix_path}/bin:$PATH
    automake --add-missing
    ./configure --prefix=#{prefix_path}
    make -j#{make_parallels}
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
    make -j#{make_parallels}
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
    make -j#{make_parallels}
    cp -r include/leveldb #{prefix_path}/include/
    cp libleveldb* #{prefix_path}/lib/
    EOC
    not_if "ls #{prefix_path}/lib | grep libleveldb"
end

# ------ protobuf ------

git "#{cache_dir}/protobuf" do
    repository "https://github.com/google/protobuf.git"
    revision "bba83652e1be610bdb7ee1566ad18346d98b843c"
    action :checkout
    not_if "ls #{prefix_path}/lib | grep libprotobuf"
end

bash "make protobuf" do
    cwd "#{cache_dir}/protobuf"
    code <<-EOC
    ./autogen.sh
    ./configure --prefix=#{prefix_path}
    make -j#{make_parallels}
    make install
    EOC
    not_if "ls #{prefix_path}/lib | grep libprotobuf"
end

# ------ lmdb ------

git "#{cache_dir}/mdb" do
    repository "https://gitorious.org/mdb/mdb.git"
    action :checkout
    not_if "ls #{prefix_path}/lib | grep liblmdb"
end

directory "#{prefix_path}/man" do
    action :create
end

bash "install lmdb" do
    cwd "#{cache_dir}/mdb/libraries/liblmdb"
    code <<-EOC
    make -j#{make_parallels}
    make install
    EOC
    not_if "ls #{prefix_path}/lib | grep liblmdb"
end

# ------ python modules ------

bash "install python modules" do
    cwd "#{cache_dir}/caffe/python"
    code <<-EOC
    for req in $(cat requirements.txt); do pip install $req; done
    pip install #{node["caffe"]["python"]["pip_packages"].join(' ')}
    EOC
end

