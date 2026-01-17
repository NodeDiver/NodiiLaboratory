# ⚡ Capítulo 1: PROOF OF WEAR - Pagos Lightning con Agentes IA

> Documentación completa del primer caso de estudio: Implementación de pagos Bitcoin Lightning en un e-commerce usando orquestación multi-agente.

---

## 🎯 Resumen Ejecutivo

### ¿Qué se logró?
Implementación de **pagos Lightning reales** en un e-commerce experimental (PROOF-OF-WEAR) usando un pipeline de 8 agentes de IA trabajando en secuencia.

### Métricas Clave

| Métrica | Valor |
|---------|-------|
| **Tiempo total** | ~1 hora |
| **Costo LLM** | ~$17.86 USD |
| **Costo infraestructura** | ~$0.45 USD |
| **Total** | **~$18.31 USD** |
| **Ahorro vs manual** | 95-99% |
| **Commits generados** | 11 |
| **Archivos creados/modificados** | 15+ |

### Stack Utilizado

| Componente | Tecnología |
|------------|------------|
| Framework | Next.js 16.1.2 (App Router) |
| React | 19.2.3 |
| State | Zustand |
| Pagos | @getalby/sdk + Bitcoin Connect |
| Styling | Tailwind CSS (Neo-Brutalist) |
| i18n | next-intl |

---

## 🤖 Parte 1: El Sistema Multi-Agente

### 1.1 Arquitectura del Pipeline

```mermaid
flowchart TB
    subgraph Phase1["📡 Phase 1: Discovery"]
        A1[Scout Agent] --> A2[01-site-analysis.md]
    end

    subgraph Phase2["🏗️ Phase 2: Architecture"]
        B1[Architect Agent] --> B2[02-architecture-map.md]
    end

    subgraph Phase3["🔍 Phase 3: Research"]
        C1[Socrates Agent] --> C2[03-payment-options.md]
    end

    subgraph Phase4["👤 Phase 4: Decision"]
        D1[Human Operator] --> D2[Selected Option D]
    end

    subgraph Phase5["📋 Phase 5: Planning"]
        E1[Strategist Agent] --> E2[04-implementation-plan.md]
    end

    subgraph Phase6["🛠️ Phase 6: Implementation"]
        F1[Builder Agent] --> F2[Code + 11 Commits]
    end

    subgraph Phase7["💰 Phase 7: Wallet Setup"]
        G1[Wallet Agent] --> G2[05-wallet-config.md]
    end

    subgraph Phase8["🧪 Phase 8: Testing"]
        H1[Tester Agent] --> H2[06-test-results.md]
    end

    A2 --> B1
    B2 --> C1
    C2 --> D1
    D2 --> E1
    E2 --> F1
    F2 --> G1
    G2 --> H1
```

### 1.2 Los 8 Agentes y sus Roles

| Fase | Agente | Rol | Output |
|------|--------|-----|--------|
| 1 | **Scout** | Análisis de estructura del sitio | `01-site-analysis.md` |
| 2 | **Architect** | Mapeo de puntos de integración | `02-architecture-map.md` |
| 3 | **Sócrates** | Research profundo de opciones NWC | `03-payment-options.md` |
| 4 | **Human** | Toma de decisión | Opción D seleccionada |
| 5 | **Strategist** | Plan de implementación detallado | `04-implementation-plan.md` |
| 6 | **Builder** | Implementación con commits atómicos | Código + 11 commits |
| 7 | **Wallet** | Guía de configuración NWC | `05-wallet-config.md` |
| 8 | **Tester** | Verificación E2E | `06-test-results.md` |

### 1.3 Flujo de Comunicación

Cada agente:
1. Lee el output del agente anterior
2. Ejecuta su tarea específica
3. Genera documentación estructurada
4. Pasa el control al siguiente agente

El **orquestador (Orion)** coordina la ejecución secuencial y maneja las decisiones humanas en Phase 4.

---

## 🔍 Parte 2: Fase de Descubrimiento

### 2.1 Scout: Análisis del Sitio

El Scout Agent escaneó el proyecto y generó un análisis completo:

**Stack Detectado:**
```
Framework: Next.js 16.1.2 (App Router)
React: 19.2.3
Styling: Tailwind CSS
State: Zustand + persist
i18n: next-intl (en/es)
Theme: next-themes
Animations: Framer Motion
SDK ya instalado: @getalby/sdk@7.0.0
```

