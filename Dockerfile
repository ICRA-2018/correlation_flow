FROM roslab/roslab:kinetic

USER root

RUN apt-get update \
 && apt-get install -yq --no-install-recommends \
    libfftw3-dev \
    libfftw3-doc \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN mkdir -p ${HOME}/catkin_ws/src/correlation-flow
COPY . ${HOME}/catkin_ws/src/correlation-flow/.
RUN cd ${HOME}/catkin_ws \
 && mv src/correlation-flow/README.ipynb .. \
 && apt-get update \
 && /bin/bash -c "source /opt/ros/kinetic/setup.bash && rosdep update && rosdep install --as-root apt:false --from-paths src --ignore-src -r -y" \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && /bin/bash -c "source /opt/ros/kinetic/setup.bash && catkin_make"

RUN echo "source ~/catkin_ws/devel/setup.bash" >> ${HOME}/.bashrc

RUN chown -R ${NB_UID} ${HOME}

USER ${NB_USER}
WORKDIR ${HOME}
