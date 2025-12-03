# Ancient Python 2.7 with virtualenv & Apptainer

This project demonstrates how to bootstrap a legacy Python 2.7 environment
inside a container. This is ideal for archiving old scientific workflows or
running legacy scripts on modern HPC clusters using Apptainer.

The motivation is to allow omnibenchmark users to run legacy Python 2.7 scripts
and bypass a current limitation in omnibenchmark's use of snakemake, where 
the execution environment needs to be compatible with Python 3.12 and the set 
of dependencies required by omnibenchmark itself.

If you need to support other pythons, you might consider to make your life easier
and adopt uv as part of the workflow instead (only for python >= 3.8).

## Production Usage Note

**Important**: The `legacy_script.py` included in this Docker image is for debugging 
and testing purposes only. In production, your actual legacy scripts should be 
**mounted externally** by Apptainer/Singularity from the host filesystem, not 
embedded in the container image.

This approach provides:
- **Flexibility**: Update scripts without rebuilding containers
- **Separation of concerns**: Container provides environment, host provides code
- **Easier debugging**: Scripts remain editable on the host

Example production usage:
```bash
apptainer exec --bind /path/to/your/scripts:/mnt/scripts py27.sif python2.7 /mnt/scripts/your_legacy_script.py
```

## 1. Build the Docker Image

First, build the standard Docker image to verify everything works locally.

docker build -t py27-multi .


Run it to test:

docker run --rm py27-multi


You should see output confirming Python 2.7.18 (or similar) is running:

```
❯ docker run --rm py27-multi
-----------------------------------------------------
Greetings from the Ancient World!
-----------------------------------------------------
Running on Python Version: 2.7.18 (default, Apr 20 2020, 19:34:11)
[GCC 8.3.0]
Platform: Linux-6.17.4-76061704-generic-x86_64-with-debian-10.3
-----------------------------------------------------
This print statement uses Python 2 syntax (no parentheses).
xrange(5) object created successfully: xrange(5)
```

## 2. Convert to Apptainer (Singularity)

If you have apptainer installed on your machine (linux) or are running this on an HPC cluster, you can pull directly from your local Docker daemon or a registry.

Option A: Pull from local Docker daemon (if running Linux/rootless)

apptainer build py27.sif docker-daemon://py27-multi:latest


Option B: Save to tar and build (more compatible)

If you cannot pull from the daemon directly:

Save the docker image:

docker save py27-multi -o py27.tar


Build Apptainer image from the tarball:

apptainer build py27.sif docker-archive://py27.tar


## 3. Run with Apptainer

You can execute specific commands using the internal Python 2.7:

apptainer exec py27.sif python legacy_script.py

```
-----------------------------------------------------
Greetings from the Ancient World!
-----------------------------------------------------
Running on Python Version: 2.7.18 (default, Apr 20 2020, 19:34:11)
[GCC 8.3.0]
Platform: Linux-6.17.4-76061704-generic-x86_64-with-debian-10.3
-----------------------------------------------------
This print statement uses Python 2 syntax (no parentheses).
requests version: 2.27.1
xrange(5) object created successfully: xrange(5)
```

Or the standard python3:

apptainer exec py27.sif python3 -c "import sys; print(sys.version)"

```
3.12.12 (main, Nov 18 2025, 05:56:04) [GCC 14.2.0]
```
