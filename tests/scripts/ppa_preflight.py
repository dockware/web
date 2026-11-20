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

# colors only in a terminal (CircleCI shows them too, plain files stay readable)
TTY = sys.stdout.isatty()
GREEN, RED, DIM, RESET = ("\033[32m", "\033[31m", "\033[2m", "\033[0m") if TTY else ("", "", "", "")


def package(version):
    # "8.5.13-2+ubuntu24.04.1+deb.sury.org+1" -> "8.5.13-2"
    return version.split("+", 1)[0] if version else "-"


# single source of truth: the active (not commented) entries in install_php.sh
with open("src/scripts/install_php.sh") as f:
    versions = re.findall(r'^\s*"(\d+\.\d+):\d+"', f.read(), re.M)

print("PHP PREFLIGHT")
print(f"{DIM}Checks that the ondrej/php PPA (Launchpad) has published the same php-fpm package")
print(f"for {' and '.join(ARCHS)} on Ubuntu {SERIES}. Otherwise the multi-arch build gets different PHP versions.")
print(f"PHP versions from src/scripts/install_php.sh: {', '.join(versions)}{RESET}")
print()
print(f"  {'PHP':<6}{'amd64':<18}{'arm64':<18}STATUS")

failed = []
for v in versions:
    entries = json.load(urllib.request.urlopen(API.format(v=v), timeout=30))["entries"]
    found = {}
    for e in entries:
        series, arch = e["distro_arch_series_link"].split("/")[-2:]
        if series == SERIES and arch in ARCHS:
            found[arch] = e["binary_package_version"]

    missing = [a for a in ARCHS if a not in found]
    if missing:
        status = f"{RED}MISSING {', '.join(missing)}{RESET}"
    elif len(set(found.values())) > 1:
        status = f"{RED}NOT IN SYNC{RESET}"
    else:
        status = f"{GREEN}OK{RESET}"
    if missing or len(set(found.values())) > 1:
        failed.append(v)
    print(f"  {v:<6}{package(found.get('amd64')):<18}{package(found.get('arm64')):<18}{status}")

print()
if failed:
    print(f"{RED}FAILED: PHP {', '.join(failed)} not published for all architectures yet.{RESET}")
    print("Launchpad usually builds arm64 a few hours after amd64. Nothing to fix here, try again later.")
    sys.exit(1)

print(f"{GREEN}OK: all PHP versions are published with the same package for {' and '.join(ARCHS)}.{RESET}")
