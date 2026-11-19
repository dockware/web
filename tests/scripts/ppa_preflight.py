#!/usr/bin/env python3
# Checks that packages.sury.org has published the same php-fpm build for every
# architecture we push. Sury builds arm64 hours after amd64 at times, and a
# multi-arch build in that window ends up with mismatching or broken packages.
import gzip
import re
import sys
import urllib.request

SERIES = "noble"  # ubuntu:24.04 in src/Dockerfile
ARCHS = ["amd64", "arm64"]
PACKAGES = "https://packages.sury.org/php/dists/{series}/main/binary-{arch}/Packages.gz"

# single source of truth: the active (not commented) entries in install_php.sh
with open("src/scripts/install_php.sh") as f:
    versions = re.findall(r'^\s*"(\d+\.\d+):\d+"', f.read(), re.M)

# package name -> version, per architecture
published = {}
for arch in ARCHS:
    index = gzip.decompress(urllib.request.urlopen(PACKAGES.format(series=SERIES, arch=arch), timeout=60).read()).decode()
    published[arch] = dict(re.findall(r"^Package: (\S+)\n(?:.+\n)*?Version: (\S+)", index, re.M))

failed = False
for v in versions:
    found = {a: published[a][f"php{v}-fpm"] for a in ARCHS if f"php{v}-fpm" in published[a]}

    missing = [a for a in ARCHS if a not in found]
    if missing or len(set(found.values())) > 1:
        failed = True
        print(f"PHP {v}: NOT IN SYNC {found} missing={missing}")
    else:
        print(f"PHP {v}: ok {found[ARCHS[0]]}")

if failed:
    print("packages.sury.org not in sync for all architectures, try again later.")
    sys.exit(1)
