#!/bin/bash
# Simple entrypoint that activates Python 2.7 environment and executes legacy script

set -euo pipefail

# Change to home directory where omnibenchmark expects output structure
cd $HOME

# Activate Python 2.7 virtual environment
export PATH="/app/.venv/bin:$PATH"

# Execute the legacy script with Python 2.7
exec python2.7 legacy_script.py "$@"