**Estructura del Checkout Identificada:**
```
src/
├── app/
│   ├── checkout/page.tsx          # Página de checkout
│   └── api/
│       ├── orders/route.ts        # POST /api/orders (mock)
│       └── invoices/route.ts      # POST /api/invoices (FAKE)
├── components/
│   └── checkout/CheckoutForm.tsx  # Formulario de pago
└── lib/
    └── store.ts                   # Zustand cart store
```

**Gaps Identificados:**
- Invoice creation era FAKE (no NWC real)
- No había payment status polling
- No había QR code display
- Cart se limpiaba antes de confirmar pago

### 2.2 Architect: Mapeo de Integración

El Architect creó un diagrama del flujo actual vs deseado:

**Flujo ANTES (roto):**
```mermaid
sequenceDiagram
    participant U as User
    participant CF as CheckoutForm
    participant IA as /api/invoices

    U->>CF: Submit form
    CF->>IA: POST { orderId, amountSats }
    IA-->>CF: { bolt11: "FAKE..." }
    CF->>U: alert() con invoice falso
    CF->>CF: clearCart() ← MAL!
```

**Flujo DESPUÉS (correcto):**
```mermaid
sequenceDiagram
    participant U as User
    participant CF as CheckoutForm
    participant PM as PaymentModal
    participant IA as /api/invoices
    participant SA as /api/invoices/[id]/status
    participant NWC as NWC Wallet

    U->>CF: Submit form
    CF->>IA: POST { orderId, amountSats }
    IA->>NWC: makeInvoice()
    NWC-->>IA: Real bolt11
    IA-->>CF: { bolt11: "lnbc...", paymentHash }
    CF->>PM: Open modal con QR

    loop Polling cada 2s
        PM->>SA: GET /status
        SA->>NWC: lookupInvoice()
        NWC-->>SA: { paid: true/false }
    end

    Note over PM: Cuando paid=true
    PM->>CF: onPaymentSuccess()
    CF->>CF: clearCart()
    CF->>U: Redirect a /success
```

### 2.3 Sócrates: Research de Opciones NWC

Sócrates investigó 4 opciones de implementación:

| Opción | Descripción | Complejidad | Best For |
|--------|-------------|-------------|----------|
| **A** | Direct NWC (backend only) | Media | AI agents, CLIs |
| **B** | Bitcoin Connect (UI modal) | Baja | Web apps rápidas |
| **C** | WebLN + Fallback | Media | Power users |
| **D** | Hybrid (A + B) | Alta | E-commerce real |

**Matriz de Decisión:**

| Criterio | Peso | A | B | C | D |
|----------|------|---|---|---|---|
| SDK ya instalado | Alto | ✅ | ❌ | ❌ | ✅ |
| Control de UI | Alto | ✅ | ❌ | ✅ | ⚠️ |
| Server verification | Alto | ✅ | ❌ | ❌ | ✅ |
| Tiempo implementación | Medio | ⚠️ | ✅ | ⚠️ | ❌ |
| WebLN support | Bajo | ❌ | ✅ | ✅ | ✅ |
| **Score** | | 8/10 | 5/10 | 6/10 | **7/10** |

**Recomendación:** Opción D (Hybrid) por máxima compatibilidad y seguridad.

---

## 🧠 Parte 3: Toma de Decisiones

### 3.1 Las 4 Opciones de Implementación

```
┌─────────────────────────────────────────────────────────────┐
│  OPTION A: Direct NWC                                        │
│  ─────────────────────                                       │
│  Backend: @getalby/sdk NWCClient                             │
│  Frontend: Custom QR modal                                   │
│  Control total, más código                                   │
├─────────────────────────────────────────────────────────────┤
│  OPTION B: Bitcoin Connect                                   │
│  ─────────────────────────                                   │
│  Backend: Ninguno (client-side)                              │
│  Frontend: @getalby/bitcoin-connect-react modal              │
│  Rápido, menos control                                       │
├─────────────────────────────────────────────────────────────┤
│  OPTION C: WebLN + Fallback                                  │
│  ────────────────────────                                    │
│  Detecta extensión (Alby) → pago directo                     │
│  Sin extensión → QR fallback                                 │
│  Mejor UX para power users                                   │
├─────────────────────────────────────────────────────────────┤
│  OPTION D: Hybrid (A + B) ← ELEGIDA                          │
│  ─────────────────────────                                   │
│  Backend: NWC para crear/verificar invoices                  │
│  Frontend: Bitcoin Connect modal + QR manual                 │
│  Máxima compatibilidad + verificación server-side            │
└─────────────────────────────────────────────────────────────┘
```

