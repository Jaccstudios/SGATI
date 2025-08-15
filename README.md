# 🚀 SGATI - Gestión de Activos de TI en Sui Move

SGATI es un módulo desarrollado en Move para la gestión de activos de tecnología de información (TI) en la blockchain de Sui. Permite registrar, asignar, enviar a mantenimiento y retirar activos, manteniendo un historial transparente y seguro de cada uno.

---

## 🛠️ Instalación de SUI y entorno Move

### 1️⃣ Instalar SuiUp  
```bash
curl -sSfL https://raw.githubusercontent.com/Mystenlabs/suiup/main/install.sh | sh
```

### 2️⃣ Comprobar SuiUp  
```bash
suiup --version
```

### 3️⃣ Instalar Sui  
```bash
suiup install sui@testnet
```

### 4️⃣ Comprobar instalación de Sui  
```bash
sui --version
```

---

## ✨ Características principales

- **Registro de activos:** Crea objetos únicos para cada activo de TI.
- **Asignación de activos:** Permite asignar activos a empleados y actualizar su ubicación.
- **Mantenimiento:** Lleva un registro de mantenimientos realizados y cambia el estado del activo.
- **Retiro de activos:** Marca activos como retirados, finalizando su ciclo de vida.
- **Historial de mantenimientos:** Guarda cada evento de mantenimiento en el activo correspondiente.

---

## 🧩 Estructuras principales

- `SgatiAdminCap`: Capacidad de administración del módulo, creada al desplegar el contrato.
- `Activo`: Representa un activo de TI, con información relevante y su historial de mantenimientos.
- `RegistroMantenimiento`: Detalles de cada mantenimiento realizado a un activo.

---

## ⚡ Funciones disponibles

- `init(ctx: &mut TxContext)`: Inicializa el módulo y asigna la capacidad de administrador.
- `crear_activo(...)`: Crea y registra un nuevo activo de TI.
- `asignar_activo(...)`: Asigna un activo a un empleado y actualiza su ubicación.
- `enviar_a_mantenimiento(...)`: Cambia el estado del activo a "en mantenimiento".
- `registrar_mantenimiento_realizado(...)`: Registra un mantenimiento y devuelve el activo al almacén.
- `retirar_activo(...)`: Marca el activo como retirado.

---

## 📋 Ejemplo de uso

```move
// Crear un activo
sgati_addr::sgati::crear_activo(
    "Laptop",
    "Dell Latitude 5420",
    "SN123456",
    "Almacén Central",
    ctx,
    clock
);

// Asignar activo a empleado
sgati_addr::sgati::asignar_activo(
    &mut activo,
    "Empleado123",
    "Oficina 2"
);

// Enviar activo a mantenimiento
sgati_addr::sgati::enviar_a_mantenimiento(
    &mut activo,
    "Taller TI"
);

// Registrar mantenimiento realizado
sgati_addr::sgati::registrar_mantenimiento_realizado(
    &mut activo,
    "preventivo",
    "Cambio de batería",
    "Técnico Juan",
    "Almacén Central",
    clock
);

// Retirar activo
sgati_addr::sgati::retirar_activo(&mut activo);
```

---

## 🚢 Despliegue

1. **Configura tu entorno Sui y Move.**
2. **Solicita tokens para despliegue en Mainnet** [aquí](https://docs.sui.io/build/token-faucet).
3. **Despliega el paquete en Move Registry** siguiendo la [guía oficial](https://registry.sui.io/).

---

## 📑 Requisitos para certificación

- Proyecto público en GitHub.
- Uso de objetos (`object::UID`).
- Documentación clara y ejemplos de uso.
- Paquete desplegado en Mainnet y registrado en Move Registry.

---

## 👤 Autor

- **Nombre:** Julio Arturo Córdova Cú
- **Correo:** juliocc817@gmail.com
- **GitHub:** [Jaccstudios](https://github.com/Jaccstudios)

---

## 📝 Licencia

Este proyecto es de código abierto y libre para su uso educativo y profesional.

---

¿Dudas o sugerencias? ¡Contribuye en el repositorio o abre un issue!