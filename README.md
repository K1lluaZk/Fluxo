# <p align="center">Fluxo - File Transfer App</p>
<p align="center">Una solución moderna y eficiente para la transferencia de archivos local entre dispositivos móviles y PC, construida con Flutter y un backend ligero en Python.</p>

<p align="center"> 
  <img src="https://img.shields.io/badge/Flutter-02569B?style=flat&logo=flutter&logoColor=white" alt="Flutter"> 
  <img src="https://img.shields.io/badge/Dart-0175C2?style=flat&logo=dart&logoColor=white" alt="Dart"> 
  <img src="https://img.shields.io/badge/Python-3776AB?style=flat&logo=python&logoColor=white" alt="Python"> 
  <img src="https://img.shields.io/badge/Socket--Programming-4285F4?style=flat&logo=google-cloud&logoColor=white" alt="Sockets">
</p>

<p align="center">
  🌐 <a href="https://github.com/mario-de-jesus-suero-de-leon/fluxo-app">Ver repositorio del proyecto</a>
</p>

---

## 📱 Sobre el Proyecto

Fluxo nació de la necesidad de transferir archivos de forma rápida y privada dentro de una red local sin depender de la nube. Este ecosistema consta de una aplicación móvil intuitiva y un servidor de escritorio que permite recibir documentos, imágenes y videos con un solo toque, manteniendo un registro detallado de cada operación.

## ✨ Características Principales

* ⚡ **Transferencia Socket-to-Socket:** Comunicación directa mediante protocolos TCP/IP para asegurar que los archivos viajen a la máxima velocidad permitida por tu red local.
* 🏆 **Historial Persistente:** Implementación de `shared_preferences` para mantener un registro de los archivos enviados (nombre, hora y tamaño) incluso después de cerrar la aplicación.
* 📊 **Progreso en Tiempo Real:** Feedback visual tanto en la app (UI dinámica) como en la terminal del servidor, permitiendo monitorear el estado exacto de la transferencia.
* 🌓 **Diseño Moderno:** Interfaz limpia con una paleta de colores vibrante (Purple/Indigo), optimizada para ofrecer una experiencia de usuario fluida y profesional.
* 🛠️ **Protocolo de Robustez:** Sistema de handshake mediante `<SEPARATOR>` y señales `READY` para evitar la fragmentación de paquetes y asegurar la integridad de los datos.


## 🛠️ Tecnologías Utilizadas

* **Frontend (Móvil):** Dart & Flutter (v3.11+).
* **Backend (Servidor):** Python 3.x (Librería `socket` nativa).
* **Persistencia:** JSON & SharedPreferences para almacenamiento local.
* **Gestión de Archivos:** `file_picker` y `path` para integración con el sistema de archivos de Android.

## 🚀 Cómo Ejecutar Localmente

### 1. Preparar el Servidor (PC)
bash
# Navega a la carpeta del servidor
cd server
# Ejecuta el receptor
python server.py

### 2. Configurar la App (Móvil)
Asegúrate de que tu celular y PC estén en la misma red Wi-Fi.

Obtén la IP de tu PC (ipconfig en Windows) y actualízala en el archivo main.dart.

### 3. Instalacion
bash
flutter pub get
flutter run

### 4. Estructura del proyecto

├── android/            # Configuraciones nativas (Icono y nombre de la app)
├── assets/             # Logo personalizado y recursos visuales
├── lib/
│   └── main.dart       # App Flutter: UI, Sockets y persistencia SharedPreferences
├── server/
│   └── server.py       # Script Python: Servidor TCP receptor
└── pubspec.yaml        # Dependencias y recursos del proyecto

### 5. Imagenes

<img width="284" height="262" alt="image" src="https://github.com/user-attachments/assets/0488ce1f-19db-49fe-bda0-fd7efc6e8462" />
<img width="811" height="1600" alt="image" src="https://github.com/user-attachments/assets/35c0517d-330d-4e85-aed4-4ac166be651f" />
<img width="811" height="1599" alt="image" src="https://github.com/user-attachments/assets/b3db836f-f478-45d1-856a-c9aac1f115c5" />
<img width="820" height="1600" alt="image" src="https://github.com/user-attachments/assets/ff4cfa11-5ebb-4580-acf2-1f09a893dcd2" />

## Author

* **Mario** - [GitHub Profile](https://github.com/K1lluaZk)

## License

This project is licensed under the MIT License.



