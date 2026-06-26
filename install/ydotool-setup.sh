#!/usr/bin/env bash
# Set up ydotoold as a root system service so voice-dictate can type into any
# window under Wayland. Root opens /dev/uinput directly - no udev/group/relogin
# fragility, and it survives reboots. The socket is owned by the invoking user.
#   bash install/ydotool-setup.sh        (will sudo)
set -euo pipefail

command -v ydotoold >/dev/null || { echo "install ydotool first: sudo dnf install ydotool" >&2; exit 1; }
UID_N=$(id -u); GID_N=$(id -g)

sudo tee /etc/systemd/system/ydotoold.service >/dev/null <<EOF
[Unit]
Description=ydotoold (system virtual input daemon for voice-dictate)
After=multi-user.target

[Service]
ExecStartPre=/sbin/modprobe uinput
ExecStart=/usr/bin/ydotoold --socket-path=/run/ydotoold.socket --socket-own=$UID_N:$GID_N
Restart=always
RestartSec=2

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now ydotoold.service
echo "ydotoold active: $(systemctl is-active ydotoold.service)"
echo "Add to your shell rc:  export YDOTOOL_SOCKET=/run/ydotoold.socket"
