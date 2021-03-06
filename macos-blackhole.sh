#!/bin/bash

# Script will download and install https://github.com/2ndalpha/gasmask if not installed.
# Three host files from https://github.com/StevenBlack/hosts will be pulled for Gas Mask.
# If Gas Mask is already installed the host files will be updated.

set -euo pipefail

## Globals
gasmask_version="0.8.6"
gasmask_zip="gas_mask_${gasmask_version}.zip"
gasmask_url="https://github.com/2ndalpha/gasmask/releases/download/${gasmask_version}/${gasmask_zip}"
gasmask_checksum="0e1cd30ce60bc41a307f401afbb4706c14c819f85852a72ad743e81fcc74fbef70f288ab7f84cc50870fb7ff1b601bc883cfd8ef0ee4f9a71f09a53a55fe3047  ${gasmask_zip}"
gasmask_install_dir="/Applications"
gasmask_local_dir="${HOME}/Library/Gas Mask/Local"
temp_folder=$(mktemp -d)

# Unified hosts = (adware + malware)
hostfiles=(
  'unified_hosts=https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts'
  'unified hosts_fakenews_gambling_porn=https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts'
  'unified_hosts_fakenews_gambling_porn_social=https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn-social/hosts'
)

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
for host in "${hostfiles[@]}"; do
  host_filename=$(awk -F "=" '{print $1}' <<< "${host}")
  host_url=$(awk -F "=" '{print $2}' <<< "${host}")
  download_hostfile "${host_url}" "${host_filename}"
done

restart_gas_mask
cleanup
