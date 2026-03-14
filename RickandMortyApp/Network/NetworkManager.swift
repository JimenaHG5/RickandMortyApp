//
//  NetworkManager.swift
//  CharactersRickandMorty2
//
//  Created by Jimena Hernández García on 12/03/26.
//

import Foundation

// MARK: - NetworkError

/// Errores personalizados del NetworkManager
enum NetworkError: Error {
    case invalidURL        // URL mal formada
    case noData            // la API no devolvió datos
    case decodingError     // error al decodificar el JSON
    case noInternet        // sin conexión a internet
    case unknown(Error)    // error desconocido
    
    /// Mensaje legible para mostrar al usuario
    var message: String {
        switch self {
        case .invalidURL:       return "URL inválida"
        case .noData:           return "No se recibieron datos"
        case .decodingError:    return "Error al procesar los datos"
        case .noInternet:       return "Sin conexión a internet"
        case .unknown(let e):   return e.localizedDescription
        }
    }
}

// MARK: - NetworkManager

/// Clase responsable de todas las llamadas a la API
/// Implementa el patrón Singleton para tener una sola instancia en la app
final class NetworkManager {
    
    /// Instancia compartida del NetworkManager
    static let shared = NetworkManager()
    
    /// Sesión de URL para realizar las peticiones
    private let session: URLSession
    
    /// Inicializador privado para garantizar el patrón Singleton
    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30  // timeout de 30 segundos
        self.session = URLSession(configuration: config)
    }
    
    // MARK: - Fetch Characters
    
    /// Obtiene un listado paginado de personajes desde la API
    /// - Parameter page: número de página a consultar (inicia en 1)
    /// - Returns: APIResponse con info de paginación y lista de personajes
    func fetchCharacters(page: Int) async throws -> APIResponse {
        guard let url = Endpoints.getCharacters(page: page).url else {
            throw NetworkError.invalidURL
        }
        return try await performRequest(url: url)
    }
    
    // MARK: - Search Characters
    
    /// Busca personajes por nombre en la API
    /// - Parameters:
    ///   - name: nombre del personaje a buscar
    ///   - page: número de página (inicia en 1)
    /// - Returns: APIResponse con los resultados de la búsqueda
    func searchCharacters(name: String, page: Int) async throws -> APIResponse {
        guard let url = Endpoints.searchCharacters(name: name, page: page).url else {
            throw NetworkError.invalidURL
        }
        return try await performRequest(url: url)
    }
    
    // MARK: - Perform Request
    
    /// Método genérico que ejecuta la petición HTTP y decodifica la respuesta
    /// - Parameter url: URL del endpoint a consultar
    /// - Returns: objeto decodificado del tipo especificado
    private func performRequest(url: URL) async throws -> APIResponse {
        do {
            let (data, response) = try await session.data(from: url)
            
            // verificar que la respuesta sea HTTP válida
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.noData
            }
            
            // decodificar el JSON en el modelo APIResponse
            do {
                let decoded = try JSONDecoder().decode(APIResponse.self, from: data)
                return decoded
            } catch {
                throw NetworkError.decodingError
            }
            
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.unknown(error)
        }
    }
}
