# macos-blackhole

## What is this?

A simple bash script I use on my MacBook. When run the script will:

* Download and install the simple hosts file manager [Gas Mask](https://github.com/2ndalpha/gasmask)
* Download [StevenBlack's](https://github.com/StevenBlack/hosts) well-curated host files to load within Gas Mask
* If Gas Mask is already installed, the host files will be updated to the latest versions


## How do I run it?

Either

```
git clone https://github.com/TheDen/macos-blackhole
./macos-blackhole/setup.sh
```

```
curl -sL https://raw.githubusercontent.com/TheDen/macos-blackhole/master/setup.sh -o setup.sh
chmod +x setup.sh
./setup.sh
```


Or live dangerously and pipe the script to `bash`

```
curl -sL https://raw.githubusercontent.com/TheDen/macos-blackhole/master/setup.sh | bash
```

## Why not just use [pi-hole](https://github.com/pi-hole/pi-hole)?

I love pi-hole, but sometimes pi-hole can't be deployed on networks where the the user is not an admin (or on untrusted networks). This allows mobility with respect to host blocking.

## Contributions and Caveats

Room for improvement and considerations for PRs:

* Currently it's set up to only download two host files from SteveBlack's repo. Personally these are the two I mainly use, though the script could be updated to download them all
* This uses version `0.8.5` of Gas Mask since it's the latest one listed under the repo's [releases page](https://github.com/2ndalpha/gasmask/releases). Version [`0.8.6`](http://gmask.clockwise.ee/files/gas_mask_0.8.6.zip) is available, but it's hosted on a server without `https`, so that's a dealbreaker.
* Even though this is a personal script, I attempted to make it portable, deps are builtins, `bash` (avoiding v4 bashisms), `curl`, `unzip`, and `shasum`. So it's not guaranteed to work on your machine (but most likely will).
* The script ought to be formatted with `shfmt -i 2 -ci -sr` ([https://github.com/mvdan/sh](https://github.com/mvdan/sh)) and the script must pass [shellcheck](https://github.com/koalaman/shellcheck) (could potentially add a CI)
* A nice way to run the script on schedule in MacOS? `crontab`?
* There is inherit hackyness in this setup, but it's quick and works for me


## What is MacOS's default host file?

```
127.0.0.1	localhost
255.255.255.255	broadcasthost
::1 localhost
fe80::1%lo0	localhost
```
