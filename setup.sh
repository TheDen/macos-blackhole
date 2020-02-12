#!/bin/bash

# Script will download and install https://github.com/2ndalpha/gasmask if not installed.
# Two host files from https://github.com/StevenBlack/hosts will be pulled for Gas Mask.
# If Gas Mask is already installed the host files will be updated.

set -euo pipefail

## Globals
gasmask_version="0.8.5"
gasmask_zip="gas_mask_${gasmask_version}.zip"
gasmask_url="https://github.com/2ndalpha/gasmask/releases/download/${gasmask_version}/${gasmask_zip}"
gasmask_checksum="e62755aa8c8466c4149d37057f1a29cef8bae7fe77949fa9e1123eebf9b3b0b41b9e05a9d1f098dc775c5c65be12d2baf51321e70df069a967d35b4951cc2f0f  ${gasmask_zip}"
gasmask_install_dir="/Applications"
gasmask_local_dir="${HOME}/Library/Gas Mask/Local"
temp_folder=$(mktemp -d)
# Unified hosts = (adware + malware)
unified_hosts="https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
# Unified hosts + fakenews + gambling + porn + social
unified_hosts_fakenews_gambling_porn_social="https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn-social/hosts"

# Cleanup function
cleanup() {
  if [ -n "${temp_folder}" ]; then
    rm -rf "${temp_folder}"
  fi
}
trap 'cleanup' EXIT
trap 'cleanup HUP' HUP
trap 'cleanup TERM' TERM
trap 'cleanup INT' INT

download_and_install_gas_mask() {
  echo "Downloading Gas Mask..."
  curl -sL "${gasmask_url}" -o "${temp_folder}/${gasmask_zip}"
  echo "${temp_folder}/${gasmask_zip}"
  (
    cd "${temp_folder}"
    echo "${gasmask_checksum}" | shasum -a 512 -c
  )
  echo "Installing Gas Mask..."
  unzip -oq "${temp_folder}/${gasmask_zip}" -d "${gasmask_install_dir}"
}

start_gas_mask() {
  "${gasmask_install_dir}/Gas Mask.app/Contents/Resources/Launcher.app/Contents/MacOS/Launcher" || true
}

kill_gas_mask() {
  pkill -x "Gas Mask" || true
}

download_hostfile() {
  echo "Downloading hostfile ${2} to ${gasmask_local_dir}"
  curl -sL "$1" -o "${gasmask_local_dir}/${2}.hst"
}

restart_gas_mask() {
  echo "Restarting Gas Mask..."
  start_gas_mask
  kill_gas_mask
}

if [ ! -d "${gasmask_install_dir}/Gas Mask.app/" ]; then
  download_and_install_gas_mask
fi

restart_gas_mask

until [ -d "${gasmask_local_dir}" ]; do
  sleep 2
done

# Download the hostfiles
download_hostfile "${unified_hosts}" "${!unified_hosts@}"
download_hostfile "${unified_hosts_fakenews_gambling_porn_social}" "${!unified_hosts_fakenews_gambling_porn_social@}"
restart_gas_mask
cleanup
