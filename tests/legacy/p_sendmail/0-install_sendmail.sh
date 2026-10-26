#!/bin/bash
# Author: Athmane Madjoudj <athmanem@gmail.com>

t_Log "Running $0 - remove unused MTAs and install sendmail"

# rsyslog writes /var/log/maillog the delivery checks read, don't rely on
# an earlier test (p_postfix) having installed and started it
t_InstallPackage sendmail nc rsyslog

# Remove other MTAs
t_ServiceControl postfix stop
t_ServiceControl exim stop
sleep 3
t_RemovePackage postfix exim

t_ServiceControl sendmail start
t_ServiceControl rsyslog start
