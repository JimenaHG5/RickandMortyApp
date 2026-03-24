# Rick and Morty App 🛸

Aplicación iOS que consume la [Rick and Morty API](https://rickandmortyapi.com/) para mostrar personajes, permitir búsquedas y guardar favoritos localmente.
## Credenciales demo

| Campo | Valor |
|-------|-------|
| Email | rick@sanchez.com |
| Contraseña | pruebajim |

## Funcionalidades

### Requerimientos cumplidos ✅
-Login 
-  Listado de personajes con `UITableView` y celdas reutilizables
- Paginación automática al llegar al final de la lista
- Búsqueda de personajes por nombre usando el endpoint de la API
- Vista de detalle desarrollada en **SwiftUI** con información completa del personaje
- Sistema de favoritos — agregar y eliminar con persistencia en **Core Data**
- TabBar con pestaña de Personajes y Favoritos
- Manejo de conexión — alerta nativa cuando no hay internet con opción de ver favoritos guardados

### Extras implementados ⭐
- Caché de imágenes con `NSCache`
- Loading states con `UIActivityIndicatorView`
- 🔄 Manejo avanzado de errores en networking
-  Arquitectura MVVM + Coordinator Pattern

## Tecnologías

| Componente | Tecnología |
|-----------|------------|
| Lenguaje | Swift |
| UI Principal | UIKit (programático) |
| Vista de Detalle | SwiftUI |
| Arquitectura | MVVM + Coordinator |
| Persistencia | Core Data |
| Networking | URLSession + async/await |
| Caché de imágenes | NSCache |
| Monitor de red | NWPathMonitor |

## Arquitectura

El proyecto sigue el patrón **MVVM + Coordinator**:
```
RMTabBarController
├── CharactersCoordinator
│   ├── CharactersViewController (UITableViewController)
│   └── CharacterDetailView (SwiftUI via UIHostingController)
└── FavoritesCoordinator
    ├── FavoritesViewController (UITableViewController)
    └── CharacterDetailView (SwiftUI via UIHostingController)
```

## Estructura del proyecto
```
RickAndMortyApp/
├── App/
├── TabBar/
├── Coordinators/
├── Network/
├── Models/
├── CoreData/
├── Modules/
│   ├── Characters/
│   ├── Detail/
│   └── Favorites/
├── Common/
└── Resources/
```

## Requisitos

- iOS 16+
- Xcode 15+
- Conexión a internet para cargar personajes (modo offline disponible con favoritos)

## Instalación

1. Clona el repositorio
```bash
git clone https://github.com/JimenaHG5/RickandMortyApp.git
```

2. Abre el proyecto en Xcode
```bash
cd RickandMortyApp
open RickandMortyApp.xcodeproj
```

3. Selecciona un simulador o dispositivo con iOS 16+

4. Compila y ejecuta con `Cmd + R`

> No se requieren dependencias externas ni configuración adicional.

## Autora

**Jimena Hernández García**
[GitHub](https://github.com/JimenaHG5)
