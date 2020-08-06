#!/bin/bash

# Variables
ARCH=`uname -m`  # ARM or x64
HADOOP_VERSION="3.3.0"
HADOOP_HOME="/usr/local/hadoop"

# Install Pre requisite software
sudo apt-get update
sudo apt-get install -y ssh pdsh default-jdk
JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")
echo $JAVA_HOME

# Download HDFS
if [[ $ARCH == "aarch64" ]]; then
  echo "Downloading ARM64 binary"
  wget -nc https://mirrors.ocf.berkeley.edu/apache/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION-aarch64.tar.gz -O /tmp/hadoop.tar.gz
else
echo "Downloading x86_64 binary"
  wget -nc https://mirrors.ocf.berkeley.edu/apache/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz -O /tmp/hadoop.tar.gz
fi
sudo tar -xf /tmp/hadoop.tar.gz -C /usr/local/
sudo ln -s /usr/local/hadoop-$HADOOP_VERSION/ $HADOOP_HOME

# Set Environment Variables
echo "export PDSH_RCMD_TYPE=ssh" >> /home/$USER/.bashrc
echo "export HADOOP_HOME=$HADOOP_HOME" >> /home/$USER/.bashrc
source /home/$USER/.bashrc

# SSH Authorization
ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 0600 ~/.ssh/authorized_keys

