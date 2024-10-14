FROM ubuntu:24.04

# Set environment variables to avoid prompts during installation
ENV DEBIAN_FRONTEND=noninteractive
ENV IDF_PATH=/opt/esp-idf
ENV PATH="$IDF_PATH/tools:$PATH"

# Update package list and install required packages
RUN apt-get update && apt-get install -y python3 python3-pip python3-venv git unzip wget curl vim

# Download and install ESP-IDF 5.1.1
RUN git clone -b v5.1.1 https://github.com/espressif/esp-idf.git $IDF_PATH && \
    cd $IDF_PATH && \
    git submodule update --init --recursive

# Install required ESP-IDF tools
RUN cd $IDF_PATH && \
    ./install.sh

# Download and unpack the repository
RUN cd / && \
    wget -O esphome.zip https://github.com/angelnu/esphome-1/archive/refs/heads/extend_ota.zip && \
    unzip esphome.zip && \
    rm esphome.zip

# Change into the unpacked directory
WORKDIR /esphome-1-extend_ota

# Create a Python virtual environment and install the PR version of ESPHome
RUN python3 -m venv venv && \
    . venv/bin/activate && \
    venv/bin/pip install . && \
    venv/bin/pip install setuptools

# Set the default command to run a bash shell
# ENTRYPOINT ["/bin/bash"]
CMD ["sleep", "infinity"]
