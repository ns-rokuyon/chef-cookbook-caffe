default["caffe"]["mode"] = 'cpu'
default["caffe"]["prefix"] = "/usr/local"

default["caffe"]["yum_packages"] = %w(git make cmake unzip bzip2 bzip2-devel xz libtool atlas-sse3 snappy)
default["caffe"]["python"]["version"] = "2.7.9"
default["caffe"]["python"]["pip_packages"] = %(protobuf lmdb)

default["caffe"]["cmake"]["cpu"] = 
    "-DBUILD_SHARED_LIBS=ON -DCPU_ONLY=ON -DUSE_CUDNN=OFF -DBUILD_docs=ON -DBUILD_python=ON -DBUILD_matlab=OFF"
default["caffe"]["cmake"]["gpu"] = 
    "-DBUILD_SHARED_LIBS=ON -DCPU_ONLY=OFF -DUSE_CUDNN=ON -DBUILD_docs=ON -DBUILD_python=ON -DBUILD_matlab=OFF"
