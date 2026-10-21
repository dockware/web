#!/usr/bin/env python3
# Checks that the ondrej/php PPA has published the same php-fpm build for every
# architecture we push. Launchpad builds arm64 hours after amd64 at times, and a
# multi-arch build in that window ends up with mismatching or broken packages.
import json
import re
import sys
import urllib.request

SERIES = "noble"  # ubuntu:24.04 in src/Dockerfile
ARCHS = ["amd64", "arm64"]
API = "https://api.launchpad.net/1.0/~ondrej/+archive/ubuntu/php?ws.op=getPublishedBinaries&binary_name=php{v}-fpm&exact_match=true&status=Published"

# single source of truth: the active (not commented) entries in install_php.sh
with open("src/scripts/install_php.sh") as f:
    versions = re.findall(r'^\s*"(\d+\.\d+):\d+"', f.read(), re.M)

failed = False
for v in versions:
    entries = json.load(urllib.request.urlopen(API.format(v=v), timeout=30))["entries"]
    found = {}
    for e in entries:
        series, arch = e["distro_arch_series_link"].split("/")[-2:]
        if series == SERIES and arch in ARCHS:
            found[arch] = e["binary_package_version"]

    missing = [a for a in ARCHS if a not in found]
    if missing or len(set(found.values())) > 1:
        failed = True
        print(f"PHP {v}: NOT IN SYNC {found} missing={missing}")
    else:
        print(f"PHP {v}: ok {found[ARCHS[0]]}")

if failed:
    print("PPA not in sync for all architectures, try again later.")
    sys.exit(1)
