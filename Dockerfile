# Use the official Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Set the environment variables for non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive

# Update the package list and install required packages
RUN apt-get update && \
    apt-get install -y \
    wget \
    curl \
    ca-certificates \
    gnupg \
    lsb-release \
    python3 \
    python3-pip

# Download and install FSL version 6.0.7.4 using fslinstaller.py
RUN wget https://fsl.fmrib.ox.ac.uk/fsldownloads/fslinstaller.py && \
    python3 fslinstaller.py -V 6.0.7.4 -d /usr/local/fsl && \
    rm fslinstaller.py
    
# Set FSL environment variables
ENV FSLDIR=/usr/local/fsl \
    PATH=/usr/local/fsl/bin:$PATH \
    FSLMULTIFILEQUIT=TRUE \
    POSSUMDIR=/usr/local/fsl \
    LD_LIBRARY_PATH=/usr/local/fsl/lib:$LD_LIBRARY_PATH \
    FSLOUTPUTTYPE=NIFTI_GZ

# Copy the repository files into the Docker image
COPY . /opt/mydeface

# Set the working directory
WORKDIR /opt/mydeface

# Clean up package lists to reduce image size
RUN apt-get clean && rm -rf /var/lib/apt/lists/

ENV PATH="$PATH:/opt/mydeface"

CMD ["python", "mydeface.py", "$@"]
