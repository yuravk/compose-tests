#!/bin/bash
# Author: Yuriy Kohut <ykohut@almalinux.org>

# OS major version and machine hardware name
version_major=$( rpm --eval %rhel )
crb='PowerTools'
if [ "x${version_major}" = "x9" ]; then
    crb='CRB'
fi

t_Log "Verify that the installation works"

systemctl enable --now osbuild-composer.socket

systemctl restart osbuild-composer

composer-cli status show || t_CheckExitStatus $?

if [ "x${pungi_repository}" = "xtrue" ]; then
    t_Log "Running $0 - osbuild: Change 'baseurl' for native BaseOS and AppStream repositories into pungi one"
    os_repo_json="/usr/share/osbuild-composer/repositories/almalinux-${version_major}.${minor_ver}.json"
    test -e ${os_repo_json}.bak || cp -av ${os_repo_json} ${os_repo_json}.bak
    t_InstallPackageMinimal jq
    for repo_name in BaseOS AppStream; do
        name=${repo_name,,}
        baseurl="http://${arch}-pungi-${version_major}.almalinux.org/almalinux/${version_major}/${arch}/latest_result/compose/${repo_name}/${arch}/os/"
        cat ${os_repo_json} | jq --arg arch "${arch}" --arg baseurl "${baseurl}" --arg name "${name}" '(.'$arch'[] | select(.name == $name) | .baseurl) |= $baseurl' > ${os_repo_json}.new || t_CheckExitStatus $?
        mv -f ${os_repo_json}.new ${os_repo_json}
    done

    t_Log "Running $0 - osbuild: check if the new source was successfully added"
    composer-cli sources list || t_CheckExitStatus $?
else
    true
    t_CheckExitStatus $?
fi
