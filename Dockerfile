FROM ubuntu:14.04

# Environment variables
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV ANDROID_HOME /opt/android-sdk-linux
ENV PATH $ANDROID_HOME/platform-tools:$ANDROID_HOME/tools:$PATH

# install via apt
USER root

# Install sudo
RUN apt-get update \
  && apt-get -y install sudo \
  && useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo

RUN apt-get -y install

# Install ruby
RUN sudo apt-get -y install ruby

# Java7 installation(open jdk)
RUN \
  apt-get install -y software-properties-common curl && \
  add-apt-repository -y ppa:openjdk-r/ppa && \
  apt-get update && \
  apt-get install -y openjdk-7-jdk

# Java8 installation(open jdk)
RUN \
  apt-get install -y software-properties-common curl && \
  add-apt-repository -y ppa:openjdk-r/ppa && \
  apt-get update && \
  apt-get install -y openjdk-8-jdk

# Install Deps
RUN dpkg --add-architecture i386 && apt-get update && apt-get install -y --force-yes expect git wget libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 lib32z1 python curl libqt5widgets5 && apt-get clean && rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Download Android SDK
RUN sudo apt-get -y install wget \
  && cd /opt \
  && wget http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz \
  && tar zxvf android-sdk_r24.4.1-linux.tgz -C /opt \
  && rm -rf /opt/android-sdk_r24.4.1-linux.tgz

# Add Permission SDK
RUN sudo chmod -R 755 /opt/android-sdk-linux/ \
  && sudo chmod 777 /opt/android-sdk-linux/

# Add License
Add android-sdk-license $ANDROID_HOME/licenses/
RUN sudo chmod 777 -R /opt/android-sdk-linux/licenses/
ENV TERM dumb

# Up date Android SDK
RUN echo y | android update sdk --no-ui --force --all --filter "tools"
RUN echo y | android update sdk --no-ui --force --all --filter "platform-tools"
RUN echo y | android update sdk --no-ui --force --all --filter "build-tools-26.0.0-preview,build-tools-25.0.3,build-tools-25.0.2,build-tools-25.0.1,build-tools-25.0.0,build-tools-24.0.3,build-tools-24.0.2,build-tools-24.0.1,build-tools-24.0.0,build-tools-23.0.3,build-tools-23.0.2,build-tools-23.0.1,build-tools-23.0.0,build-tools-22.0.1,build-tools-22.0.0,build-tools-21.1.2,build-tools-21.1.1,build-tools-21.1.0,build-tools-21.0.2,build-tools-21.0.1,build-tools-21.0.0,build-tools-20.0.0"
RUN echo y | android update sdk --no-ui --force --all --filter "android-25, android-23,android-22,android-21,android-20,android-19,android-18,android-17,android-16,android-15,android-14"
RUN echo y | android update sdk --no-ui --force --all --filter "extra-android-m2repository,extra-google-google_play_services,extra-google-m2repository"

# Cleaning
RUN apt-get clean
