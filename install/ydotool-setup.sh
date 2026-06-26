#!/usr/bin/env bash
# Phase 7 sudo batch: set up ydotoold so voice-dictate can type into any window
# under Wayland. Run AFTER phase0-sudo.sh (which installs the ydotool package).
#   ! bash /tmp/phase7-sudo.sh
set -euo pipefail

if ! command -v ydotoold >/dev/null 2>&1; then
  echo "ydotoold not found - run phase0-sudo.sh first (installs ydotool)." >&2
  exit 1
fi

echo "==> Configuring /dev/uinput permissions (udev + module + input group)..."
echo 'KERNEL=="uinput", GROUP="input", MODE="0660", OPTIONS+="static_node=uinput"' \
  | sudo tee /etc/udev/rules.d/99-uinput.rules >/dev/null
echo uinput | sudo tee /etc/modules-load.d/uinput.conf >/dev/null
sudo modprobe uinput || true
sudo udevadm control --reload-rules
sudo udevadm trigger --subsystem-match=misc || true
sudo usermod -aG input "$USER"

echo "==> Installing ydotoold as a user service..."
mkdir -p "$HOME/.config/systemd/user"
cat > "$HOME/.config/systemd/user/ydotoold.service" <<EOF
[Unit]
Description=ydotoold (virtual input daemon for voice-dictate)
After=graphical-session.target

[Service]
ExecStart=/usr/bin/ydotoold --socket-path=%t/.ydotool_socket --socket-perm=0600
Restart=always
RestartSec=2

[Install]
WantedBy=default.target
EOF
systemctl --user daemon-reload
systemctl --user enable --now ydotoold.service || true

echo
echo "==> Status:"
systemctl --user --no-pager status ydotoold.service | head -6 || true
echo
echo "IMPORTANT: group membership for 'input' takes effect after you LOG OUT and back in"
echo "(or reboot). After that, ydotoold can access /dev/uinput and dictation will type"
echo "directly into the focused window."
echo "PHASE7_SUDO_DONE"
