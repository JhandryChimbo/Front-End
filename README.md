# Proyecto de Monitoreo Ambiental con Microservicios

Este proyecto de monitoreo ambiental utiliza una arquitectura basada en microservicios para recolectar, procesar y visualizar datos ambientales. Incluye una aplicación móvil desarrollada en React Native y un proxy inverso configurado con Nginx para gestionar las peticiones.

## Contenido
- [Descripción del Proyecto](#descripción-del-proyecto)
- [Arquitectura del Proyecto](#arquitectura-del-proyecto)
- [Requisitos](#requisitos)
- [Instalación](#instalación)
- [Uso](#uso)
- [Microservicios](#microservicios)
- [Aplicación Móvil](#aplicación-móvil)
- [Configuración de Nginx](#configuración-de-nginx)
- [Contribuciones](#contribuciones)
- [Licencia](#licencia)

## Descripción del Proyecto
Este proyecto tiene como objetivo proporcionar un sistema completo de monitoreo ambiental que incluye la recolección de datos a través de sensores, el procesamiento de estos datos en diferentes microservicios y la visualización en una aplicación móvil.

## Arquitectura del Proyecto
La arquitectura del proyecto se basa en microservicios, donde cada uno de ellos se encarga de una funcionalidad específica:

- **Microservicio de Recolección de Datos**: Recibe datos de sensores.
- **Microservicio de Procesamiento de Datos**: Procesa y almacena los datos en una base de datos.
- **Microservicio de Visualización de Datos**: Proporciona una API para la aplicación móvil.
- **Aplicación Móvil (React Native)**: Permite a los usuarios visualizar los datos ambientales.
- **Nginx**: Actúa como un proxy inverso para gestionar las peticiones a los diferentes microservicios.

## Requisitos
- Docker
- Docker Compose
- Node.js
- React Native CLI
- Nginx

## Instalación
1. Clona el repositorio:
    ```bash
    git clone https://github.com/IvanG0nzalez/monitoreo-ambiental-microservicios.git
    cd monitoreo-ambiental-microservicios
    ```
2. Configura las variables de entorno:
    - Crea un archivo `.env` en la raíz del proyecto y configura las variables necesarias para cada microservicio.

3. Construye y levanta los contenedores Docker:
    ```bash
    docker-compose up --build
    ```

4. Instala las dependencias de la aplicación móvil:
    ```bash
    cd app
    npm install
    ```

## Uso
Levanta la aplicación móvil:

```bash
react-native run-android
# O
react-native run-ios

Accede a la aplicación:

La aplicación móvil estará disponible en el emulador o dispositivo físico conectado.

## Microservicios

### Recolección de Datos
- **Ruta**: `./services/data-collector`
- **Descripción**: Recibe datos de los sensores y los envía al microservicio de procesamiento.

### Procesamiento de Datos
- **Ruta**: `./services/data-processor`
- **Descripción**: Procesa los datos recibidos y los almacena en la base de datos.

### Visualización de Datos
- **Ruta**: `./services/data-visualizer`
- **Descripción**: Proporciona una API para que la aplicación móvil consuma los datos procesados.

## Aplicación Móvil
- **Ruta**: `./app`
- **Descripción**: Aplicación móvil desarrollada en React Native para visualizar los datos ambientales.

## Configuración de Nginx
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
