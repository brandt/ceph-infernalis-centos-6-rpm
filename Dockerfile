FROM centos:centos6
MAINTAINER J. Brandt Buckley <brandt.buckley@sendgrid.com>

RUN yum update -y

# Required for this build system:
RUN yum install -y rpm-build rsync which tar wget @"Development Tools"

# Needed for several ceph dependencies
RUN yum install -y epel-release

# Ceph Dependencies
RUN yum install -y bzip2-devel cmake cryptsetup expat-devel fcgi-devel fuse-devel gperftools-devel hdparm java-devel junit4 keyutils-libs-devel leveldb-devel libaio-devel libatomic_ops-devel libbabeltrace-devel libblkid-devel libcurl-devel libedit-devel libudev-devel libxml2-devel lttng-ust-devel nss-devel parted python-argparse python-nose python-requests python-sphinx10 python-virtualenv selinux-policy-devel sharutils snappy-devel xfsprogs xfsprogs-devel xmlstarlet yasm

# For the /usr/share/selinux/devel/policyhelp dependency
RUN yum install -y selinux-policy-doc 

# Needed for boost-random
RUN curl repo.runlevel1.com/brandt.repo > /etc/yum.repos.d/brandt.repo
RUN yum install -y boost-devel boost-random

# We need a newer version of gcc due to use of C++11 features
ADD ./src/devtools3.repo /etc/yum.repos.d/devtools3.repo
RUN yum install -y devtoolset-3-gcc devtoolset-3-binutils devtoolset-3-gcc-c++ && yum clean all
RUN ln -s /opt/rh/devtoolset-3/enable /etc/profile.d/devtools3.sh

# Have to use UID 1000 b/c http://github.com/boot2docker/boot2docker/issues/581
RUN adduser mockbuild --uid 1000 --comment "rpm package builder"

WORKDIR /home/mockbuild

ADD ./src/build.sh build.sh
ADD ./rpmbuild rpmbuild
RUN mkdir -p rpmbuild/BUILD rpmbuild/BUILDROOT rpmbuild/RPMS rpmbuild/SOURCES rpmbuild/SPECS rpmbuild/SRPMS
RUN chown -R mockbuild:mockbuild /home/mockbuild

VOLUME ["/artifacts"]
