#! /usr/bin/env bash

if [ "x$HADOOP_VERSION" == 'x' ]; then
    echo 'Must set $HADOOP_VERSION'
    exit 64
fi

export SPARK_BASE_VERSION=${SPARK_BASE_VERSION:-0.8.1}

# Whether this is the new YARN from 2.2.x or higher
export SPARK_IS_NEW_HADOOP=${SPARK_IS_NEW_HADOOP:-false}

export SPARK_HADOOP_VERSION=${SPARK_HADOOP_VERSION:-${HADOOP_VERSION}}
export HADOOP_CLASSIFIER=${HADOOP_CLASSIFIER:-apache${HADOOP_VERSION}}

# END CUSTOMIZATION

export SPARK_CLASSIFIER=${SPARK_CLASSIFIER:-`echo $HADOOP_CLASSIFIER | tr '.' '_'`}
export SPARK_YARN=${SPARK_YARN:-true}
export SPARK_ARTIFACTORY_VERSION=${SPARK_ARTIFACTORY_VERSION:-${SPARK_BASE_VERSION}.${BUILD_NUMBER}}

sbt -Dsbt.log.noformat=true clean assembly publish-local

bash make-distribution.sh --hadoop ${HADOOP_VERSION} --with-yarn

rm -f *.tar *.tar.gz *.tgz

tar --exclude '*.tar' --exclude '*.tar.*' --exclude '*.tgz' --transform="s,^dist,spark-${HADOOP_CLASSIFIER}-${SPARK_ARTIFACTORY_VERSION}," -czf spark-${HADOOP_CLASSIFIER}-${SPARK_ARTIFACTORY_VERSION}.tar.gz dist

