# NodiiLaboratory - Configuración Claude Code

## Contexto del Proyecto

Laboratorio de aprendizaje práctico sobre Bitcoin, Lightning Network y Nostr.
Repositorio educativo con múltiples cursos autocontenidos.

## Stack Técnico

- **Sistema**: Ubuntu Server (en VM Proxmox)
- **Bitcoin**: Bitcoin Core v29.0+
- **Scripting**: Bash, Python
- **Protocolos**: Bitcoin, Lightning, Nostr

## Estructura

```
NodiiLaboratory/
├── bitcoin-node-setup/      # Nodo Bitcoin desde cero
├── nostr-wallet-connect/    # NWC (Coming Soon)
└── ai-agents-bitcoin/       # IA + Bitcoin (Coming Soon)
```

## Reglas de Documentación

- Español (Argentina) para toda la documentación
- Explicaciones claras para principiantes
- Incluir comandos copy-paste listos para ejecutar
- Verificar cada paso antes de documentar
- Emojis permitidos en documentación (es educativo)

## Estilo de Código

### Bash Scripts
- Shebang: `#!/bin/bash`
- Usar `set -e` para fallar temprano
- Comentarios explicativos en español
- Variables en MAYÚSCULAS para constantes

### Python (cuando aplique)
- Python 3.10+
- Type hints siempre
- Docstrings en español

## Git

- Commits en inglés, formato conventional commits
- Branch principal: `main`
- Una feature/fix por commit

## Notas

- Este es un proyecto educativo, priorizar claridad sobre optimización
- Los scripts deben ser idempotentes cuando sea posible
- Documentar errores comunes y sus soluciones
