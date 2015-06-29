# start with ubuntu
FROM ubuntu

RUN apt-get update -y ; \
    apt-get install -y software-properties-common python-software-properties

# install Java 8
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
    add-apt-repository -y ppa:webupd8team/java && \
    apt-get update && \
    apt-get install -y oracle-java8-installer && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/oracle-jdk8-installer

# add java to path
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
ENV PATH $PATH:$JAVA_HOME/bin

# install dependencies
RUN apt-get update -y ; \
    apt-get install -y build-essential checkinstall cmake pkg-config yasm \
    libtiff4-dev libjpeg-dev libjasper-dev libavcodec-dev libavformat-dev \
    libswscale-dev libdc1394-22-dev libxine-dev libgstreamer0.10-dev \
    libgstreamer-plugins-base0.10-dev libv4l-dev libtbb-dev libqt4-dev libgtk2.0-dev \
    ant git unzip

WORKDIR /home

# install opencv
RUN git clone https://github.com/Itseez/opencv.git
WORKDIR /home/opencv
RUN git checkout 2.4.11 ; \
    mkdir build
WORKDIR /home/opencv/build
RUN cmake -D WITH_QT=ON -D WITH_XINE=ON -D WITH_OPENGL=ON -D WITH_TBB=ON -D BUILD_EXAMPLES=ON .. ; \
    make -j8 & make install ; \
    echo '/usr/local/lib' >> /etc/ld.so.conf ; \
    cp /home/opencv/build/lib/libopencv_java2411.so /usr/lib ; \
    mkdir /home/javalibs ; \
    cp /home/opencv/build/bin/opencv-2411.jar /home/javalibs/opencv-2411.jar

# install gradle
RUN wget https://downloads.gradle.org/distributions/gradle-2.4-bin.zip ; \
    unzip gradle-2.4-bin.zip ; \
    mv gradle-2.4 /usr/local/gradle ; \
    rm gradle-2.4-bin.zip

# add gradle to path
ENV GRADLE_HOME /usr/local/gradle
ENV PATH $PATH:$GRADLE_HOME/bin