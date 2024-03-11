set -e
export XDG_RUNTIME_DIR=/run/user/$(id -u)
systemctl --user enable --now podman.socket
podman --url unix://run/user/$(id -u)/podman/podman.sock run --name simple-test-with-port-mapping -d -p 8080:80 docker.io/nginx:latest
pid=$(systemctl --user show --property MainPID --value podman.service)
while [ "${pid}" -ne 0 ] && [ -d /proc/${pid} ]; do sleep 1; echo "Waiting for podman to exit"; done
echo "Continuing"
podman --url unix://run/user/$(id -u)/podman/podman.sock ps | grep -q -e simple-test-with-port-mapping
podman --url unix://run/user/$(id -u)/podman/podman.sock container rm -f simple-test-with-port-mapping
systemctl --user disable --now podman.socket
