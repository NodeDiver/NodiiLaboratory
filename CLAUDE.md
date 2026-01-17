# CLAUDE.md - NodiiLaboratory

## Proyecto

Laboratorio de aprendizaje práctico sobre Bitcoin, Lightning Network y Nostr.
Repositorio educativo con múltiples cursos autocontenidos, hosteado en GitHub Pages.

**Autor**: NodeDiver
**Licencia**: MIT
**Idiomas**: Español (principal) + Inglés (futuro)
**Audiencia**: Devs sin experiencia previa en Bitcoin/Lightning/Nostr

---

## Stack Técnico

| Componente | Tecnología |
|------------|------------|
| Sistema base | Ubuntu Server (VM Proxmox) |
| Bitcoin | Bitcoin Core v29.0+ |
| Scripting | Bash, Python 3.10+ |
| Protocolos | Bitcoin, Lightning, Nostr |
| Cursos interactivos | Slidev (Vue 3) - futuro |
| Editor código | Monaco (built-in) - futuro |
| Ejecución código | Monaco Runner + Sandpack - futuro |
| Hosting | GitHub Pages |

---

## Estructura del Repositorio

```
NodiiLaboratory/
├── CLAUDE.md                        # Este archivo
├── README.md                        # Hub principal del laboratorio
│
├── bitcoin-node-setup/              # Curso: Nodo Bitcoin desde cero
│   ├── README.md                    # Guía completa
│   ├── setup-parte1.sh              # Script automatizado
│   ├── setup-parte2.md              # Instalación Bitcoin Core
│   └── setup-parte2-TESTS.md        # Tests y benchmarks
│
├── nostr-wallet-connect/            # Curso: NWC (Coming Soon)
│   └── README.md
│
└── ai-agents-bitcoin/               # Curso: IA + Bitcoin (Coming Soon)
    └── README.md
```

---

## Estructura Didáctica por Capítulo (Metodología ACI)

Para cursos interactivos futuros, cada capítulo dura **75 minutos**. Estructura:

| Bloque | Posición | Duración | Contenido |
|--------|----------|----------|-----------|
| **Apertura** | 0-5% | ~4 min | Título, objetivo, "qué vamos a aprender" |
| **Índice** | 5-8% | ~2 min | Mapa del capítulo |
| **Contenido Principal** | 8-33% | ~19 min | Teoría + ejemplos + código |
| **Actividad Light** | 33% | ~5 min | Quiz rápido o pregunta reflexiva |
| **Contenido Intermedio** | 33-66% | ~25 min | Conceptos más profundos + demos |
| **Actividad Heavy** | 66% | ~10 min | Ejercicio práctico hands-on |
| **Contenido Final** | 66-90% | ~18 min | Integración y casos de uso |
| **Cierre** | 90-95% | ~4 min | Resumen: qué aprendimos |
| **Auto-evaluación** | 95-100% | ~5 min | Quiz final |

### Reglas de Contenido

1. **Máximo 1 concepto por slide** (working memory = 3-5 items)
2. **Quiz cada 5-6 slides** de contenido
3. **Código ejecutable** siempre que sea posible
4. **Citar fuentes** en slides con información técnica

---

## Reglas de Documentación

- Español (Argentina) para toda la documentación
- Explicaciones claras para principiantes
- Incluir comandos copy-paste listos para ejecutar
- Verificar cada paso antes de documentar
- Emojis permitidos en documentación (es educativo)
- Documentar errores comunes y sus soluciones

---

## Estilo de Código

### Bash Scripts
```bash
#!/bin/bash
set -e  # Fallar temprano

# Variables en MAYÚSCULAS para constantes
BITCOIN_VERSION="29.0"

# Comentarios explicativos en español
```

### Python
```python
# Python 3.10+
# Type hints siempre
# Docstrings en español

def get_block_height(rpc_url: str) -> int:
    """Obtiene la altura actual del blockchain."""
    pass
```

---

## Git

### Commits
- Idioma: Inglés
- Formato: Conventional commits (`feat`, `fix`, `docs`, `refactor`, `chore`)
- Una feature/fix por commit
- Máximo 140 caracteres en el título

### Branching
- `main`: Branch principal (producción)
- Feature branches: `feat/nombre-descriptivo`
- Fix branches: `fix/descripcion-del-bug`

### Ejemplo
```bash
git commit -m "feat: add Bitcoin Core installation script"
git commit -m "fix: correct swap file permissions"
git commit -m "docs: update README with troubleshooting section"
```

---

## Tooling

| Herramienta | Versión | Uso |
|-------------|---------|-----|
| Node.js | 20+ | Para cursos Slidev |
| Python | 3.10+ | Scripts de automatización |
| pnpm | latest | Package manager (monorepo) |

### Archivos de configuración recomendados
```
.nvmrc          # Versión de Node
.python-version # Versión de Python (pyenv)
.editorconfig   # Consistencia de formato
```

---

## Cursos

### 1. bitcoin-node-setup (Activo)
- **Objetivo**: Montar un nodo Bitcoin completo desde cero
- **Prerrequisitos**: Conocimientos básicos de Linux
- **Partes**: VM Setup → Bitcoin Core → Python scripts

### 2. nostr-wallet-connect (Coming Soon)
- **Objetivo**: Integrar pagos Lightning en apps usando NWC
- **Prerrequisitos**: JavaScript básico, conceptos de Bitcoin
- **Stack**: Alby SDK, Nostr

### 3. ai-agents-bitcoin (Coming Soon)
- **Objetivo**: Agentes IA que interactúan con Bitcoin/Lightning
- **Prerrequisitos**: Experiencia con LLMs, TypeScript
- **Stack**: Claude/LangChain, Lightning

---

## Troubleshooting

### Errores comunes

| Error | Causa | Solución |
|-------|-------|----------|
| `Permission denied` | Falta sudo o permisos | `chmod +x script.sh` o usar `sudo` |
| Disco lleno | LVM no expandido | `sudo lvextend -l +100%FREE /dev/ubuntu-vg/ubuntu-lv` |
| Sin conexión a peers | Firewall bloqueando | Abrir puerto 8333 |

---

## Notas para Claude

- **Priorizar claridad** sobre optimización (es educativo)
- **Scripts idempotentes** cuando sea posible
- **Verificar** que comandos funcionen antes de documentar
- **No asumir** conocimiento previo del lector
- **Incluir** sección de troubleshooting en cada guía
- Los cursos futuros usarán Slidev con la metodología ACI
