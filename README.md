# linux-system-update
A simple shell script to keep Linux distros up to date

### Installation
```
prompt$> sudo make install
```
Installs as `/usr/local/sbin/system_update.sh`

### Usage
Place in root's crontab like so:
`
# OS updates and reboot every Sunday
`
`
0 2 * * 6 (/usr/local/sbin/system_update.sh > /dev/null 2>&1)
`
