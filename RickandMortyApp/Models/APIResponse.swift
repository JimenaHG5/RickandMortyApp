//
//  APIResponse.swift
//  CharactersRickandMorty2
//
//  Created by Jimena Hernández García on 12/03/26.
//

import Foundation

// MARK: - APIResponse

/// Modelo que representa la respuesta completa de la API
/// La API de Rick and Morty siempre devuelve info de paginación + resultados
struct APIResponse: Codable {
    let info: PageInfo        // información de paginación
    let results: [Character]  // lista de personajes de la página actual
}

// MARK: - PageInfo

/// Información de paginación devuelta por la API
struct PageInfo: Codable {
    let count: Int        // total de personajes en la API
    let pages: Int        // total de páginas disponibles
    let next: String?     // URL de la siguiente página (nil si es la última)
    let prev: String?     // URL de la página anterior (nil si es la primera)
}
