#!/bin/bash -l

# number of CPU core
ncpu="$(nproc --all)"

# 80% of free memory 
freememory="$(free -m | awk '{print $4}'| head -2 | tail -1)"
memorypercent=$(awk "BEGIN { pc=80*${freememory}/100; i=int(pc); print (pc-i<0.5)?i:i+1 }")

# Creating new config.sh
echo -en '# Default hdfs configuration properties\n\n' > config.sh
echo -en 'HADOOP_TMP_DIR=/tmp/app-hadoop\n' >> config.sh
echo -en 'REPLICATION_FACTOR=3\n' >> config.sh
echo -en 'DFS_NAMENODE_NAME_DIR=/tmp/hdfs-meta\n' >> config.sh
echo -en 'DFS_DATANODE_NAME_DIR=/tmp/hdfs-data\n\n' >> config.sh

echo -en '# Site specific YARN configuration properties\n\n' >> config.sh

echo -en 'MASTER='"${HOSTNAME}"'\n' >> config.sh
echo -en 'SLAVES='"${HOSTNAME}"','"$ncpu"','"$memorypercent"'\n' >> config.sh
echo -en '# Use this format to set SLAVE IPs : slave1IP,slave1cpu,slave1memory%....\n\n' >> config.sh

echo -en '# Scheduler properties\n\n' >> config.sh
			 
echo -en 'YARN_SCHEDULER_MIN_ALLOCATION_MB=128\n' >> config.sh				 
echo -en 'YARN_SCHEDULER_MAX_ALLOCATION_MB=204800\n' >> config.sh
echo -en 'YARN_SCHEDULER_MIN_ALLOCATION_VCORES=1\n' >> config.sh
echo -en 'YARN_SCHEDULER_MAX_ALLOCATION_VCORES=40\n\n' >> config.sh

echo -en '# Node Manager properties (Default yarn cpu and memory value for all nodes)\n\n' >> config.sh

echo -en 'YARN_NODEMANAGER_RESOURCE_CPU_VCORES='"$ncpu"'\n' >> config.sh
echo -en 'YARN_NODEMANAGER_RESOURCE_MEMORY_MB='"$memorypercent"'\n\n' >> config.sh


echo -n "Enter Spark version : "
read -n 5 sparkver
echo -e "\nFor Spark Version: $sparkver"
if [ ${sparkver:0:1} == 2 ]
then
  echo -e "these are vailable hadoop versions: 1.2.1, 2.5.2, 2.6.0, 2.6.1, 2.6.2, 2.6.3, 2.6.4, 2.6.5, 2.7.0, 2.7.1, 2.7.2, 2.7.3"
  echo -e "Enter Hadoop version (Above versions are compatibility with spark-2.0.0 and later): "
  read -n 5 hadoopver
  echo -e 
elif [ ${sparkver:0:1} -lt 2 ]
then 
  echo -e "there are vailable hadoop versions: 1.2.1, 2.5.2, 2.6.0, 2.6.1, 2.6.2, 2.6.3, 2.6.4, 2.6.5"
  echo -e "Enter Hadoop version (less than 2.7.0 which are compatibility with below spark-2.0.0) : "
  read -n 5 hadoopver
  echo -e 
fi

echo -en '# Hadoop and Spark Version\n\n' >> config.sh

echo -en 'sparkver='"$sparkver"'\n' >> config.sh
echo -en 'hadoopver='"$hadoopver"'\n' >> config.sh

echo -e "Please check configuration (config.sh file) once before run (run.sh file)"

chmod +x config.sh
