#!/usr/bin/env bash
# Grupo 1 - Hardening basico para Ubuntu 24.04
# Uso:  chmod +x hardening.sh && sudo ./hardening.sh
# IMPORTANTE: manten abierta tu sesion SSH y prueba el acceso desde otra terminal.
set -euo pipefail

if [ "$(id -u)" -ne 0 ]; then
  echo "Ejecuta con sudo: sudo ./hardening.sh"; exit 1
fi

echo "==> 1/5 Actualizando paquetes"
apt-get update -y && apt-get upgrade -y

echo "==> 2/5 SSH: sin root y solo con llaves"
printf "PermitRootLogin no\nPasswordAuthentication no\n" > /etc/ssh/sshd_config.d/00-hardening.conf
systemctl restart ssh
sshd -T | grep -Ei '^(permitrootlogin|passwordauthentication) '

echo "==> 3/5 Firewall: solo SSH y HTTP"
ufw allow OpenSSH
ufw allow 80/tcp
ufw --force enable
ufw status

echo "==> 4/5 fail2ban contra fuerza bruta"
apt-get install -y fail2ban
systemctl enable --now fail2ban

echo "==> 5/5 Intentos de acceso de bots hasta ahora:"
journalctl -u ssh --no-pager | grep -ci "invalid user" || true

echo "Listo. Recuerda abrir los mismos puertos en el Security Group de AWS."
