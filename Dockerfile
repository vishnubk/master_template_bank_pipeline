FROM nvidia/cuda:10.2-devel-ubuntu18.04

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

RUN rm /bin/sh && ln -s /bin/bash /bin/sh 

# Suppress debconf warnings
ENV DEBIAN_FRONTEND noninteractive

# Create psr user which will be used to run commands with reduced privileges.
RUN adduser --disabled-password --gecos 'unprivileged user' psr && \
    echo "psr:psr" | chpasswd && \
    mkdir -p /home/psr/.ssh && \
    chown -R psr:psr /home/psr/.ssh

# Create space for ssh daemon and update the system
RUN echo 'deb http://us.archive.ubuntu.com/ubuntu trusty main multiverse' >> /etc/apt/sources.list && \
    mkdir /var/run/sshd && \
    apt-get -y check && \
    apt-get -y update && \
    apt-get install -y apt-utils apt-transport-https software-properties-common software-properties-common && \
    apt-get -y update --fix-missing && \
    apt-get -y upgrade 


# Install dependencies
RUN apt-get update
RUN apt-get --no-install-recommends -y install \  

    build-essential \
    autoconf \
    autotools-dev \
    automake \
    pkg-config \
    csh \
    cmake \
    gcc \
    gfortran \
    wget \
    git \
    expect \	
    cvs \
    libcfitsio-dev \
    pgplot5 \
    swig2.0 \    
    python \
    python-dev \
    python-pip \
    python-tk \
    libfftw3-3 \
    libfftw3-bin \
    libfftw3-dev \
    libfftw3-single3 \
    libxml2 \
    libxml2-dev \
    libx11-dev \  
    libglib2.0-0 \
    libglib2.0-dev \
    openssh-server \
    xorg \
    vim \
    emacs \
    gedit \
    bc \
    sudo \
    curl \
    eog \
    latex2html \
    && rm -rf /var/lib/apt/lists/* 

RUN add-apt-repository universe
RUN apt-get update
RUN apt-get install -y build-essential python3 python3-dev python3-pip
RUN apt-get -y clean
USER psr
RUN pip3 install --upgrade pip
RUN pip3 install numpy matplotlib pandas emcee corner schwimmbad sympy scipy
RUN pip3 install --user scikit-monaco
RUN pip3 install ipython


RUN pip install --upgrade pip 

RUN pip install pip -U && \
    pip install setuptools -U && \
    pip install numpy -U && \
    pip install scipy==0.19.0 -U && \
    pip install matplotlib -U

USER root
RUN apt-get update -y && \
    apt-get --no-install-recommends -y install \
    autogen \
    libtool \
    libltdl-dev	

RUN git clone https://github.com/vishnubk/dedisp.git && \
   cd dedisp &&\
   git checkout arch61 && \
   make -j 32 && \
   make install 

RUN git clone https://github.com/vishnubk/3D_peasoup.git && \
   cd 3D_peasoup && \
   make -j 32 && \
   make install 
  
RUN ldconfig /usr/local/lib

# #SHELL ["/bin/bash", "-c"] 
# #RUN ~/.bashrc
# #RUN conda activate template_bank_generator
# RUN python3 -m pip install numpy
# RUN python3 -m pip install pandas emcee sympy
# RUN python3 -m pip install schwimmbad corner
#RUN python3 -m pip install --user scikit-monaco

#RUN pip install numpy
#RUN pip install pandas emcee sympy
#RUN pip install schwimmbad corner
#RUN pip install -U scikit-monaco
#RUN apt-get update &&\
#    apt-get install -y build-essential && \
#    apt-get install -y --no-install-recommends \ 
#    git \
#    vim \  
#    python3 \
#    python-dev \
#    libxml2-dev \
#    libxslt-dev \
#    python3-distutils \
#    python3-setuptools \
#    python3-pip \ 
#    ca-certificates

# This will install Python, pip, pip3, and pip3.6.

#RUN curl https://bootstrap.pypa.io/ez_setup.py -o - | python3.6 && python3.6 -m easy_install pip
#RUN apt-get update
#RUN apt-get install -y python3.6-venv

# Inorder to run pip3.6, run it the following way `python3.6 -m pip`
# Update Python & Install wheel
#RUN python3 -m pip install pip --upgrade
#RUN python3 -m pip install wheel

#RUN pip install numpy
#RUN pip install pandas emcee sympy 
#RUN pip install schwimmbad corner 

#RUN python3 -m pip install --user scikit-monaco
#RUN pip install -U scikit-monaco
#RUN python3 -m pip install numpy emcee pandas sympy scikit-monaco schwimmbad corner

ENV HOME /home/psr
ENV PSRHOME /home/psr/software
ENV OSTYPE linux
RUN mkdir -p /home/psr/software
WORKDIR $PSRHOME
USER psr

#RUN git clone https://github.com/ewanbarr/dedisp.git && \
#    cd dedisp &&\
#    git checkout arch61 && \
#    make -j 32 && \
#    make install 
#
#RUN git clone https://github.com/vishnubk/3D_peasoup.git && \
#    cd 3D_peasoup && \
#    make -j 32 && \
#    make install 
#   
#RUN ldconfig /usr/local/lib
