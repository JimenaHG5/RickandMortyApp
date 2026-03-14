//
//  CharactersViewModel.swift
//  CharactersRickandMorty2
//
//  Created by Jimena Hernández García on 12/03/26.
//

import Foundation

// MARK: - CharactersViewModel

/// ViewModel responsable de la lógica de negocio de la pantalla de personajes
/// Maneja la paginación, búsqueda y estado de favoritos
final class CharactersViewModel {
    
    // MARK: - Properties
    
    /// Coordinador para manejar la navegación
    weak var coordinator: CharactersCoordinator?
    
    /// Lista de personajes cargados
    private(set) var characters: [Character] = []
    
    /// Página actual para paginación
    private var currentPage = 1
    
    /// Indica si hay más páginas disponibles
    private var hasMorePages = true
    
    /// Indica si hay una carga en proceso
    private var isLoading = false
    
    /// Texto de búsqueda actual
    private var searchQuery = ""
    
    // MARK: - Bindings
    
    /// Se ejecuta cuando la lista de personajes se actualiza
    var onCharactersUpdated: (() -> Void)?
    
    /// Se ejecuta cuando ocurre un error
    var onError: ((String) -> Void)?
    
    /// Se ejecuta cuando cambia el estado de carga
    var onLoadingChanged: ((Bool) -> Void)?
    
    // MARK: - Init
    
    init(coordinator: CharactersCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - Fetch Characters
    
    /// Carga la primera página de personajes
    func fetchCharacters() {
        guard !isLoading else { return }
        currentPage = 1
        hasMorePages = true
        characters = []
        loadCharacters()
    }
    
    // MARK: - Load More
    
    /// Carga la siguiente página de personajes (paginación)
    func loadMoreIfNeeded(currentIndex: Int) {
        guard !isLoading,
              hasMorePages,
              currentIndex >= characters.count - 3 else { return }
        loadCharacters()
    }
    
    // MARK: - Search
    
    /// Busca personajes por nombre
    /// - Parameter query: texto a buscar
    func search(query: String) {
        searchQuery = query
        currentPage = 1
        hasMorePages = true
        characters = []
        loadCharacters()
    }
    
    /// Limpia la búsqueda y regresa al listado normal
    func clearSearch() {
        searchQuery = ""
        fetchCharacters()
    }
    
    // MARK: - Load Characters
    
    /// Método interno que ejecuta la llamada a la API
    private func loadCharacters() {
        guard !isLoading, hasMorePages else { return }
        
        isLoading = true
        onLoadingChanged?(true)
        
        Task { [weak self] in
            guard let self else { return }
            
            do {
                let response: APIResponse
                
                if searchQuery.isEmpty {
                    response = try await NetworkManager.shared.fetchCharacters(page: currentPage)
                } else {
                    response = try await NetworkManager.shared.searchCharacters(name: searchQuery, page: currentPage)
                }
                
                await MainActor.run {
                    self.characters.append(contentsOf: response.results)
                    self.hasMorePages = response.info.next != nil
                    self.currentPage += 1
                    self.isLoading = false
                    self.onLoadingChanged?(false)
                    self.onCharactersUpdated?()
                }
                
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    self.onLoadingChanged?(false)
                    self.onError?(error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - Favorites
    
    /// Alterna el estado de favorito de un personaje
    /// - Parameter character: personaje a agregar o quitar de favoritos
    func toggleFavorite(character: Character) {
        if CoreDataManager.shared.isFavorite(id: character.id) {
            CoreDataManager.shared.removeFavorite(id: character.id)
        } else {
            CoreDataManager.shared.addFavorite(character: character)
        }
    }
    
    /// Verifica si un personaje es favorito
    /// - Parameter id: identificador del personaje
    func isFavorite(id: Int) -> Bool {
        return CoreDataManager.shared.isFavorite(id: id)
    }
    
    // MARK: - Navigation
    
    /// Navega al detalle del personaje seleccionado
    /// - Parameter character: personaje seleccionado
    func showDetail(character: Character) {
        coordinator?.showDetail(character: character)
    }
}
