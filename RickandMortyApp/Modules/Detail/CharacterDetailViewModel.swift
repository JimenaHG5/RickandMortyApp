//
//  CharacterDetailViewModel.swift
//  CharactersRickandMorty2
//
//  Created by Jimena Hernández García on 12/03/26.
//

import Foundation
import UIKit
import SwiftUI
import Combine

// MARK: - CharacterDetailViewModel

/// ViewModel responsable de la lógica de la vista de detalle del personaje
final class CharacterDetailViewModel: ObservableObject {
    
    // MARK: - Properties
    
    /// Personaje a mostrar en el detalle
    let character: Character
    
    /// Indica si el personaje es favorito
    @Published var isFavorite: Bool = false
    
    // MARK: - Init
    
    init(character: Character) {
        self.character = character
        self.isFavorite = CoreDataManager.shared.isFavorite(id: character.id)
    }
    
    // MARK: - Favorites
    
    /// Alterna el estado de favorito del personaje
    func toggleFavorite() {
        if isFavorite {
            CoreDataManager.shared.removeFavorite(id: character.id)
        } else {
            CoreDataManager.shared.addFavorite(character: character)
        }
        isFavorite = CoreDataManager.shared.isFavorite(id: character.id)
    }
}
