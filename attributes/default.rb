default["caffe"]["mode"] = 'cpu'
default["caffe"]["prefix"] = "/usr/local"

default["caffe"]["yum_packages"] = %w(git make cmake xz atlas-sse3 boost boost-python snappy)
default["caffe"]["python"]["version"] = "2.7.9"
default["caffe"]["python"]["pip_packages"] = %(protobuf lmdb)