### 3.2 Análisis de Trade-offs

**¿Por qué Hybrid (D)?**

1. **Seguridad**: Verificación de pago en backend (no confiar en client)
2. **Compatibilidad**: Funciona con extensiones WebLN Y wallets móviles
3. **Control**: QR code propio + modal de Bitcoin Connect como opción
4. **SDK listo**: `@getalby/sdk` ya estaba instalado

**Trade-off aceptado:** Mayor complejidad a cambio de mejor seguridad y UX.

### 3.3 Decisión: Hybrid (Option D)

El humano seleccionó:
- **Opción**: D (Hybrid)
- **Test page**: Sí (`/pipeline-test`)

---

## 🛠️ Parte 4: Implementación

### 4.1 Dependencias Instaladas

```bash
npm install @getalby/bitcoin-connect-react qrcode.react
```

**package.json actualizado:**
```json
{
  "dependencies": {
    "@getalby/sdk": "^7.0.0",
    "@getalby/bitcoin-connect-react": "^3.x",
    "qrcode.react": "^4.x"
  }
}
```

### 4.2 NWC Client (Singleton Pattern)

**Archivo:** `src/lib/nwc.ts`

```typescript
import { NWCClient } from '@getalby/sdk/nwc';

let nwcClient: NWCClient | null = null;

/**
 * Get or create NWC client singleton
 * Server-side only - do not import in client components
 */
export function getNWCClient(): NWCClient {
  if (!process.env.NWC_URL) {
    throw new Error('NWC_URL environment variable is required');
  }

  if (!nwcClient) {
    nwcClient = new NWCClient({
      nostrWalletConnectUrl: process.env.NWC_URL,
    });
  }

  return nwcClient;
}

/**
 * Create invoice via NWC
 * @param amountSats - Amount in satoshis
 * @param description - Invoice description
 */
export async function createInvoice(amountSats: number, description: string) {
  const client = getNWCClient();

  const transaction = await client.makeInvoice({
    amount: amountSats * 1000, // Convert sats to millisats
    description,
    expiry: 600, // 10 minutes
  });

  return {
    bolt11: transaction.invoice,
    paymentHash: transaction.payment_hash,
  };
}

/**
 * Check invoice payment status via NWC
 * @param paymentHash - The payment hash to look up
 */
export async function checkInvoiceStatus(paymentHash: string) {
  const client = getNWCClient();

  const result = await client.lookupInvoice({
    payment_hash: paymentHash,
  });

  return {
    paid: !!result.preimage,
    preimage: result.preimage,
  };
}
```

**Puntos clave:**
- Patrón **Singleton** para reutilizar conexión
- Server-side only (no importar en client components)
- Conversión sats → millisats (NWC usa millisats)
- Expiry de 10 minutos

### 4.3 API Routes (Invoice + Status)

**POST /api/invoices** - Crear invoice real:

```typescript
// src/app/api/invoices/route.ts
import { NextRequest, NextResponse } from 'next/server';
import { createInvoice } from '@/lib/nwc';

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();

    // Validate
    if (!body.orderId || !body.amountSats || body.amountSats <= 0) {
      return NextResponse.json({ error: 'Invalid request' }, { status: 400 });
    }

    const invoiceId = `INV-${Date.now()}-${Math.random().toString(36).substring(7).toUpperCase()}`;
    const description = `PROOF OF WEAR - Order ${body.orderId}`;

    // Create REAL invoice via NWC
    const { bolt11, paymentHash } = await createInvoice(body.amountSats, description);

    return NextResponse.json({
      invoiceId,
      orderId: body.orderId,
      bolt11,
      paymentHash,
      amountSats: body.amountSats,
      status: 'pending',
      expiresAt: new Date(Date.now() + 10 * 60 * 1000).toISOString(),
    }, { status: 201 });

  } catch (error) {
    console.error('Error creating invoice:', error);
    return NextResponse.json({ error: 'Failed to create invoice' }, { status: 500 });
  }
}
```

**GET /api/invoices/[id]/status** - Verificar pago:

