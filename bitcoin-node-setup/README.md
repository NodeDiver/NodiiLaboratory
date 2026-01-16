# 🧪 NodiiLaboratory

Este repositorio documenta mi proceso de aprendizaje y experimentación al montar un nodo completo de Bitcoin y herramientas relacionadas.  
La idea es que cualquiera pueda seguir estos pasos para reproducirlo de forma ordenada, modular y entendible.

---

## 🧱 PARTE 1 – Preparar el entorno (Ubuntu Server en una VM dentro de Proxmox)

### 🖥️ Crear la VM en Proxmox

Configurá una nueva VM en Proxmox con estas características:

- **Nombre**: `100 (mainnet)`
- **Sistema operativo**: Ubuntu Server (instalación por defecto)
- **RAM**: 8 GB
- **CPU**: 1 socket, 4 núcleos
- **Disco**: 1 TB (en un SSD separado del sistema Proxmox)
- **Activá**: QEMU Guest Agent y VirtIO para mejor rendimiento

---

### 🔌 Dentro de la VM: habilitar el QEMU Guest Agent

Esto permite que desde la interfaz de Proxmox puedas ver la IP interna de la VM, hacer apagados limpios y tener mejor integración.

```bash
sudo apt update
sudo apt install qemu-guest-agent -y
sudo systemctl enable qemu-guest-agent
sudo systemctl start qemu-guest-agent
```

📍 Después de esto, podés ver la IP de la VM desde la sección "Summary" en la interfaz web de Proxmox.

---

### 🔐 Acceso por SSH desde tu terminal

Desde la consola de la VM (en Proxmox), ejecutá:

```bash
sudo apt install openssh-server -y
```

Luego, desde tu computadora (Linux/macOS/WSL/Windows Terminal):

```bash
ssh tu-usuario@<ip-de-la-vm>
```

📌 Así podés dejar de usar la consola web de Proxmox y trabajar cómodo desde tu propio entorno ✨

---

### ⚙️ Actualizar el sistema e instalar herramientas básicas

```bash
sudo apt update && sudo apt full-upgrade -y

sudo apt install curl vim unzip ufw git wget \
  htop iftop ncdu lsof tmux -y
```

🔸 Herramientas como `htop`, `ncdu` o `iftop` te permiten ver en tiempo real procesos, uso de disco y red. Muy útiles cuando empieces a correr cosas más pesadas como Bitcoin Core.

Extras opcionales (pero muy recomendados):

```bash
sudo apt install zsh fzf ripgrep neofetch bat -y
```

---

### 🧠 Configurar Zsh con plugins útiles

```bash
chsh -s $(which zsh)   # Convertir Zsh en la shell por defecto

# Clonar los plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting
```

Crear el archivo `.zshrc`:

```bash
nano ~/.zshrc
```

Pegar:

```zsh
# Plugins
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Prompt minimalista
PROMPT='%F{cyan}%n@%m%f:%F{yellow}%~%f$ '

# Historial
HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000

# Alias útiles
alias ll='ls -lah'
alias update='sudo apt update && sudo apt full-upgrade -y'
alias ..='cd ..'

# Búsqueda fuzzy en el historial (Ctrl-R)
[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh
```

Aplicar los cambios:

```bash
source ~/.zshrc
```

🔹 Esto te va a ayudar a escribir menos, cometer menos errores, y encontrar comandos que ya usaste.

---

### ⏱️ Verificar que el sistema tenga la hora sincronizada

Es importante para que Bitcoin Core funcione bien (necesita estar en sincronía con el tiempo de la red).

```bash
timedatectl status
```

Si dice que no está sincronizado:

```bash
sudo timedatectl set-ntp true
```

---

### 💾 Verificar y expandir el espacio en disco

Chequeá cuánto espacio tenés realmente en la raíz (`/`):

```bash
df -h
```

Si ves que solo tenés ~100 GB aunque asignaste 1 TB, podés verificar con:

```bash
lsblk
```

Si el espacio está ahí pero no está asignado, expandí el volumen lógico:

```bash
sudo lvextend -l +100%FREE /dev/ubuntu-vg/ubuntu-lv
sudo resize2fs /dev/ubuntu-vg/ubuntu-lv
```

Luego volvé a verificar:

```bash
df -h
lsblk
```

📌 Esto es común en instalaciones con LVM: el espacio está asignado a la VM, pero no al sistema de archivos aún.

---

### 💡 Activar memoria swap (buena práctica)

Chequeá si ya tenés swap:

```bash
swapon --show
```

Si no tenés, podés crear un archivo de swap de 2 GB:

```bash
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
```

🔹 Esto le da un "colchón" a tu sistema por si alguna vez se queda corto de RAM. No reemplaza memoria real, pero puede evitar cuelgues o errores cuando estás al límite.

### 🛠️ Ejecutar setup de entorno (Parte 1)

```bash
bash <(curl -s https://raw.githubusercontent.com/NodeDiver/NodiLaboratory/main/setup-parte1.sh)
```
---

## 🧱 PARTE 2 – Instalar Bitcoin Core

🚧 *Próximamente…*

En esta sección vamos a descargar el binario oficial de Bitcoin Core, verificar su firma, configurarlo como servicio y dejarlo corriendo como nodo completo.

---

## 🐍 PARTE 3 – Instalar Python y scripts relacionados

🚧 *Próximamente…*

Acá vamos a instalar Python, preparar un entorno simple para ejecutar scripts útiles (como consultas RPC, monitoreo del nodo, dashboards o herramientas educativas para visualizar cómo funciona Bitcoin).

---

📌 Si esta guía te está sirviendo, podés forkeártela, mejorarla, o sugerir cambios vía pull request.  
El objetivo es compartir conocimiento útil, claro y replicable 🧡
