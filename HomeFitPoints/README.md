# Memoria Técnica: HomeFitPoints

### 1. Objetivo de la App
**HomeFitPoints** es una aplicación diseñada para fomentar el hábito del ejercicio en casa a través de la gamificación. 

Su objetivo principal es motivar al usuario mediante un sistema de **puntos y niveles** (Principiante, Intermedio, Avanzado) que se desbloquean conforme se completa el historial de entrenamientos.

La app prioriza una experiencia "Local-First" garantizando que el usuario pueda entrenar y registrar su progreso posteriormente, integrando funcionalidades de respaldo en la nube de forma opcional.

### 2. Descripción del Logo
El isotipo de la aplicación presenta una silueta humana estilizada realizando un levantamiento de pesas (press militar) sobre un fondo de color **Naranja** (`#FF7A00`).

* **Simbolismo:** La figura representa la fuerza, la superación personal y el "triunfo" al terminar una rutina.
* **Color:** Se eligió el naranja como color primario por su psicología asociada a la energía, vitalidad, entusiasmo y juventud, diferenciándose de los tradicionales azules o rojos de otras apps médicas o deportivas.

### 3. Justificación Técnica

* **Dispositivo:** **Móvil**. La naturaleza de la app es personal y móvil; el usuario necesita llevar el dispositivo consigo al espacio de entrenamiento en casa, por lo que el formato teléfono es el más recomendado.
* **Sistema Operativo:** **iOS 15.6+**. Se seleccionó esta versión mínima para asegurar compatibilidad con una amplia gama de dispositivos, permitiendo el uso de tecnologías modernas como **Swift Concurrency**.
* **Orientaciones:** Exclusivamente **Portrait (Vertical)**. Las listas de ejercicios y temporizadores se consumen mejor en formato vertical; permitir la rotación podría interrumpir el flujo del usuario durante el ejercicio.
 * **Soporte de Idiomas:** **Español e Inglés**.
        Para ampliar el alcance de la aplicación y demostrar buenas prácticas de desarrollo profesional, se implementó un sistema de localización completo (`Localizable.strings`), asegurando que la interfaz, los mensajes de error y los formatos de fecha se adapten automáticamente a la región del usuario.

### 4. Arquitectura de Datos y API
La aplicación no utiliza datos estáticos ("hardcoded") para los ejercicios. Consume información dinámica desde un servicio web.

* **Fuente de Datos:** API REST (Simulada en Postman Mock Server).
* **Endpoint:** `.../obtener_ejercicios`
* **Formato:** JSON. Contiene la estructura de niveles, rutinas, URLs de imágenes y mensajes motivacionales.


### 5. Credenciales de Acceso
La aplicación cuenta con una arquitectura híbrida que permite dos modos de uso:

* **Modo Invitado (Acceso Inmediato):** No se requieren credenciales. El usuario puede abrir la app, completar rutinas y ver su progreso guardado localmente sin barreras de entrada.

* **Modo Registrado (Autenticación en Nube):**
    La app permite crear nuevas cuentas con cualquier correo válido para probar el flujo completo de registro.
    
    Si se desea omitir el registro y probar el login directo:
    * **Usuario de Prueba:** `fabian10@gmail.com`
    * **Contraseña:** `Fabian10`

### 6. Dependencias y Tecnologías
Desarrollada en  **UIKit** de forma programática.

**Tecnologías Clave:**
* **Swift Concurrency (Async/Await):** Para un manejo eficiente de hilos en segundo plano (descarga de imágenes y JSON) sin bloquear la interfaz de usuario.
* **Firebase (Auth & Firestore):** Gestión de identidad y preparación para respaldo en la nube.
* **Network Framework:** Monitoreo de conectividad (WiFi vs Datos) para ahorro de consumo.
* **AVKit:** Reproducción de video de fondo en bucle y efectos de sonido.
* **NSCache:** Sistema de caché de imágenes personalizado para optimizar el consumo de red.


### 7. Roadmap (Mejoras Futuras)
El proyecto está diseñado con una arquitectura escalable que permite la integración de las siguientes características en la versión 2.0:
* **Sincronización en la Nube (Data Merging):** Implementación de un algoritmo de fusión para sincronizar el progreso local con Firestore al iniciar sesión en múltiples dispositivos.
* **Notificaciones Push:** Recordatorios personalizados basados en los días de inactividad del usuario.
* **Modo Social:** Tablas de clasificación (Leaderboards) para competir con amigos.


### 8. Autoría
**Desarrollado por:** Luis Fabian Armenta Chora

**Curso:** Diplomado de Desarrollo de Aplicaciones para Dispositivos Móviles Emisión 14

**Fecha:** Noviembre 2025

---
*Este proyecto fue creado con fines exclusivamente académicos y educativos.*
