# macos-blackhole

## What is is?

A simple bash script I use on my MacBook. When run the script will:

* Download and install the simple hosts file manager [Gas Mask](https://github.com/2ndalpha/gasmask) 
* Download [StevenBlack's](https://github.com/StevenBlack/hosts) well-curated host files to load within Gas Mask
* If Gas Mask is already installed, the host files will be updated to the latest versions

## Why not just use [pi-Hole](https://github.com/pi-hole/pi-hole)?

Sometimes pi-hole can't be deployed on networks you have control of (or unstrusted networks). This allows mobility with respect to host blocking.

