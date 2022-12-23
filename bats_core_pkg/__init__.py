#!/usr/bin/env python3
import sys
import subprocess
from pathlib import Path



def main():
    curfile = Path(__file__)
    bats_path = curfile.absolute().parent / "dist/bin/bats"
    proc = subprocess.run([bats_path] + sys.argv[1:], check=False)
    return proc.returncode


if __name__ == "__main__":
    sys.exit(main())
