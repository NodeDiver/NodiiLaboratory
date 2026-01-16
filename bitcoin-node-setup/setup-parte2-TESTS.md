# 🧪 Parte 2 – Tests y Benchmarks de Bitcoin Core

Esta sección documenta cómo correr los tests automáticos y los benchmarks incluidos en Bitcoin Core, después de haberlo compilado manualmente desde el código fuente.

---

## ✅ Requisitos previos

Antes de continuar, asegurate de haber completado:

- [x] Compilado Bitcoin Core v29.0 desde el código fuente con CMake
- [x] Usado la siguiente configuración en el paso de CMake:

```bash
cmake .. -DBUILD_BITCOIN_WALLET=ON -DENABLE_GUI=OFF -DBUILD_TESTS=ON -DBUILD_BENCH=ON
```

- [x] Haber compilado con:

```bash
make -j$(nproc)
```

---

## 🔍 1. Ejecutar los tests automáticos

### 1.1. Tests unitarios (nivel bajo)

Desde el directorio `build`:

```bash
make check
```

Esto corre los tests de unidad definidos dentro del código fuente (libconsensus, firmas, cadenas, etc.).

> ✅ Si todo está bien, deberías ver una salida con "All tests passed".

---

### 1.2. Functional tests (nivel alto)

Estos tests se ejecutan desde la carpeta `test/functional/` y requieren Python:

```bash
cd ../test/functional
python3 test_runner.py
```

Podés correr un test específico, por ejemplo:

```bash
python3 test_runner.py mempool_limit.py
```

> 📌 Requiere tener instalado Python 3 y el paquete `pyenv` o `virtualenv` si querés aislar el entorno.

---

## 🧪 2. Ejecutar benchmarks de rendimiento

Bitcoin Core incluye pruebas de rendimiento para distintas operaciones crípticas.

Desde el directorio `build/src`:

```bash
cd ~/src/bitcoin/build/src
./bench/bench_bitcoin
```

Esto ejecuta todos los benchmarks disponibles.

Podés filtrar por tipo:

```bash
./bench/bench_bitcoin --filter=verify
```

Ejemplos de benchmarks:
- Firma y verificación de transacciones
- Verificación de firmas ECDSA y Schnorr
- Serialización y parsing
- Validación de bloques

---

## 📄 3. Resultados

Podés guardar los resultados en un archivo para futura comparación:

```bash
./bench/bench_bitcoin > ~/bench_results.txt
```

Luego podés analizar o comparar con otras máquinas/nodos para evaluar rendimiento.

---

## 🧠 4. Consejos

- Ejecutar los tests una vez después de compilar ayuda a verificar integridad del build
- Los benchmarks pueden tardar varios minutos dependiendo del hardware
- Si algo falla, revisar `test/config.ini`, o correr los tests uno por uno

---

## 🧹 5. Limpieza (opcional)

Si querés liberar espacio, podés borrar artefactos temporales:

```bash
make clean
```

Esto no borra el binario instalado en `/usr/local/bin`, solo el contenido de `build/`

---

¡Con esto completás la Parte 2 de tests y benchmarks de tu nodo Bitcoin Core! 🚀
