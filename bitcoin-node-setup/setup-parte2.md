## 🧱 PARTE 2 – Instalar Bitcoin Core desde código fuente (compilación manual)

---

### 🔹 1. Preparar el entorno de compilación

Antes de compilar, necesitamos asegurarnos de que el sistema esté actualizado y tenga herramientas de desarrollo básicas.

```bash
sudo apt update && sudo apt full-upgrade -y
sudo apt install -y build-essential libtool autotools-dev automake pkg-config bsdmainutils curl git wget
```

---

### 🔹 2. Instalar dependencias requeridas por Bitcoin Core

Estas librerías son necesarias para que el código fuente compile correctamente y funcione de manera estable. Algunas son para manejo de red, otras para la interfaz RPC, compresión, etc.

```bash
sudo apt install -y libevent-dev libboost-system-dev libboost-filesystem-dev \
libboost-chrono-dev libboost-test-dev libboost-thread-dev libminiupnpc-dev \
libzmq3-dev libssl-dev libprotobuf-dev protobuf-compiler libqrencode-dev \
libsqlite3-dev libnatpmp-dev
```

---
### 🔹 3. Clonar el código fuente oficial (versión v29.0)

Vamos a clonar el repositorio de Bitcoin Core desde GitHub y posicionarnos en la versión estable más reciente: `v29.0`.

```bash
mkdir -p ~/src && cd ~/src
git clone https://github.com/bitcoin/bitcoin.git
cd bitcoin
git checkout v29.0
```

---

### 🔹 4. Configurar el entorno de compilación (con CMake)

Desde la versión `v29.0`, Bitcoin Core utiliza **CMake** como sistema de compilación.  
Ya no se usa `./configure` ni `autogen.sh`.

#### 🛠️ 4.1 Instalar las dependencias necesarias

```bash
sudo apt update
sudo apt install -y cmake build-essential libevent-dev libboost-system-dev \
libboost-filesystem-dev libboost-chrono-dev libboost-test-dev libboost-thread-dev \
libminiupnpc-dev libzmq3-dev libssl-dev libprotobuf-dev protobuf-compiler \
libqrencode-dev libsqlite3-dev libnatpmp-dev libtool pkg-config
```

#### 📁 4.2 Crear carpeta de compilación

```bash
mkdir -p build && cd build
```

#### ⚙️ 4.3 Configurar CMake

```bash
cmake .. -DBUILD_BITCOIN_WALLET=ON -DENABLE_GUI=OFF -DBUILD_TESTS=ON -DBUILD_BENCH=ON
```

📌 Explicación rápida de cada flag:

| Flag                      | Qué hace                                              |
|---------------------------|--------------------------------------------------------|
| `BUILD_BITCOIN_WALLET=ON` | Activa la funcionalidad de monedero local             |
| `ENABLE_GUI=OFF`          | Desactiva la interfaz gráfica (ideal para servidores) |
| `BUILD_TESTS=ON`          | Compila los tests automáticos (útil para dev o debug) |
| `BUILD_BENCH=ON`          | Compila los benchmarks para evaluar rendimiento       |


---
### 🔹 5. Compilar Bitcoin Core

Ahora que el entorno está configurado correctamente con CMake, podés compilar Bitcoin Core. Este proceso puede tardar varios minutos dependiendo de la potencia del hardware.

```bash
make -j$(nproc)
```

📌 `-j$(nproc)` usa todos los núcleos disponibles del procesador para compilar más rápido.

---

### 🔹 6. Instalar los binarios

Una vez finalizada la compilación, instalamos los ejecutables (`bitcoind`, `bitcoin-cli`, etc.) en el sistema:

```bash
sudo make install
```

Esto los coloca en `/usr/local/bin`, lo que te permite ejecutarlos desde cualquier lugar del sistema sin necesidad de rutas.

---

### 🔹 7. Verificar instalación

Podés confirmar que Bitcoin Core está correctamente instalado y disponible:

```bash
bitcoind --version
bitcoin-cli --version
```

📌 Si estos comandos responden correctamente con la versión 29.0, ¡estás listo para comenzar a configurar tu nodo!

---
### 🔹 8. Crear la configuración inicial del nodo

Bitcoin Core guarda su configuración en `~/.bitcoin/bitcoin.conf`. Vamos a crearlo con parámetros básicos para que el nodo pueda funcionar de forma completa.

```bash
mkdir -p ~/.bitcoin
nano ~/.bitcoin/bitcoin.conf
```

Sugerencia de contenido mínimo:

```ini
server=1
txindex=1
rpcuser=admin
rpcpassword=una_clave_segura_aca
```

📌 Qué hace cada línea:
- `server=1`: permite que `bitcoind` acepte conexiones RPC
- `txindex=1`: permite consultar cualquier transacción, incluso fuera de tu wallet
- `rpcuser` / `rpcpassword`: necesarios para conectarte con `bitcoin-cli` o scripts externos

🔐 Recomendación: no uses contraseñas simples. Podés generar una segura con:

```bash
openssl rand -hex 32
```

---

### 🔹 9. Iniciar el nodo por primera vez

Ya con todo configurado, podemos iniciar el nodo en segundo plano (modo daemon):

```bash
bitcoind -daemon
```

Luego, verificá que está corriendo correctamente:

```bash
bitcoin-cli getblockchaininfo
```

📌 Si ves información sobre el progreso de la sincronización, el nodo está funcionando 🚀  
La blockchain comenzará a descargarse. Esto puede tardar días la primera vez, dependiendo de tu conexión y hardware.

---

> 💡 Tip: para detener el nodo de forma segura, usá:
> ```bash
> bitcoin-cli stop
> ```


---

### 🔹 10. (Opcional) Crear servicio systemd

Si querés que el nodo se inicie automáticamente al encender la máquina:

```bash
sudo nano /etc/systemd/system/bitcoind.service
```

Contenido:

```ini
[Unit]
Description=Bitcoin Daemon
After=network.target

[Service]
ExecStart=/usr/local/bin/bitcoind -daemon -conf=/home/tu_usuario/.bitcoin/bitcoin.conf -datadir=/home/tu_usuario/.bitcoin
ExecStop=/usr/local/bin/bitcoin-cli stop
Restart=always
User=tu_usuario

[Install]
WantedBy=multi-user.target
```

Luego activás el servicio:

```bash
sudo systemctl daemon-reexec
sudo systemctl enable bitcoind
sudo systemctl start bitcoind
```

---

¡Listo! Ahora tenés Bitcoin Core instalado, compilado desde cero, corriendo como nodo completo y 100% bajo tu control 🧡
