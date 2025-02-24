FROM nvidia/cuda:10.1-base-ubuntu18.04

LABEL mantainer="adsonnalves@gmail.com" \
      version="1.0"

RUN apt-get update && apt-get install -y \
  wget \
  libglib2.0-0  \
  libgl1-mesa-glx \
  xcb \
  libx11-xcb-dev \
  libglu1-mesa-dev \
  libxrender-dev \
  libxi6 \
  libdbus-1-3 \
  libfontconfig1 \
  xvfb \
  && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y checkinstall bison libxcursor-dev libxcomposite-dev software-properties-common build-essential
RUN apt-get update && apt-get install -y libssl-dev libxcb1-dev libx11-dev libgl1-mesa-dev libudev-dev qt5-default qttools5-dev qtdeclarative5-dev
RUN apt-get update && apt-get install -y qtpositioning5-dev qtbase5-dev python3-pip git vim wget nano
RUN pip3 install scikit-image

WORKDIR "/"

RUN wget -q https://www.coppeliarobotics.com/files/CoppeliaSim_Edu_V4_1_0_Ubuntu18_04.tar.xz
RUN tar -xf CoppeliaSim_Edu_V4_1_0_Ubuntu18_04.tar.xz
RUN rm -rf CoppeliaSim_Edu_V4_1_0_Ubuntu18_04.tar.xz

RUN echo 'export QT_DEBUG_PLUGINS=1' >> ~/.bashrc
RUN echo 'export PATH=/CoppeliaSim_Edu_V4_1_0_Ubuntu18_04/:$PATH' >> ~/.bashrc
  
WORKDIR "/"

RUN git clone https://github.com/stepjam/PyRep.git

WORKDIR "/PyRep"

RUN pip3 install -r requirements.txt

RUN echo 'export COPPELIASIM_ROOT=/CoppeliaSim_Edu_V4_1_0_Ubuntu18_04/' >> ~/.bashrc
RUN echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$COPPELIASIM_ROOT' >> ~/.bashrc
RUN echo 'export QT_QPA_PLATFORM_PLUGIN_PATH=$COPPELIASIM_ROOT' >> ~/.bashrc

ARG COPPELIASIM_ROOT=/CoppeliaSim_Edu_V4_1_0_Ubuntu18_04/

RUN echo "$COPPELIASIM_ROOT"
RUN python3 setup.py install 

RUN wget -v https://files.pythonhosted.org/packages/38/53/914885a93a44b96c0dd1c36f36ff10afe341f091230aad68f7228d61db1e/torch-1.6.0-cp36-cp36m-manylinux1_x86_64.whl --no-check-certificate

RUN pip3 install torch-1.6.0-cp36-cp36m-manylinux1_x86_64.whl

ENV LANG C.UTF-8 

WORKDIR '/home/'

RUN git clone https://github.com/AdsonNAlves/uav_sac.git

WORKDIR '/home/uav_sac/Drone_RL'

RUN pip3 install -e .

WORKDIR '/home/uav_sac/SAC_uav'

RUN pip3 install -r requirements.txt

RUN echo 'export PYTHONPATH=$PYTHONPATH:/CoppeliaSim_Edu_V4_1_0_Ubuntu20_04' >> ~/.bashrc
RUN echo 'export PYTHONPATH=$PYTHONPATH:/home/uav_sac/Drone_RL' >> ~/.bashrc
RUN echo 'export PYTHONPATH=$PYTHONPATH:/home/uav_sac' >> ~/.bashrc

WORKDIR '/home/uav_sac/SAC_uav'
