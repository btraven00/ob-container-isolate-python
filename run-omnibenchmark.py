#!/usr/bin/env -S uv run
# Run omnibenchmark on the host.
# /// script
# requires-python = "==3.12"
# dependencies = [
#     "omnibenchmark==0.3.2",
# ]
# ///
"""
Simple UV script to run omnibenchmark 0.3.2
Usage: ./run-omnibenchmark.py benchmark.yaml
"""

import sys
import subprocess

def main():
    if len(sys.argv) < 2:
        print("Usage: ./run-omnibenchmark.py <benchmark.yaml>", file=sys.stderr)
        sys.exit(1)

    benchmark_file = sys.argv[1]

    # Call omnibenchmark CLI
    cmd = ["ob", "run", "benchmark", "-b", benchmark_file]
    result = subprocess.run(cmd)
    sys.exit(result.returncode)

if __name__ == "__main__":
    main()
