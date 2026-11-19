#!/usr/bin/env python3
# Checks that the PHP repository (packages.sury.org, see src/Dockerfile) has published the same
# php-fpm build for every architecture we push. arm64 sometimes arrives hours after amd64, and
# a multi-arch build in that window ends up with mismatching or broken packages.
# Uses the same logic as the PHP watcher (tests/scripts/php_watch.py).
import re
import sys

from php_watch import ARCHS, fetch

# single source of truth: the active (not commented) entries in install_php.sh
with open("src/scripts/install_php.sh") as f:
    versions = re.findall(r'^\s*"(\d+\.\d+):\d+"', f.read(), re.M)

failed = False
for v in versions:
    found = fetch(v)
    missing = [a for a in ARCHS if a not in found]
    if missing or len(set(found.values())) > 1:
        failed = True
        print(f"PHP {v}: NOT IN SYNC {found} missing={missing}")
    else:
        print(f"PHP {v}: ok {found[ARCHS[0]]}")

if failed:
    print("PHP repository not in sync for all architectures, try again later.")
    sys.exit(1)