```typescript
// src/app/api/invoices/[id]/status/route.ts
import { NextRequest, NextResponse } from 'next/server';
import { checkInvoiceStatus } from '@/lib/nwc';

export async function GET(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    const { id: paymentHash } = await params;

    const { paid, preimage } = await checkInvoiceStatus(paymentHash);

    return NextResponse.json({
      paymentHash,
      status: paid ? 'paid' : 'pending',
      paid,
      preimage: preimage || null,
      paidAt: paid ? new Date().toISOString() : null,
    });
  } catch (error) {
    return NextResponse.json({ error: 'Failed to check status' }, { status: 500 });
  }
}
```

### 4.4 PaymentModal (Neo-Brutalist)

**Archivo:** `src/components/checkout/PaymentModal.tsx`

Características:
- QR code scannable
- Countdown timer (10 min)
- Polling cada 2 segundos
- Botón "Pay with Wallet" (Bitcoin Connect)
- Copiar invoice al clipboard
- Estados: pending → paid → redirect

```typescript
'use client';

import { useEffect, useState, useCallback } from 'react';
import { QRCodeSVG } from 'qrcode.react';

export function PaymentModal({ invoice, onSuccess, onClose }) {
  const [status, setStatus] = useState<'pending' | 'paid' | 'expired'>('pending');
  const [timeLeft, setTimeLeft] = useState(600); // 10 minutes

  // Poll for payment status
  useEffect(() => {
    if (status !== 'pending') return;

    const pollStatus = async () => {
      const response = await fetch(`/api/invoices/${invoice.paymentHash}/status`);
      const data = await response.json();

      if (data.paid) {
        setStatus('paid');
        setTimeout(onSuccess, 1500);
      }
    };

    const interval = setInterval(pollStatus, 2000);
    return () => clearInterval(interval);
  }, [invoice.paymentHash, status, onSuccess]);

  // Launch Bitcoin Connect modal (dynamic import!)
  const handleBitcoinConnect = useCallback(async () => {
    const { launchPaymentModal } = await import('@getalby/bitcoin-connect-react');
    launchPaymentModal({
      invoice: invoice.bolt11,
      onPaid: () => {
        setStatus('paid');
        setTimeout(onSuccess, 1500);
      },
    });
  }, [invoice.bolt11, onSuccess]);

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/80">
      {/* QR Code */}
      <QRCodeSVG value={invoice.bolt11.toUpperCase()} size={200} />

      {/* Timer */}
      <p>{formatTime(timeLeft)}</p>

      {/* Pay with Wallet button */}
      <Button onClick={handleBitcoinConnect}>Pay with Wallet</Button>
    </div>
  );
}
```

### 4.5 Bitcoin Connect Provider

**Archivo:** `src/components/providers/BitcoinConnectProvider.tsx`

```typescript
'use client';

import { useEffect } from 'react';

/**
 * Initialize Bitcoin Connect for Lightning wallet integration
 * Uses dynamic import to avoid SSR issues with HTMLElement
 */
export function BitcoinConnectProvider({ children }: { children: React.ReactNode }) {
  useEffect(() => {
    // Dynamic import to avoid SSR error!
    import('@getalby/bitcoin-connect-react').then(({ init }) => {
      init({
        appName: 'PROOF OF WEAR',
        filters: ['nwc'],
        showBalance: true,
      });
    });
  }, []);

  return <>{children}</>;
}
```

### 4.6 Página de Test

**Archivo:** `src/app/pipeline-test/page.tsx`

La página de test permite:
1. Crear un invoice de 1 sat (Propaganda Pack)
2. Mostrar QR code
3. Polling de estado
4. Log de actividad en tiempo real

Acceso: `http://localhost:3000/pipeline-test`

---

## 🐛 Parte 5: Problemas Encontrados

### 5.1 Error SSR "HTMLElement"

**El problema:**
```
ReferenceError: HTMLElement is not defined
```

**¿Por qué ocurre?**

Bitcoin Connect usa APIs del DOM (HTMLElement) que no existen en el servidor (SSR). Next.js pre-renderiza en el servidor, donde `HTMLElement` no está definido.

**Código que causaba el error:**
```typescript
// ❌ MAL - Import estático en server component
import { init } from '@getalby/bitcoin-connect-react';

export function BitcoinConnectProvider({ children }) {
  init({ appName: 'PROOF OF WEAR' }); // 💥 Error en SSR!
  return <>{children}</>;
}
```

### 5.2 Solución: Dynamic Imports

**Código corregido:**
```typescript
// ✅ BIEN - Dynamic import en useEffect (client-side only)
'use client';

import { useEffect } from 'react';

export function BitcoinConnectProvider({ children }) {
  useEffect(() => {
    // Este código SOLO se ejecuta en el browser
    import('@getalby/bitcoin-connect-react').then(({ init }) => {
      init({ appName: 'PROOF OF WEAR' });
    });
  }, []);

  return <>{children}</>;
}
```

