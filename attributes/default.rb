# caffe mode -> cpu | gpu
default["caffe"]["mode"] = 'gpu'

# caffe install dir
default["caffe"]["install_dir"] = "/var/chef/cache/caffe/build/install"

# prerequisites install prefix
default["caffe"]["prefix"] = "/usr/local"

# make -j option value
default["caffe"]["parallels"] = 2

# yum packages
default["caffe"]["yum_packages"] = %w(gcc gcc-c++ git make cmake wget openssl-devel unzip bzip2 bzip2-devel xz libtool gcc-gfortran libgfortran freetype freetype-devel atlas-sse3 atlas-sse3-devel snappy snappy-devel libpng-devel libjpeg-devel libtiff-devel libjasper-devel openexr-devel)

# use python version
default["caffe"]["python"]["version"] = "2.7.9"

# extra python modules
default["caffe"]["python"]["pip_packages"] = %w(protobuf lmdb scikit-image)

# NVIDIA driver download url 
default["caffe"]["gpu"]["driver"] = "http://jp.download.nvidia.com/XFree86/Linux-x86_64/346.59/NVIDIA-Linux-x86_64-346.59.run"

# CUDA installer download url (CUDA6.5)
default["caffe"]["gpu"]["cuda"] = "http://developer.download.nvidia.com/compute/cuda/6_5/rel/installers/cuda_6.5.14_linux_64.run"

# cuDNN
default["caffe"]["gpu"]["cudnn"] = true

# cuDNN file
default["caffe"]["gpu"]["cudnn_tgz"] = "cudnn-6.5-linux-x64-v2.tgz"

# opencv cmake options
default["caffe"]["opencv"]["cmake"] = "\
    -D CMAKE_C_COMPILER=/usr/bin/gcc \
    -D CMAKE_CXX_COMPILER=/usr/bin/g++ \
    -D CMAKE_C_FLAGS='-march=native -I#{default["caffe"]["prefix"]}/include' \
    -D CMAKE_CXX_FLAGS='-march=native -I#{default["caffe"]["prefix"]}/include' \
    -D CMAKE_INSTALL_PREFIX=#{default["caffe"]["prefix"]} \
    -D BUILD_NEW_PYTHON_SUPPORT=ON \
    -D PYTHON_EXECUTABLE=#{default["caffe"]["prefix"]}/bin/python \
    -D PYTHON_LIBRARY=#{default["caffe"]["prefix"]}/lib/libpython2.7.so \
    -D PYTHON_INCLUDE_PATH=#{default["caffe"]["prefix"]}/include/python2.7 \
    -D WITH_QT=OFF \
    -D HAVE_OPENMP=ON \
    -D WITH_OPENCL=OFF \
    -D WITH_FFMPEG=OFF \
    -D BUILD_opencv_world=OFF"

# caffe cmake options
default["caffe"]["cmake"]["cpu"] = 
    "-DBUILD_SHARED_LIBS=ON -DCPU_ONLY=ON -DUSE_CUDNN=OFF -DBUILD_docs=ON -DBUILD_python=ON -DBUILD_matlab=OFF -DCMAKE_PREFIX_PATH=/usr/local \
    -DCMAKE_INSTALL_PREFIX=#{default["caffe"]["install_dir"]} \
    -DAtlas_BLAS_LIBRARY=/usr/lib64/atlas-sse3/libatlas.so -DAtlas_CBLAS_LIBRARY=/usr/lib64/atlas-sse3/libcblas.so -DAtlas_LAPACK_LIBRARY=/usr/lib64/atlas-sse3/liblapack.so \
    -DBoost_DIR=/usr/local -DBoost_INCLUDE_DIR=/usr/local/include -DBoost_LIBRARY_DIR=/usr/local/lib \
    -DSnappy_INCLUDE_DIR=/usr/include -DSnappy_LIBRARIES=/usr/lib64"

default["caffe"]["cmake"]["gpu"] = 
    "-DBUILD_SHARED_LIBS=ON -DCPU_ONLY=OFF -DUSE_CUDNN=OFF -DBUILD_docs=ON -DBUILD_python=ON -DBUILD_matlab=OFF -DCMAKE_PREFIX_PATH=/usr/local \
    -DCMAKE_INSTALL_PREFIX=#{default["caffe"]["install_dir"]} \
    -DAtlas_BLAS_LIBRARY=/usr/lib64/atlas-sse3/libatlas.so -DAtlas_CBLAS_LIBRARY=/usr/lib64/atlas-sse3/libcblas.so -DAtlas_LAPACK_LIBRARY=/usr/lib64/atlas-sse3/liblapack.so \
    -DBoost_DIR=/usr/local -DBoost_INCLUDE_DIR=/usr/local/include -DBoost_LIBRARY_DIR=/usr/local/lib \
    -DSnappy_INCLUDE_DIR=/usr/include -DSnappy_LIBRARIES=/usr/lib64"
