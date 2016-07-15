# Version: 0.0.1
FROM centos:7.2.1511
MAINTAINER Michael Fernando 

# Copy & switch to working directory.
COPY . /app
WORKDIR /app

# Install the Nginx.org CentOS repo.
RUN cp /app/etc/nginx.repo /etc/yum.repos.d/nginx.repo

# Install base stuff.
RUN yum -y install \
  nginx \
  unzip

# Clean up YUM when done.
RUN yum clean all

# Create web dir & make script executable
RUN mkdir /srv/www
RUN chmod +x /app/scripts/start.sh

# Don't run Nginx as a daemon. This lets the docker host monitor the process.
RUN ln -s /etc/nginx/sites-available/no-default /etc/nginx/sites-enabled

EXPOSE 80
