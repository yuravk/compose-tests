#!/bin/bash -e

source ../functions.sh
./0-install_cron.sh
./cron_crontab_daily_test.sh
./cron_crontab_hourly_test.sh
./cron_crontab_weekly_test.sh
