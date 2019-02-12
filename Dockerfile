FROM lambci/lambda-base:build

ENV AWS_EXECUTION_ENV=AWS_Lambda_python2.7 \
  PYTHONPATH=/var/runtime

RUN rm -rf /var/runtime /var/lang && \
  curl https://lambci.s3.amazonaws.com/fs/python2.7.tgz | tar -zx -C /

# Add these as a separate layer as they get updated frequently
RUN curl --silent --show-error --retry 5 https://bootstrap.pypa.io/get-pip.py | python && \
  pip install -U virtualenv pipenv --no-cache-dir && \
  pip install -U awscli boto3 aws-sam-cli==0.10.0 aws-lambda-builders==0.0.5 --no-cache-dir

RUN pip install --index-url=http://download.qt.io/snapshots/ci/pyside/5.9/latest/ pyside2 --trusted-host download.qt.io && \
  pip install PyOpenGL && \
  git clone https://github.com/PixarAnimationStudios/USD

RUN yum install -y wget && \
  wget https://github.com/Kitware/CMake/releases/download/v3.13.3/cmake-3.13.3.tar.gz && \
  tar xzf cmake-3.13.3.tar.gz && \ 
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
  wget https://github.com/glfw/glfw/releases/download/3.2.1/glfw-3.2.1.zip && \
  unzip glfw-3.2.1.zip && \ 
  cd glfw-3.2.1 && \
  cmake . -G "Unix Makefiles" && \
  make && \
  make install && \
  cd ../

RUN wget https://sourceforge.net/projects/glew/files/glew/2.1.0/glew-2.1.0.zip/download && \
  unzip download && \ 
  cd glew-2.1.0 && \
  make && \
  make install && \
  cd ../

RUN yum install -y libXi && \
  yum install -y libXi-devel && \
  python USD/build_scripts/build_usd.py /usr/local/USD

ENV PYTHONPATH ${PYTHONPATH}:/usr/local/USD/lib/python/ 
ENV PATH ${PATH}:/usr/local/USD/bin

RUN git clone https://github.com/kcoley/gltf2usd.git && \
  cd gltf2usd && \
  pip install -r requirements.txt

# RUN python gltf2usd/Source/gltf2usd.py -g /root/shared-folder/Bed_Option01.gltf  -o /root/shared-folder/output.usdc && \
#   usdzip /root/shared-folder/ex.usdz --arkitAsset /root/shared-folder/output.usdc