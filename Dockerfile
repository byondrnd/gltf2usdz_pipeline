FROM lambci/lambda-base:build

ENV AWS_EXECUTION_ENV=AWS_Lambda_python2.7 \
  PYTHONPATH=/var/runtime

RUN rm -rf /var/runtime /var/lang && \
  curl https://lambci.s3.amazonaws.com/fs/python2.7.tgz | tar -zx -C /

# Add these as a separate layer as they get updated frequently
RUN curl --silent --show-error --retry 5 https://bootstrap.pypa.io/get-pip.py | python
RUN pip install -U virtualenv pipenv --no-cache-dir
RUN pip install -U awscli boto3 aws-sam-cli==0.10.0 aws-lambda-builders==0.0.5 --no-cache-dir

RUN pip install pyside2
RUN pip install PyOpenGL
RUN git clone https://github.com/PixarAnimationStudios/USD

RUN yum install -y wget
RUN wget https://github.com/Kitware/CMake/releases/download/v3.13.3/cmake-3.13.3.tar.gz --show-progress
RUN tar xzf cmake-3.13.3.tar.gz && \ 
  cd cmake-3.13.3 && \
  ./bootstrap && \
  make && \
  make install && \
  cd ../ && \
  yum install -y python-devel && \
  yum install -y libXrandr && \
  yum install -y libXrandr-devel

RUN yum install -y mesa-libGL-devel && \
  yum install -y mesa-libGLU-devel && \
  yum install -y libXinerama && \
  yum install -y libXinerama-devel && \
  yum install -y libXcursor && \
  yum install -y libXcursor-devel && \
  wget https://github.com/glfw/glfw/releases/download/3.2.1/glfw-3.2.1.zip --show-progress && \
  unzip glfw-3.2.1.zip && \ 
  cd glfw-3.2.1 && \
  cmake . -G "Unix Makefiles" && \
  make && \
  make install && \
  cd ../

RUN wget https://sourceforge.net/projects/glew/files/glew/2.1.0/glew-2.1.0.zip/download --show-progress
RUN unzip download && \ 
  cd glew-2.1.0 && \
  make && \
  make install && \
  cd ../

RUN yum install -y libXi
RUN yum install -y libXi-devel
RUN python USD/build_scripts/build_usd.py /usr/local/USD

ENV PYTHONPATH ${PYTHONPATH}:/usr/local/USD/lib/python/ 
ENV PATH ${PATH}:/usr/local/USD/bin

RUN git clone https://github.com/kcoley/gltf2usd.git
RUN cd gltf2usd && \
  pip install -r requirements.txt