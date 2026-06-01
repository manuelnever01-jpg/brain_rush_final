BrainRush

Descripción

BrainRush es una aplicación móvil desarrollada para el fortalecimiento de la agilidad mental mediante retos interactivos. El problema que resuelve es la falta de herramientas accesibles para el entrenamiento cognitivo diario, ofreciendo a los usuarios una forma rápida y gamificada de medir su desempeño, con persistencia de datos para seguimiento histórico.

Integrantes
Manuel Restrepo Ramirez: Desarrollador Líder / Arquitectura de Software / Implementación de Lógica de Juego.

Stack Tecnológico
Framework: Flutter (Android).

Arquitectura: Modular basada en estado (UI, Repository, DataSources).

Persistencia Local: SharedPreferences.

Persistencia Remota: Firebase Cloud Firestore.

Autenticación: Firebase Auth.

Observabilidad: Firebase Crashlytics.

Funcionalidades principales
Autenticación: Login seguro y gestión de sesión persistente.

Retos de Agilidad: Flujo de juego dinámico con respuesta inmediata.

Historial CRUD: Registro, consulta y eliminación de partidas.

Modo Offline: Persistencia local para uso sin conexión.

Arquitectura
La aplicación utiliza un patrón de Repositorio para desacoplar la interfaz de la lógica de datos, facilitando la mantenibilidad y el escalamiento.

Ver documentación de arquitectura detallada

Cómo ejecutar localmente
Requisitos: Flutter SDK (versión 3.x recomendada).

Clonación: git clone [URL_DE_TU_REPOSITORIO]

Instalación: Ejecutar flutter pub get en la raíz del proyecto.

Configuración: Asegurarse de tener el archivo google-services.json correctamente configurado en la carpeta android/app/.

Ejecución: Conectar un dispositivo móvil o emulador y ejecutar flutter run.

Servicios externos
Firebase Auth: Gestión de identidades y seguridad de acceso.

Cloud Firestore: Almacenamiento y sincronización de datos de usuario en la nube.

Firebase Crashlytics: Monitoreo y reporte de fallos en tiempo real.

Documentación
SRS (Especificación de Requisitos)

Diagramas de Arquitectura y Flujo

Mockups y Diseño
