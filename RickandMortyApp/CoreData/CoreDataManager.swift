//
//  Core.swift
//  CharactersRickandMorty2
//
//  Created by Jimena Hernández García on 12/03/26.
//
import Foundation
import CoreData


// MARK: - CoreDataManager

/// Clase responsable de todas las operaciones de persistencia con Core Data
/// Implementa el patrón Singleton para tener una sola instancia en la app
final class CoreDataManager {
    
    /// Instancia compartida del CoreDataManager
    static let shared = CoreDataManager()
    
    // MARK: - Persistent Container
    
    /// Contenedor principal de Core Data
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "RickandMorty")
        container.loadPersistentStores { description, error in
            if let error {
                fatalError("Error al cargar Core Data: \(error.localizedDescription)")
            }
            print("Core Data cargado: \(description.url?.absoluteString ?? "")")
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    /// Contexto principal para operaciones en el hilo principal
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    /// Inicializador privado para garantizar el patrón Singleton
    private init() { }
    
    // MARK: - Save Context
    
    /// Guarda los cambios pendientes en el contexto
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error al guardar Core Data: \(error)")
            }
        }
    }
    
    // MARK: - Add Favorite
    
    /// Agrega un personaje a favoritos
    /// - Parameter character: personaje a guardar

        guard !isFavorite(id: character.id) else { return }
        
        let favorite = FavoriteCharacter(context: context)
        favorite.id = Int32(character.id)
        favorite.name = character.name
        favorite.status = character.status.rawValue
        favorite.species = character.species
        favorite.imageURL = character.image
        favorite.gender = character.gender.rawValue
        favorite.originName = character.origin.name
        favorite.locationName = character.location.name
        
        saveContext()
    }
    
    // MARK: - Remove Favorite
    
    /// Elimina un personaje de favoritos
    /// - Parameter id: identificador del personaje a eliminar
    func removeFavorite(id: Int) {
        let request = FavoriteCharacter.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let results = try context.fetch(request)
            results.forEach { context.delete($0) }
            saveContext()
        } catch {
            print("Error al eliminar favorito: \(error)")
        }
    }
    
    // MARK: - Fetch Favorites
    

