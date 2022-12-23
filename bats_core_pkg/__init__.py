#!/usr/bin/env python3
import sys
import subprocess



def main():
    proc = subprocess.run(["bats_core_pkg/dist/bin/bats"] + sys.argv[1:], check=False)
    return proc.returncode


if __name__ == "__main__":
    sys.exit(main())