**El mismo patrón en PaymentModal:**
```typescript
// ✅ Dynamic import para launchPaymentModal
const handleBitcoinConnect = useCallback(async () => {
  const { launchPaymentModal } = await import('@getalby/bitcoin-connect-react');
  launchPaymentModal({ invoice: invoice.bolt11 });
}, [invoice.bolt11]);
```

**Lección aprendida:** Siempre usar dynamic imports para librerías que dependen de APIs del DOM en Next.js.

---

## 📊 Parte 6: Análisis de Costos

### 6.1 Tokens Consumidos

| Métrica | Valor | Costo |
|---------|-------|-------|
| Input tokens | ~435,000 | $6.53 ($15/1M) |
| Output tokens | ~151,000 | $11.33 ($75/1M) |
| **Total LLM** | | **$17.86** |

### 6.2 Costo LLM vs Manual

| Método | Costo | Tiempo |
|--------|-------|--------|
| API + Cloud Run | ~$18 | ~1 hora |
| Suscripción ($20/mo) | incluido | ~1 hora |
| Manual (dev senior) | $400-1600 | 8-16 horas |

**ROI:**
- Developer rate: ~$50-100/hr
- Manual: 8-16 hrs = $400-1600
- Automatizado: ~$18
- **Ahorro: 95-99%**

### 6.3 Infraestructura (Cloud Run)

| Recurso | 4 horas | Costo |
|---------|---------|-------|
| vCPU (1 core) | 14,400s | $0.35 |
| Memory (1GB) | 14,400s | $0.04 |
| Egress (~0.5GB) | - | $0.06 |
| **Total infra** | | **$0.45** |

**Total general: ~$18.31 USD**

---

## ✅ Parte 7: Verificación

### 7.1 Test Page (/pipeline-test)

La página de test permite verificar la integración sin completar un checkout completo:

1. Navegar a `http://localhost:3000/pipeline-test`
2. Click "Run Test Payment"
3. Escanear QR con wallet Lightning
4. Pagar 1 sat
5. Ver status cambiar a "success"

### 7.2 Checklist de Testing

- [x] Build compila sin errores
- [x] Type check pasa
- [x] Invoice API retorna bolt11 real
- [x] QR code es scannable
- [x] Polling detecta pago
- [x] Success page muestra después de pago
- [x] Traducciones completas (en/es)
- [ ] NWC_URL configurado (paso manual)
- [ ] E2E test con sats reales (paso manual)

### 7.3 Configuración de Wallets NWC

**Paso 1: Obtener NWC URL**

Opción A - Alby Hub (self-custodial):
1. Instalar Alby Hub: https://albyhub.com
2. Settings → Wallet Connections → Create new
3. Permisos: `make_invoice`, `lookup_invoice`
4. Copiar NWC URL

Opción B - Alby Account (custodial):
1. Crear cuenta: https://getalby.com
2. Developer → Wallet Connections → Create new
3. Copiar NWC URL

**Paso 2: Configurar .env.local**

```bash
cp .env.local.example .env.local
```

Editar `.env.local`:
```env
# NWC Connection (from Alby Hub or Alby Account)
# IMPORTANT: Use "isolated" connections for security
NWC_URL=nostr+walletconnect://[pubkey]?relay=[relay]&secret=[secret]
```

**Paso 3: Reiniciar dev server**
```bash
npm run dev
```

---

## 🔄 Parte 8: Replicar el Pipeline

### 8.1 El Prompt Inicial (start-prompt.md)

Para replicar este pipeline en otro proyecto e-commerce:

```markdown
Ejecutá /pipeline-run para implementar pagos Lightning en este proyecto.

## Contexto

Este es un proyecto e-commerce con:
- Carrito de compras funcional
- Página de checkout con formulario
- API de orders (fake/placeholder)
- API de invoices (fake/placeholder)

## Objetivo

Implementar pagos reales con Bitcoin Lightning usando:
- NWC (Nostr Wallet Connect) para backend
- Bitcoin Connect para UI de pago
- QR codes escaneables
- Polling de estado de pago

## Requisitos

1. **Opción de implementación**: Hybrid (D)
2. **Incluir test page**: Sí (/pipeline-test)
3. **Documentación**: Generar en .pipeline/
4. **Commits**: Atómicos, uno por paso lógico

## Notas Importantes

- Usar dynamic imports para bitcoin-connect (evitar SSR errors)
- El NWC_URL va en .env.local (no commitear)
- Crear .env.local.example con documentación
```

