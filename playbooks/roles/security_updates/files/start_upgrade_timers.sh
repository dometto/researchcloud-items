#!/bin/bash

systemctl enable apt-daily.timer
systemctl enable apt-daily-upgrade.timer
systemctl start apt-daily.timer
systemctl start apt-daily-upgrade.timer

systemctl disable upgrade-timer-bootstrap.timer
systemctl stop upgrade-timer-bootstrap.timer