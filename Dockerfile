FROM ubuntu:xenial
MAINTAINER Jeremy Nicklas <jeremywnicklas@gmail.com>


# Set up requirements
RUN export DEBIAN_FRONTEND=noninteractive \
  && apt-get update && apt-get install -y software-properties-common \
  && add-apt-repository ppa:jonathonf/python-3.6 \
  && apt-get update && apt-get install --yes --no-install-recommends \
    default-jre \
    graphviz \
    python3.6 \
    python3-pip \
    python3.6-dev \
    ghostscript \
    texlive \
    texlive-fonts-recommended \
    texlive-font-utils \
    texlive-lang* \
    texlive-latex-extra \
    texlive-latex-recommended \
    build-essential \
    wget \
    latexmk \
    git \
  && apt-get autoremove -y \
  && rm -fr /var/cache/* \
  && rm -fr /var/lib/apt/lists/*

#RUN apt-get update \
#  && apt-get install -y make build-essential libssl-dev zlib1g-dev \
#  && apt-get install -y libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm  \
#  && apt-get install -y libncurses5-dev  libncursesw5-dev xz-utils tk-dev \
#  && wget https://www.python.org/ftp/python/3.6.3/Python-3.6.3.tgz \
#  && tar xvf Python-3.6.3.tgz \
#  && cd Python-3.6.3 \
#  && ./configure --enable-optimizations \
#  && make -j8 \
#  && sudo make altinstall \
#  && python3.6 \

# Patch for bug in `titlesec`
# see: http://tex.stackexchange.com/questions/299969/titlesec-loss-of-section-numbering-with-the-new-update-2016-03-15
RUN wget -O /usr/share/texlive/texmf-dist/tex/latex/titlesec/titlesec.sty "http://mirrors.ctan.org/macros/latex/contrib/titlesec/titlesec.sty"

# Install PlantUML
RUN wget -O /opt/plantuml.jar "https://sourceforge.net/projects/plantuml/files/plantuml.jar" --no-check-certificate \
  && printf '#!/bin/sh -e\njava -jar /opt/plantuml.jar "$@"' > /usr/local/bin/plantuml \
  && chmod 755 /usr/local/bin/plantuml

# Install Sphinx and extras
RUN pip3.6 install --upgrade pip
RUN pip3.6 install --upgrade setuptools
RUN pip3.6 install Sphinx \
    alabaster \
    sphinx_bootstrap_theme \
    sphinx_rtd_theme \
    recommonmark \
    sphinx-autobuild \
    sphinx-prompt \
    sphinxcontrib-actdiag \
    sphinxcontrib-blockdiag \
    sphinxcontrib-nwdiag \
    sphinxcontrib-seqdiag \
    sphinxcontrib-plantuml \
    sphinxcontrib-exceltable \
    sphinxcontrib-googleanalytics \
    sphinxcontrib-googlechart \
    sphinxcontrib-googlemaps \
    sphinxcontrib-httpdomain

# Stop Java from writing files in documentation source
ENV HOME /home
ENV _JAVA_OPTIONS -Duser.home=${HOME}

WORKDIR /doc
