# Version: 0.0.1
FROM centos:7.2.1511
MAINTAINER Michael Fernando 

# Copy & switch to working directory
COPY . /app
WORKDIR /app

# Make start.sh executable
RUN chmod +x /app/scripts/start.sh

# Install base stuff
RUN yum -y install nano
RUN yum -y install wget
RUN yum -y groupinstall 'Development Tools'

# Install Apache
RUN /bin/bash -c "wget http://apache.claz.org//httpd/httpd-2.2.31.tar.gz"
RUN /bin/bash -c "gzip -d httpd-2.2.31.tar.gz"
RUN /bin/bash -c "tar xvf httpd-2.2.31.tar"
WORKDIR httpd-2.2.31

RUN /bin/bash -c "./configure --prefix=/usr/local/apache2"
RUN /bin/bash -c "make"
RUN /bin/bash -c "make install"
RUN /bin/bash -c "sed -i 's/Listen 80/Listen 8000/g' /usr/local/apache2/conf/httpd.conf"

# Download Java & extract
WORKDIR /app
RUN /bin/bash -c "wget --no-cookies --no-check-certificate --header \"Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie\" \"http://download.oracle.com/otn-pub/java/jdk/8u66-b17/jdk-8u66-linux-x64.tar.gz\""
RUN /bin/bash -c "tar -zxvf jdk-8u66-linux-x64.tar.gz"

WORKDIR /app/jdk-8u66-linux-x64

# Configure Java
RUN /bin/bash -c "update-alternatives --install /usr/bin/java java /app/jdk1.8.0_66/bin/java 2"
RUN /bin/bash -c "update-alternatives --install /usr/bin/javac javac /app/jdk1.8.0_66/bin/javac 2"
RUN /bin/bash -c "update-alternatives --install /usr/bin/jar jar /app/jdk1.8.0_66/bin/jar 2"

# Update Java ENV vars
RUN /bin/bash -c "echo 'JAVA_HOME=\"/app/jdk1.8.0_66/bin/java\"' >> ~/.bashrc"
RUN /bin/bash -c "echo 'JRE_HOME=\"/app/jdk1.8.0_66/bin/jar\"' >> ~/.bashrc"
RUN /bin/bash -c "echo 'PATH=$PATH:$HOME/bin:JAVA_HOME:JRE_HOME' >> ~/.bashrc"
RUN /bin/bash -c "echo 'CATALINA_OPTS=\"$CATALINA_OPTS -Xmx1024m -XX:MaxPermSize=256m\"' >> ~/.bashrc"
RUN /bin/bash -c "source ~/.bashrc"

# Install Tomcat
WORKDIR /app
RUN /bin/bash -c "wget http://mirror.nexcess.net/apache/tomcat/tomcat-7/v7.0.70/bin/apache-tomcat-7.0.70.tar.gz"
RUN /bin/bash -c "tar -zxvf apache-tomcat-7.0.70.tar.gz"
RUN /bin/bash -c "mv apache-tomcat-7.0.70 tomcat"
RUN /bin/bash -c "chmod +x /app/tomcat/bin/*.sh"

# Install OpenAM
WORKDIR /app
RUN /bin/bash -c "wget http://download.forgerock.org/downloads/openam/OpenAM-14.0.0-SNAPSHOT_20160716.war"
RUN /bin/bash -c "mv /app/OpenAM-14.0.0-SNAPSHOT_20160716.war /app/tomcat/webapps/openam.war"

# Install OpenAM Web Agent
# WORKDIR /app
# RUN /bin/bash -c "wget http://download.forgerock.org/downloads/openam/webagents/nightly/Linux/Apache_v22_Linux_64bit_5.0.0-SNAPSHOT.zip"
# RUN /bin/bash -c "unzip Apache_v22_Linux_64bit_5.0.0-SNAPSHOT.zip"

EXPOSE 8000 8080 8443 22
