# <p align="center">💸 Fluxo — Finanzas Personales y Recordatorios Inteligentes</p>

<p align="center">
Una aplicación moderna, intuitiva y completamente offline diseñada para ayudarte a administrar tus ingresos, gastos y recordatorios financieros de forma sencilla y eficiente.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=flat&logo=flutter&logoColor=white" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-0175C2?style=flat&logo=dart&logoColor=white" alt="Dart">
  <img src="https://img.shields.io/badge/Hive-FFB300?style=flat&logo=flutter&logoColor=white" alt="Hive">
  <img src="https://img.shields.io/badge/Provider-7B1FA2?style=flat" alt="Provider">
  <img src="https://img.shields.io/badge/Material_3-6750A4?style=flat&logo=materialdesign&logoColor=white" alt="Material 3">
  <img src="https://img.shields.io/badge/Android-3DDC84?style=flat&logo=android&logoColor=white" alt="Android">
  <img src="https://img.shields.io/badge/Notificaciones_Locales-FF7043?style=flat" alt="Local Notifications">
</p>

---

# 📖 Acerca del Proyecto

**Fluxo** es una aplicación móvil desarrollada con **Flutter** que permite gestionar las finanzas personales de manera simple, rápida y completamente sin conexión a internet.

La aplicación permite registrar **ingresos y gastos**, organizar movimientos financieros, establecer **recordatorios para pagos importantes**, y mantener toda la información almacenada de forma local utilizando **Hive**.

El proyecto fue desarrollado con el objetivo de aplicar buenas prácticas en el desarrollo móvil, implementando una arquitectura organizada, persistencia local de datos y una interfaz moderna basada en **Material 3**.

---

# ✨ Características Principales

- 💰 Registro de ingresos y gastos.
- 📝 Creación de movimientos con título y descripción.
- 📅 Selección de fecha de vencimiento.
- 🔔 Sistema de recordatorios mediante notificaciones locales.
- ⏰ Configuración de cuántos días antes recibir la notificación.
- ✅ Marcar movimientos como completados.
- 💾 Almacenamiento local mediante Hive.
- ⚡ Gestión de estado utilizando Provider.
- 🎨 Interfaz moderna basada en Material Design 3.
- 📱 Optimizado para dispositivos Android.
- 🌙 Compatible con tema claro y oscuro.
- 🔒 Toda la información permanece almacenada en el dispositivo del usuario.

---

# 🛠 Tecnologías Utilizadas

### Desarrollo Móvil

- Flutter
- Dart

### Gestión de Estado

- Provider

### Base de Datos Local

- Hive

### Notificaciones

- flutter_local_notifications
- timezone

### Diseño

- Material 3
- Google Fonts
- Sistema de Temas Personalizado

---

# 🚀 Instalación

### 1. Clonar el repositorio

```bash
git clone https://github.com/K1lluaZk/Fluxo.git
```

### 2. Entrar al proyecto

```bash
cd Fluxo
```

### 3. Instalar dependencias

```bash
flutter pub get
```

### 4. Generar los adaptadores de Hive

```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### 5. Ejecutar la aplicación

```bash
flutter run
```

---


# 🔔 Sistema de Recordatorios

Fluxo incorpora un sistema de notificaciones locales que permite:

- Seleccionar una fecha de vencimiento.
- Activar o desactivar recordatorios.
- Configurar cuántos días antes se enviará la notificación.
- Recibir alertas incluso cuando la aplicación se encuentra cerrada.

---

# 💾 Funcionamiento Offline

Toda la información registrada por el usuario se almacena localmente mediante **Hive**, por lo que la aplicación funciona completamente sin conexión a internet, garantizando rapidez, privacidad y disponibilidad permanente de los datos.

---

# 📱 Capturas de Pantalla

<img width="1080" height="2340" alt="image" src="https://github.com/user-attachments/assets/366c56e1-cae5-4fed-989f-2d4ca1298210" />
<img width="1080" height="2340" alt="image" src="https://github.com/user-attachments/assets/fbd6b9de-9893-4b11-bdaf-7694fca0b33e" />
<img width="1080" height="2340" alt="image" src="https://github.com/user-attachments/assets/bdd3e949-105f-4188-b790-c9266e11dd07" />
<img width="1080" height="2340" alt="image" src="https://github.com/user-attachments/assets/4930ccfe-c1d4-4554-b689-e14f411df9b1" />
<img width="1080" height="2340" alt="image" src="https://github.com/user-attachments/assets/00482bf5-5ac8-4233-b0dd-01a643a48df6" />

---

# 👨‍💻 Autor

**Mario Suero (K1lluaZk)**

GitHub:
https://github.com/K1lluaZk

---

# 📄 Licencia

Este proyecto se distribuye bajo la **Licencia MIT**.
