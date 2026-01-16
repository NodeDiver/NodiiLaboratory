#!/bin/bash

# --------------------------
# NodiLaboratory - setup-parte1.sh
# Prepara entorno base para correr Bitcoin Core en Ubuntu Server (VM Proxmox)
# --------------------------

set -e

# Mostrar cabecera
clear
echo "\n🧪 Iniciando setup de entorno base para NodiLaboratory (Parte 1)"
echo "------------------------------------------------------------"

# 1. Verificar usuario y permisos
if [ "$EUID" -ne 0 ]; then
  echo "🔴 Este script debe ejecutarse como root o con sudo."
  exit 1
fi

# 2. Mostrar info de sistema
echo "\n📋 Información del sistema:"
hostnamectl | grep "Operating System"
echo "Usuario actual: $(whoami)"
echo "Shell: $SHELL"

# 3. Actualizar sistema
echo "\n🔄 Actualizando sistema..."
apt update && apt full-upgrade -y

# 4. Instalar herramientas útiles
echo "\n🛠️ Instalando herramientas básicas..."
apt install -y curl vim unzip ufw git wget htop iftop ncdu lsof tmux

# 5. Instalar Zsh y plugins opcionales
echo "\n✨ Instalando herramientas opcionales (zsh + plugins)"
apt install -y zsh fzf ripgrep neofetch bat
chsh -s $(which zsh) $SUDO_USER

# 6. Clonar plugins de Zsh
sudo -u $SUDO_USER git clone https://github.com/zsh-users/zsh-autosuggestions /home/$SUDO_USER/.zsh/zsh-autosuggestions
sudo -u $SUDO_USER git clone https://github.com/zsh-users/zsh-syntax-highlighting /home/$SUDO_USER/.zsh/zsh-syntax-highlighting

# 7. Generar .zshrc básico
cat <<EOF > /home/$SUDO_USER/.zshrc
# Plugins
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Prompt
PROMPT='%F{cyan}%n@%m%f:%F{yellow}%~%f$ '

# Historial
HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000

# Alias
alias ll='ls -lah'
alias update='sudo apt update && sudo apt full-upgrade -y'
alias ..='cd ..'

# FZF Ctrl-R
[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh
EOF

chown $SUDO_USER:$SUDO_USER /home/$SUDO_USER/.zshrc

# 8. Verificar sincronización de hora
echo "\n⏱️ Verificando sincronización horaria..."
timedatectl status | grep -q "System clock synchronized: yes" && \
  echo "✅ Hora sincronizada correctamente." || \
  (echo "⚠️ Hora NO sincronizada. Activando..." && timedatectl set-ntp true)

# 9. Verificar volumen lógico y espacio disponible
echo "\n💾 Verificando espacio en disco..."
DISK_SIZE=$(df -h / | awk 'NR==2 {print $2}')
DISK_FREE=$(df -h / | awk 'NR==2 {print $4}')
echo "Tamaño total /: $DISK_SIZE | Disponible: $DISK_FREE"

# 10. Verificar o crear swap si no existe
echo "\n🔍 Verificando swap..."
if swapon --show | grep -q swap; then
  echo "✅ Swap ya está activa."
else
  echo "⚠️ Swap no detectada. Creando swap de 2GB..."
  fallocate -l 2G /swapfile
  chmod 600 /swapfile
  mkswap /swapfile
  swapon /swapfile
  echo '/swapfile none swap sw 0 0' >> /etc/fstab
  echo "✅ Swap creada correctamente."
fi

# Final
echo "\n🎉 Setup completo. Tu entorno está listo para instalar Bitcoin Core."
echo "(Este fue el paso 1 del proceso documentado en NodiLaboratory)"
