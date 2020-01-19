# linux-system-update
A simple shell script to keep Linux distros up to date

### Prequisites
* A working **Arch**, **Debian**, **Raspbian**, or **Ubuntu** based Linux distribution with `make`

### Installation
```
prompt$> sudo make install
```
Installs as `/usr/local/sbin/system_update.sh`

### Usage
Place in root's crontab like so:
```
# OS updates and reboot every Sunday
0 2 * * 6 (/usr/local/sbin/system_update.sh > /dev/null 2>&1)
```
* You can also use 'make crontab' from within this repo to interactively create a crontab entry for `system_update.sh`
