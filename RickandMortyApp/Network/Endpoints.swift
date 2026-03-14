//
//  Endpoints.swift
//  CharactersRickandMorty2
//
//  Created by Jimena Hernández García on 12/03/26.
//

import Foundation

// MARK: - Endpoints

/// Enum que centraliza todos los endpoints de la Rick and Morty API
/// Facilita el mantenimiento y evita hardcodear URLs en el código
enum Endpoints {
    
    /// URL base de la API
    private static let baseURL = "https://rickandmortyapi.com/api"
    
    /// Obtener listado de personajes con paginación
    /// - Parameter page: número de página a consultar
    case getCharacters(page: Int)
    
    /// Buscar personajes por nombre
    /// - Parameters:
    ///   - name: nombre a buscar
    ///   - page: número de página
    case searchCharacters(name: String, page: Int)
    
    // MARK: - URL Builder
    
    /// Construye y devuelve la URL completa del endpoint
    var url: URL? {
        switch self {
        case .getCharacters(let page):
            return URL(string: "\(Endpoints.baseURL)/character?page=\(page)")
            
        case .searchCharacters(let name, let page):
            /// Codifica el nombre para manejar espacios y caracteres especiales
            let encodedName = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? name
            return URL(string: "\(Endpoints.baseURL)/character?name=\(encodedName)&page=\(page)")
        }
    }
}
