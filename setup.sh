#!/bin/bash

export TEZ_HOME=/opt/tez
export HIVE_HOME=/opt/hive

/entrypoint.sh
mkdir -p ${HIVE_HOME}/log
mkdir -p ${HIVE_HOME}/custom
mkdir -p ${HIVE_HOME}/install_dir
for tezJar in $(ls -1 ${TEZ_HOME}/*.jar | awk -F\/ '{print $NF}'); do
    [ ! -e ${HIVE_HOME}/lib/${tezJar} ] && ln -s ${TEZ_HOME}/${tezJar} ${HIVE_HOME}/lib/${tezJar}
done

nohup /opt/hive/bin/hive --service metastore   1>${WORK}/log/hivemetastore.$(date +%s).stdout 2>/opt/hive/log/hivemetastore.$(date +%s).stderr &
nohup /opt/hive/bin/hive --service hiveserver2 1>/opt/hive/log/hiveserver2.$(date +%s).stdout 2>/opt/hive/log/hiveserver2.$(date +%s).stderr &
#EOF
