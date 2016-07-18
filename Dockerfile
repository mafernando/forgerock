# Version: 0.0.1
FROM centos:7.2.1511
MAINTAINER Michael Fernando 

# Copy & switch to working directory.
COPY . /app
WORKDIR /app

# Make start.sh executable
RUN chmod +x /app/scripts/start.sh

# Install base stuff.
RUN yum -y install nano wget
RUN yum -y groupinstall 'Development Tools'

# Install Apache
RUN /bin/bash -c "wget http://apache.claz.org//httpd/httpd-2.2.31.tar.gz"
RUN /bin/bash -c "gzip -d httpd-2.2.31.tar.gz"
RUN /bin/bash -c "tar xvf httpd-2.2.31.tar"
WORKDIR httpd-2.2.31

RUN /bin/bash -c "./configure --prefix=/usr/local/apache2"
RUN /bin/bash -c "make"
RUN /bin/bash -c "make install"

EXPOSE 22
