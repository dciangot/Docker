FROM cern/cc7-base
MAINTAINER diego.ciangottini@gmail.com 

ENV WDIR=/data
ENV USER=crab3

ADD install_TW.sh $WDIR/install_TW.sh
ADD cernonly2.repo /etc/yum.repos.d/cernonly2.repo

RUN yum update -y && yum clean all
RUN yum install -y git-core zip unzip which file bzip2 e2fsprogs e2fsprogs-libs compat-libstdc++-33 \
    openssl iopenssl-libs openssh openssh-clients \
    perl-Thread-Queue zsh tk freetype perl-ExtUtils-Embed fontconfig \
    perl-Test-Harness perl-Data-Dumper perl-Digest-MD5 perl-Switch perl-Env \
    libX11-devel libX11 libXmu libSM libICE libXcursor libXext libXrandr libXft \
    mesa-libGLU mesa-libGL libXi libXinerama libXft-devel libXrender libXpm \
    libXpm-devel libXext-devel mesa-libGLU-devel wget sudo
RUN yum clean all

# add new user
RUN useradd ${USER} && install -o ${USER} -d ${WDIR}
USER ${USER}

# start the setup
RUN mkdir -p $WDIR
WORKDIR ${WDIR}

# install
#RUN sh $WDIR/install_TW.sh

