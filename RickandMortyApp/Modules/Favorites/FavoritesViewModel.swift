//
//  FavoritesViewModel.swift
//  CharactersRickandMorty2
//
//  Created by Jimena Hernández García on 13/03/26.
//
import Foundation

// MARK: - FavoritesViewModel

/// ViewModel responsable de la lógica de la pantalla de favoritos
final class FavoritesViewModel {
    
    // MARK: - Properties
    
    /// Coordinador para manejar la navegación
    weak var coordinator: FavoritesCoordinator?
    
    /// Lista de personajes favoritos guardados localmente
    private(set) var favorites: [FavoriteCharacter] = []
    
    // MARK: - Bindings
    
    /// Se ejecuta cuando la lista de favoritos se actualiza
    var onFavoritesUpdated: (() -> Void)?
    
    // MARK: - Init
    
    init(coordinator: FavoritesCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - Fetch Favorites
    
    /// Obtiene los personajes favoritos guardados en Core Data
    func fetchFavorites() {
        favorites = CoreDataManager.shared.fetchFavorites()
        onFavoritesUpdated?()
    }
    
    // MARK: - Remove Favorite
    
    /// Elimina un personaje de favoritos
    /// - Parameter id: identificador del personaje a eliminar
    func removeFavorite(id: Int) {
        CoreDataManager.shared.removeFavorite(id: id)
        fetchFavorites()
    }
    
    // MARK: - Navigation
    
    /// Navega al detalle del personaje seleccionado
    /// - Parameter favorite: personaje favorito seleccionado
    func showDetail(favorite: FavoriteCharacter) {
        // convertir FavoriteCharacter a RMCharacter para reutilizar la vista de detalle
        let character = Character(
            id: Int(favorite.id),
            name: favorite.name ?? "",
            status: Character.Status(rawValue: favorite.status ?? "") ?? .unknown,
            species: favorite.species ?? "",
            type: "",
            gender: Character.Gender(rawValue: favorite.gender ?? "") ?? .unknown,
            origin: Location(name: favorite.originName ?? "", url: ""),
            location: Location(name: favorite.locationName ?? "", url: ""),
            image: favorite.imageURL ?? "",
            episode: [],
            url: "",
            created: ""
        )
        coordinator?.showDetail(character: character)
    }
}
