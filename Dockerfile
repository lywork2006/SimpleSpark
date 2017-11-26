#
# The following docker file install Spark 2.2.0, then install
# git, maven and additional tools
# Created by Y.L. 11/26/2017.
#
FROM openjdk:8

MAINTAINER Y.L.

# Scala related variables.
ARG SCALA_VERSION=2.12.2
ARG SCALA_BINARY_ARCHIVE_NAME=scala-${SCALA_VERSION}
ARG SCALA_BINARY_DOWNLOAD_URL=http://downloads.lightbend.com/scala/${SCALA_VERSION}/${SCALA_BINARY_ARCHIVE_NAME}.tgz

# SBT related variables.
ARG SBT_VERSION=0.13.15
ARG SBT_BINARY_ARCHIVE_NAME=sbt-$SBT_VERSION
ARG SBT_BINARY_DOWNLOAD_URL=https://dl.bintray.com/sbt/native-packages/sbt/${SBT_VERSION}/${SBT_BINARY_ARCHIVE_NAME}.tgz

# Spark related variables.
ARG SPARK_VERSION=2.2.0
ARG SPARK_BINARY_ARCHIVE_NAME=spark-${SPARK_VERSION}-bin-hadoop2.7
ARG SPARK_BINARY_DOWNLOAD_URL=http://d3kbcqa49mib13.cloudfront.net/${SPARK_BINARY_ARCHIVE_NAME}.tgz

# Configure env variables for Scala, SBT and Spark.
# Also configure PATH env variable to include binary folders of Java, Scala, SBT and Spark.
ENV SCALA_HOME  /usr/local/scala
ENV SBT_HOME    /usr/local/sbt
ENV SPARK_HOME  /usr/local/spark
ENV PATH        $JAVA_HOME/bin:$SCALA_HOME/bin:$SBT_HOME/bin:$SPARK_HOME/bin:$SPARK_HOME/sbin:$PATH

# Download, uncompress and move all the required packages and libraries to their corresponding directories in /usr/local/ folder.
RUN apt-get -yqq update                                              && \
    apt-get install -yqq vim screen tmux                             && \
    apt-get clean                                                    && \
    rm -rf /var/lib/apt/lists/*                                      && \
    rm -rf /tmp/*                                                    && \
    wget -qO - ${SCALA_BINARY_DOWNLOAD_URL} | tar -xz -C /usr/local/ && \
    wget -qO - ${SBT_BINARY_DOWNLOAD_URL} | tar -xz -C /usr/local/   && \
    wget -qO - ${SPARK_BINARY_DOWNLOAD_URL} | tar -xz -C /usr/local/ && \
    ln -s /usr/local/scala-2.12.2 /usr/local/scala                   && \
    ln -s /usr/local/spark-2.2.0-bin-hadoop2.7 /usr/local/spark      && \
    cp /usr/local/spark/conf/log4j.properties.template /usr/local/spark/conf/log4j.properties && \
    sed -i -e s/WARN/ERROR/g /usr/local/spark/conf/log4j.properties  && \
    sed -i -e s/INFO/ERROR/g /usr/local/spark/conf/log4j.properties


# Additional step to test different code
RUN apt-get update

# Install git and maven
RUN apt-get install -y git maven

# Create data directory
RUN mkdir -p /data

# Switch to new directory
WORKDIR /data





# Install tomcat7
RUN apt-get install -y tomcat8





# We will be running our Spark jobs as `root` user.
USER root

# Working directory is set to the home folder of `root` user.
WORKDIR /root

# Expose ports for monitoring.
# SparkContext web UI on 4040 -- only available for the duration of the application.
# Spark master’s web UI on 8080.
# Spark worker web UI on 8081.
EXPOSE 4040 8080 8081

CMD ["/bin/bash"]
