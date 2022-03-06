FROM ubuntu:18.04

FROM osrf/ros:melodic-desktop-full

# Change the default shell to Bash
SHELL [ "/bin/bash" , "-c" ]
 
# Instalations
RUN apt-get update && apt-get install -y \
    git \
    apt-utils \
    wget
 
# Create a Catkin workspace and clone hopsital repo
RUN source /opt/ros/melodic/setup.bash \
    && mkdir -p /catkin_ws/src \
    && cd /catkin_ws/src \
    && git clone https://github.com/ZimaUSP/d_hospital_world.git

# uodate gazebo version
RUN apt-get update \
    && sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list' \
    && wget https://packages.osrfoundation.org/gazebo.key -O - | apt-key add - \
    && apt-get update \
    && apt-get install gazebo9 -y \
    && apt upgrade libignition-math2 -y

# Build the Catkin workspace and ensure it's sourced
RUN source /opt/ros/melodic/setup.bash \
    && cd catkin_ws \
    && catkin_make

RUN echo "source /catkin_ws/devel/setup.bash" >> ~/.bashrc

# Set the working folder at startup
WORKDIR /catkin_ws