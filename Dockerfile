# Pull the latest image of CentOS from the Docker repo
FROM centos:8

## # Add some packages
RUN yum -y install which
RUN yum -y install emacs-nox
RUN yum -y install ruby ruby-devel
RUN yum -y install make
RUN yum -y install gcc
RUN yum -y install redhat-rpm-config
RUN yum -y install gcc-c++
RUN gem install just-the-docs

WORKDIR /root


