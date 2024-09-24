#!/bin/bash
# Author: Athmane Madjoudj <athmanem@gmail.com>

t_Log "$0 - Installing crond"
t_InstallPackage cronie
t_ServiceControl crond cycle
