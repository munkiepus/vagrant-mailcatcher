#!/usr/bin/env bash

export DEBIAN_FRONTEND="noninteractive"

# update package list
apt-get update

# local dev mail server
echo "-- installing mailcatcher -- "

apt-get install ruby ruby-dev ruby-all-dev sqlite3 libsqlite3-dev -y

gem install mailcatcher

# create a systemd service
echo '[Unit]
Description = MailCatcher
After=network.target
After=systemd-user-sessions.service

[Service]
Type=simple
Restart=on-failure
User=vagrant
ExecStart=/usr/local/bin/mailcatcher --smtp-ip 0.0.0.0 --ip 0.0.0.0

[Install]
WantedBy=multi-user.target
' >> /etc/systemd/system/mailcatcher.service

chmod 644 /etc/systemd/system/mailcatcher.service

# enable mailcatcher on startup
systemctl enable mailcatcher
service mailcatcher start
service mailcatcher status

# Adding title to MOTD
apt-get install update-motd -y
cat /vagrant/motd.sh > /etc/update-motd.d/01-header
chmod 755 /etc/update-motd.d/01-header
/usr/sbin/update-motd

# setting hostname
echo "Setting Hostname"
echo "mailcatcher-ubuntu" > /etc/hostname
echo "127.0.0.1 mailcatcher-ubuntu" >> /etc/hosts