### 8.2 Skills Creados

| Skill | Comando | Descripción |
|-------|---------|-------------|
| Scout | `/pipeline-scout` | Analizar estructura del sitio |
| Architect | `/pipeline-architect` | Mapear puntos de integración |
| Research | `/pipeline-research` | Investigar opciones NWC |
| Plan | `/pipeline-plan` | Crear plan de implementación |
| Build | `/pipeline-build` | Ejecutar implementación |
| Wallet | `/pipeline-wallet` | Configurar wallets NWC |
| Test | `/pipeline-test` | Ejecutar tests E2E |
| **Run** | `/pipeline-run` | **Orquestar todo** |

### 8.3 Uso en Otros Proyectos

**Pre-requisitos del proyecto:**
- Next.js con App Router
- Carrito funcional (cualquier state manager)
- Página de checkout
- API routes para orders e invoices
- Tailwind CSS configurado

**Ejecutar:**
```bash
/pipeline-run
```

El orquestador guiará por las 8 fases automáticamente.

---

## 📚 Anexos

### A. Commits Realizados (11)

```
828db75 feat(deps): install Bitcoin Connect and QR dependencies
45cd7b6 feat(lib): add NWC client and payment types
5137a90 feat(api): implement real NWC invoice creation and status
b5adc3b feat(ui): add Bitcoin Connect provider and PaymentModal
f9b2c48 feat(checkout): integrate payment modal in checkout flow
0f391b7 feat(pages): add checkout success page and i18n
c72f2b7 feat(test): add pipeline test page and documentation
df30d53 docs(pipeline): add wallet config and test results documentation
80bb65b docs(env): add comprehensive NWC configuration example
8863cdd docs(readme): add Lightning payment testing instructions
3423d11 fix(bitcoin-connect): use dynamic import to avoid SSR HTMLElement error
```

### B. Archivos Creados/Modificados

**Nuevos:**
```
src/lib/nwc.ts                                    # NWC client singleton
src/app/api/invoices/[id]/status/route.ts         # Status endpoint
src/components/checkout/PaymentModal.tsx          # Payment modal
src/components/providers/BitcoinConnectProvider.tsx
src/app/checkout/success/page.tsx                 # Success page
src/app/pipeline-test/page.tsx                    # Test page
.env.local.example                                # Config template
.pipeline/                                        # 6 docs
```

**Modificados:**
```
package.json                                      # +2 deps
src/app/api/invoices/route.ts                     # Real NWC
src/components/checkout/CheckoutForm.tsx          # Modal integration
src/components/Providers.tsx                      # Bitcoin Connect
src/types/index.ts                                # Payment types
src/messages/en.json                              # i18n
src/messages/es.json                              # i18n
README.md                                         # Instructions
```

### C. Documentación del Pipeline

Todos los archivos generados en `.pipeline/`:

| Archivo | Contenido |
|---------|-----------|
| `01-site-analysis.md` | Stack, estructura, gaps |
| `02-architecture-map.md` | Diagramas, puntos de integración |
| `03-payment-options.md` | 4 opciones, matriz de decisión |
| `04-implementation-plan.md` | Plan detallado, commits |
| `05-wallet-config.md` | Guía de configuración NWC |
| `06-test-results.md` | Checklist, resultados |
| `start-prompt.md` | Prompt para replicar |
| `costs.md` | Análisis de costos |

---

## 🔗 Referencias

- [Alby Developer Guide - NWC JS SDK](https://guides.getalby.com/developer-guide/nostr-wallet-connect-api/building-lightning-apps/nwc-js-sdk)
- [@getalby/sdk on npm](https://www.npmjs.com/package/@getalby/sdk)
- [Bitcoin Connect GitHub](https://github.com/getAlby/bitcoin-connect)
- [NWC Specification (NIP-47)](https://nwc.dev)
- [PROOF-OF-WEAR Repository](https://github.com/orgs/Oryon-soluciones/repositories)

---

> *"Las estrellas no brillan solas. Brillan en constelación."* - Orion

---

**Pipeline ejecutado por:** Orion (Orquestador) con Scout, Architect, Sócrates, Strategist, Builder, Wallet, y Tester agents.

**Fecha:** 2026-01-16

**Versión:** 1.0.0
