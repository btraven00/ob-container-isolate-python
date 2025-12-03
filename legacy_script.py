#!/usr/local/bin/python2.7
# This is a Python 2 compatible script
# No one should use Python 2 anymore, but academics sadly still have to do.
# kudos to those who continue to use Python 2! And greetings from the future!
import sys
import os

# Add virtual environment packages to Python path
venv_site_packages = '/app/.venv/lib/python2.7/site-packages'
if os.path.exists(venv_site_packages):
    sys.path.insert(0, venv_site_packages)

import platform

def main():
    print "-----------------------------------------------------"
    print "Greetings from the Ancient World!"
    print "-----------------------------------------------------"
    print "Running on Python Version: " + sys.version
    print "Platform: " + platform.platform()
    print "-----------------------------------------------------"

    # Showcase a Python 2 specific syntax (print statement without parens)
    print "This print statement uses Python 2 syntax (no parentheses)."

    # Check the installed deps
    import requests
    print "requests version:", requests.__version__

    # Verify standard library behavior
    try:
        # xrange is Python 2 only (became range in Python 3)
        x = xrange(5)
        print "xrange(5) object created successfully: " + str(x)
    except NameError:
        print "Error: xrange not found! Are you sure this is Python 2?"
    
    # Write Python version information to test.txt
    with open("test.txt", "w") as f:
        f.write("Python Version: " + sys.version + "\n")
        f.write("Python Executable: " + sys.executable + "\n")
        f.write("Platform: " + platform.platform() + "\n")
        f.write("Requests Version: " + requests.__version__ + "\n")
    
    print "Python version information written to test.txt"

if __name__ == "__main__":
    main()
