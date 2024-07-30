# 📊 Proyecto de Monitoreo Ambiental con Microservicios

Este proyecto de monitoreo ambiental utiliza una arquitectura basada en microservicios para recolectar, procesar y visualizar datos ambientales. Incluye una aplicación móvil desarrollada en React Native y un proxy inverso configurado con Nginx para gestionar las peticiones.

## 📋 Contenido

- [📖 Descripción del Proyecto](#-descripción-del-proyecto)
- [🏗 Arquitectura del Proyecto](#-arquitectura-del-proyecto)
- [🛠 Requisitos](#-requisitos)
- [⚙️ Instalación](#-instalación)
- [🚀 Uso](#-uso)
- [🔧 Microservicios](#-microservicios)
  - [Recolección de Datos](#recolección-de-datos)
  - [Procesamiento de Datos](#procesamiento-de-datos)
  - [Visualización de Datos](#visualización-de-datos)
- [📱 Aplicación Móvil](#-aplicación-móvil)
- [🌐 Configuración de Nginx](#-configuración-de-nginx)
- [🤝 Contribuciones](#-contribuciones)

## 📖 Descripción del Proyecto

Este proyecto tiene como objetivo proporcionar un sistema completo de monitoreo ambiental que incluye la recolección de datos a través de sensores, el procesamiento de estos datos en diferentes microservicios y la visualización en una aplicación móvil.

## 🏗 Arquitectura del Proyecto

La arquitectura del proyecto se basa en microservicios, donde cada uno de ellos se encarga de una funcionalidad específica:

- **Microservicio de Cuentas**: Manejo de informacion de las cuentas.
- **Microservicio de Usuario**: Gestiona los datos de los usuarios.
- **Microservicio de Sensores**: Control de los sensores.

## 🛠 Requisitos

- Docker
- Docker Compose
- Node.js
- React Native CLI
- Nginx

## ⚙️ Instalación

1. **Clona el repositorio**:

    ```bash
    git clone https://github.com/IvanG0nzalez/monitoreo-ambiental-microservicios.git
    cd monitoreo-ambiental-microservicios
    ```

2. **Configura las variables de entorno**:

    Crea un archivo `.env` en la raíz del proyecto y los diferentes microservicios para despues configurar las variables necesarias de cada archivo.

3. **Construir y levantar los contenedores Docker**:

    3.1 **Docker dev**

    ```bash
    docker compose -f docker-compose-dev.yml up
    ```

    3.2 **Docker Compose**
  
    ```bash
    docker-

4. **Instala las dependencias de la aplicación móvil**:

    ```bash
    cd app
    npm install
    ```

## 🚀 Uso

1. **Levanta la aplicación móvil**:

    ```bash
    react-native run-android
    # O
    react-native run-ios
    ```

2. **Accede a la aplicación**:

    La aplicación móvil estará disponible en el emulador o dispositivo físico conectado.

## 🔧 Microservicios

### Cuentas

- **Ruta**: `./microservicio-cuentas`
- **Descripción**: Manje la información de las cuentas

### Usuarios

- **Ruta**: `./microservicio-usuarios`
- **Descripción**: Procesa los datos del usuario.

### Sensores

- **Ruta**: `./microservicio-sensores`
- **Descripción**: Recibe datos de los sensores y los almacena.

## 📱 Aplicación Móvil

- **Ruta**: `./app`
- **Descripción**: Aplicación móvil desarrollada en React Native para visualizar los datos ambientales.

## 🌐 Configuración de Nginx

- **Ruta**: `./nginx`
- **Descripción**: Configuración de Nginx como proxy inverso para gestionar las peticiones a los diferentes microservicios.

    ```nginx
    server {
        listen 80;

        location /api/collector {
            proxy_pass http://data-collector:3000;
        }

        location /api/processor {
            proxy_pass http://data-processor:3000;
        }

        location /api/visualizer {
            proxy_pass http://data-visualizer:3000;
        }

        location / {
            proxy_pass http://frontend:3000;
        }
    }
    ```

## 🤝 Agradecimientos

Las contribuciones son bienvenidas. Por favor, abre un issue o un pull request para discutir cualquier cambio que te gustaría realizar.


