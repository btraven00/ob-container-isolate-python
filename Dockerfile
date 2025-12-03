# Start with Python 3.12 as base and add Python 2.7
FROM python:3.12-slim

# Install dependencies needed for building Python 2.7 and general usage
RUN apt-get update && apt-get install -y \
    build-essential \
    wget \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    libncurses5-dev \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libffi-dev \
    liblzma-dev \
    git \
    && rm -rf /var/lib/apt/lists/*

# Download and compile Python 2.7.18
RUN cd /tmp && \
    wget --no-check-certificate https://www.python.org/ftp/python/2.7.18/Python-2.7.18.tgz && \
    tar xzf Python-2.7.18.tgz && \
    cd Python-2.7.18 && \
    ./configure --prefix=/usr/local/python2.7 --enable-shared && \
    make -j$(nproc) && \
    make altinstall && \
    cd / && rm -rf /tmp/Python-2.7.18*

# Create symlinks for python2.7 and update library path
RUN ln -sf /usr/local/python2.7/bin/python2.7 /usr/local/bin/python2.7 && \
    ln -sf /usr/local/python2.7/bin/python2.7 /usr/local/bin/python2 && \
    echo "/usr/local/python2.7/lib" > /etc/ld.so.conf.d/python2.7.conf && \
    ldconfig

# Install pip for Python 2.7
RUN cd /tmp && \
    wget --no-check-certificate https://bootstrap.pypa.io/pip/2.7/get-pip.py && \
    /usr/local/python2.7/bin/python2.7 get-pip.py && \
    rm get-pip.py

# Create symlink for Python 2.7 pip
RUN ln -sf /usr/local/python2.7/bin/pip /usr/local/bin/pip2.7 && \
    ln -sf /usr/local/python2.7/bin/pip /usr/local/bin/pip2

WORKDIR /app

COPY requirements-legacy.pip .

# Install compatible pydantic-core and omnibenchmark in Python 3.12 (system)
RUN pip3.12 install --upgrade pip && \
    pip3.12 install pydantic-core==2.23.4 pydantic==2.5.0 && \
    pip3.12 install omnibenchmark==0.3.2 snakemake

# Create Python 2.7 virtual environment and install dependencies
RUN /usr/local/python2.7/bin/pip install virtualenv && \
    /usr/local/python2.7/bin/virtualenv .venv && \
    .venv/bin/pip install -r requirements-legacy.pip

# Make Python 3.12 the default for Snakemake compatibility
# Legacy scripts will use explicit shebang #!/usr/local/bin/python2.7
ENV PATH="/usr/local/bin:$PATH"

# Copy the legacy application code
COPY legacy_script.py .

# Make legacy script executable
RUN chmod +x legacy_script.py

# Verify both Python versions are available
RUN python2.7 --version && python3.12 --version && python --version

# Define the entrypoint - script will use its shebang for Python 2.7
ENTRYPOINT ["./legacy_script.py"]