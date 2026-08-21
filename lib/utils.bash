#!/usr/bin/env bash

set -euo pipefail

fail() {
  echo "asdf-sops: $*" >&2
  exit 1
}

release_tag() {
  local version=$1
  local numeric_version="${version#v}"
  numeric_version="${numeric_version%%[-+]*}"
  local major minor patch
  IFS=. read -r major minor patch <<< "$numeric_version"

  if [[ ! "$major" =~ ^[0-9]+$ || ! "$minor" =~ ^[0-9]+$ || ! "$patch" =~ ^[0-9]+$ ]]; then
    fail "unsupported SOPS version: ${version}"
  fi

  if ((major > 3 || (major == 3 && minor > 4))); then
    echo "v${numeric_version}"
  else
    echo "$numeric_version"
  fi
}

get_platform() {
  case "$(uname)" in
    Linux) echo "linux" ;;
    Darwin) echo "darwin" ;;
    *) fail "unsupported operating system: $(uname)" ;;
  esac
}

get_cpu() {
  local machine_hardware_name
  machine_hardware_name=${ASDF_SOPS_OVERWRITE_ARCH:-"$(uname -m)"}

  case "$machine_hardware_name" in
    x86_64) echo "amd64" ;;
    aarch64 | arm64) echo "arm64" ;;
    *) fail "unsupported CPU architecture: $machine_hardware_name" ;;
  esac
}

get_download_url() {
  local version=$1
  local tag
  tag=$(release_tag "$version")
  local numeric_version="${tag#v}"
  local major minor patch
  IFS=. read -r major minor patch <<< "$numeric_version"
  local platform
  platform=$(get_platform)

  if ((major < 3 || (major == 3 && minor < 7) || (major == 3 && minor == 7 && patch <= 2))); then
    echo "https://github.com/getsops/sops/releases/download/${tag}/sops-${tag}.${platform}"
  else
    echo "https://github.com/getsops/sops/releases/download/${tag}/sops-${tag}.${platform}.$(get_cpu)"
  fi
}

download_release() {
  local version=$1
  local destination=$2
  local url
  url=$(get_download_url "$version")

  echo "Downloading SOPS from ${url}"
  if ! curl -fsSL "$url" -o "$destination"; then
    rm -f "$destination"
    fail "failed to download SOPS ${version}"
  fi
}
