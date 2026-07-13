# 🗺️ Pokedex App - Prueba Técnica para Tesys21

## 💻 Entorno de Desarrollo y Versiones

| Componente | Versión / Detalle |
| :--- | :--- |
| **🚀 Framework** | Flutter 3.38.10 |
| **🎯 Lenguaje** | Dart 3.10.9 |
| **🤖 Android Toolchain** | API 36 (Android 16 SDK) |
| **☕ Java Environment** | OpenJDK 21.0.9 |
| **🍏 iOS / macOS Toolchain** | Xcode 26.6 |
| **📦 Dependency Manager** | CocoaPods 1.16.2 |

## 📁 Estructura del Proyecto

```text
lib/
├── data/          # Repositorios, Modelos y Fuentes de datos (API)
├── domain/        # Entidades y Casos de Uso (Lógica de negocio)
├── presentation/  # Componentes de UI, Screens y Providers (Capa visual)
└── main.dart      # Punto de entrada de la aplicación
```

## 🚀 Instalación y Primeros Pasos
Antes de comenzar, asegúrate de tener instaladas las herramientas de compilación mencionadas al principio.

### Paso 1: Clonar el repositorio
Clona el repositorio apuntando directamente a la rama `develop`:
```bash
git clone https://github.com/OscarSHx/tesys21_pokemon.git
cd tesys21_app_pokemon
```

### Paso 2: Descargar dependencias
Instala todos los paquetes de Flutter definidos en el pubspec.yaml:
```bash
flutter pub get
```

### Paso 3: Limpieza del entorno (Opcional)
Si vienes de compilar otras ramas o versiones de Flutter, limpia los archivos residuales:
```bash
flutter clean
```
### Paso 4: Verificar dispositivos disponibles
Asegúrate de que tu sistema reconozca correctamente tu dispositivo físico o simulador:
```bash
flutter devices
```

### Paso 5: Ejecutar la aplicación
Ejecuta el proyecto en tu dispositivo predeterminado:

```bash
flutter run
```


