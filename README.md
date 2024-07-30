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
- [🤝 Agradecimiento](#-agradecimientos)

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
    docker-compose up

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

- **Ruta**: `./app_mobile`
- **Descripción**: Aplicación móvil desarrollada en React Native para visualizar los datos ambientales.

## 🌐 Configuración de Nginx

- **Ruta**: `./nginx`
- **Descripción**: Configuración de Nginx como proxy inverso para gestionar las peticiones a los diferentes microservicios.

    ```nginx
     http {
      include       mime.types;
      default_type  application/octet-stream;
  
      sendfile        on;
      keepalive_timeout  65;
  
      upstream cuentas {
          server servicio-cuentas:3000;
      }
  
      upstream usuarios {
          server servicio-usuarios:3000;
      }
  
      upstream sensores {
          server servicio-sensores:3000;
      }
  
      server {
          listen 80;
  
          location /api/cuentas/ {
              proxy_pass http://cuentas;
          }
  
          location /api/usuarios/ {
              proxy_pass http://usuarios;
          }
  
          location /api/roles/ {
              proxy_pass http://usuarios;
          }
  
          location /api/sensores/ {
              proxy_pass http://sensores;
          }
  
          location /api/registros/ {
              proxy_pass http://sensores;
          }
      }
  }
    ```

## 🤝 Agradecimientos

Agradecemos a todos los colaboradores y al equipo que ha hecho posible este proyecto:

- **David Campoverde**: Backend developer para el desarrollo de los microservicios
- **Jhandry Chimbo**: Frontend developer en el diseño de la página web.
- **Ivan Gonzalez**: Fullstack developer para el desarrollo de la aplicación (Backend y Frontend).
- **David Intriago**: Diseño de la red para escalamiento horizontal de microservicios de la topología de red.
- **Dennys Pucha**: Desarrollo de la aplicación móvil en React Native.


