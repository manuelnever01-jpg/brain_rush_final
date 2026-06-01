# BrainRush

## Descripción
BrainRush es una aplicación móvil diseñada para el fortalecimiento de la agilidad mental mediante retos interactivos. El problema que resuelve es la falta de herramientas accesibles para el entrenamiento cognitivo diario, ofreciendo a los usuarios una forma rápida y gamificada de medir su desempeño, con persistencia de datos para seguimiento histórico. Su diseño móvil tiene sentido porque permite entrenar en tiempos muertos o periodos cortos durante el día, facilitando la adopción de un hábito saludable.

## Integrantes
* **Manuel Restrepo Ramirez:** Desarrollador Líder / Arquitecto de Software / Implementación de Lógica de Juego y Backend.

## Stack tecnológico
* **Framework:** Flutter (Android).
* **Arquitectura:** Patrón de Repositorio (Modular: UI, State, Repository, DataSources).
* **Persistencia local:** `SharedPreferences`.
* **Persistencia remota:** Firebase Cloud Firestore.
* **Auth:** Firebase Authentication.
* **Crashlytics:** Firebase Crashlytics para observabilidad.

## Funcionalidades principales
* **Autenticación:** Gestión segura de inicio y cierre de sesión de usuarios.
* **Retos de Agilidad:** Flujo de juego dinámico con respuesta inmediata.
* **Gestión de Historial (CRUD):** Registro, consulta y eliminación de partidas.
* **Modo Offline:** Persistencia de datos locales para funcionamiento sin conexión.

## Arquitectura
La aplicación utiliza un **Patrón de Repositorio** que desacopla la interfaz de la lógica de datos, permitiendo que la aplicación sea mantenible y escalable.

## Cómo ejecutar localmente
1. **Requisitos:** Tener instalado Flutter SDK (versión 3.x recomendada) y Android Studio.
2. **Clonación:** `git clone [https://github.com/manuelnever01-jpg/brain_rush_final.git]`.
3. **Instalación:** Ejecutar `flutter pub get` en la raíz del proyecto.
4. **Configuración:** Colocar el archivo `google-services.json` (obtenido de Firebase Console) en la carpeta `android/app/`.
5. **Ejecución:** Conectar un emulador o dispositivo Android y ejecutar `flutter run`.

## Servicios externos
* **Firebase Auth:** Gestión de identidades y seguridad de acceso.
* **Cloud Firestore:** Almacenamiento y sincronización de datos de usuario en la nube.
* **Firebase Crashlytics:** Monitoreo y reporte de fallos en tiempo real para mantenimiento preventivo.

## Documentación
* [SRS (Especificación de Requisitos)](docs/SRS.md)
* [Diagramas de Arquitectura y Flujo](docs/diagramas/)
* [Registro de uso de IA](docs/uso-ia.md)
