# banco-microservice de Gestion de Cuentas y Transacciones

## Descripcion

Este proyecto implementa un microservicio backend para la gestion de cuentas bancarias y transacciones (depositos, retiros y transferencias), disenado bajo principios de consistencia, atomicidad y trazabilidad.

El sistema garantiza la integridad de las operaciones financieras, previniendo estados inconsistentes incluso ante fallos o concurrencia.

---

## Arquitectura

Se implemento una arquitectura en capas:

- Routes (Interface Layer) -> Manejo de endpoints HTTP
- Services (Application Layer) -> Logica de negocio
- Database (Infrastructure Layer) -> Persistencia en PostgreSQL

### Principios aplicados

- Separacion de responsabilidades
- Transacciones ACID
- Control de concurrencia
- Fail-safe design

---

## Stack Tecnologico

- Node.js (Express)
- PostgreSQL 16
- Docker
- UUID para generacion de identificadores unicos

---

## Base de Datos

### Motor seleccionado: PostgreSQL

### Justificacion

1. Soporte completo de transacciones ACID
2. Manejo de concurrencia con bloqueo de filas (FOR UPDATE)
3. Integridad referencial mediante claves foraneas
4. Soporte de indices avanzados para consultas eficientes

---

## Decisiones de Diseno

### Manejo de saldo negativo
- Restriccion en base de datos (CHECK balance >= 0)
- Validacion adicional en la capa de aplicacion

### Transferencias atomicas
- Uso de transacciones (BEGIN / COMMIT / ROLLBACK)
- Si una operacion falla, toda la transaccion se revierte

### Concurrencia
- Uso de SELECT ... FOR UPDATE para bloquear registros
- Previene condiciones de carrera

### Idempotencia
- Uso de reference UNIQUE en transacciones
- Evita duplicidad por reintentos de red

---

## Endpoints

### Crear cuenta
POST /accounts

### Consultar cuenta
GET /accounts/{id}

### Deposito
POST /transactions/deposit

### Retiro
POST /transactions/withdraw

### Transferencia
POST /transactions/transfer

---

## Ejemplos de Request

### Deposito
{
  "accountId": "uuid",
  "amount": 100
}

### Transferencia
{
  "fromAccountId": "uuid",
  "toAccountId": "uuid",
  "amount": 50
}

---

## Pruebas

El sistema contempla pruebas para:

- Depositos exitosos
- Validacion de saldo insuficiente
- Transferencias atomicas
- Manejo de errores

---

## Ejecucion con Docker

docker-compose up --build

Luego ejecutar el script de base de datos:

psql -U postgres -d bank -f schema.sql

---

## Escenarios del Negocio

### Saldo negativo
Prevenido mediante restricciones en BD y validaciones en codigo.

### Cuenta inactiva
Las operaciones son rechazadas con error especifico.

### Transferencia parcial
Se garantiza atomicidad con transacciones.

### Concurrencia
Se controla mediante bloqueo de registros (FOR UPDATE).

### Idempotencia
Se evita duplicacion mediante referencias unicas.

---

## Escalabilidad

Para escenarios de alto volumen (millones de transacciones):

- Particionado de tablas por fecha
- Indices optimizados
- Posible implementacion de Event Sourcing

---

## Extensibilidad

Para integrar notificaciones (email/SMS):

- Publicar eventos de dominio (ej: TransactionCreated)
- Consumidos por un microservicio desacoplado

---

## Decisiones Tecnicas (ADR)

### 1. Uso de PostgreSQL
Elegido por soporte ACID y control de concurrencia robusto.

### 2. Manejo de logica en App + DB
La aplicacion maneja reglas de negocio, la base de datos garantiza integridad.

### 3. Uso de transacciones
Se priorizo consistencia fuerte sobre performance.

---

## Como ejecutar

1. Clonar repositorio
2. Ejecutar Docker
3. Ejecutar script SQL
4. Probar endpoints con Postman


