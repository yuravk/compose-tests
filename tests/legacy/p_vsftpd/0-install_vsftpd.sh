#!/bin/bash
# Author: Athmane Madjoudj <athmanem@gmail.com>

t_Log "Running $0 - installing vsFTPd."
# nc for the login tests, don't rely on an earlier test having installed it
t_InstallPackage vsftpd nc
if [ "$centos_ver" -ge 8 ] ; then
cp -fp /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf.tf_p_vsftpd
sed -i 's/anonymous_enable=NO/anonymous_enable=YES/g' /etc/vsftpd/vsftpd.conf
fi
t_ServiceControl vsftpd restart
if [ "$centos_ver" -ge 8 ] ; then
mv -f /etc/vsftpd/vsftpd.conf.tf_p_vsftpd /etc/vsftpd/vsftpd.conf
fi
