//
//  Character.swift
//  CharactersRickandMorty2
//
//  Created by Jimena Hernández García on 12/03/26.
//
import Foundation
import UIKit

// MARK: - Character

/// Modelo principal que representa un personaje de la API de Rick and Morty
/// Conforma Codable para decodificar automáticamente el JSON de la API
struct Character: Codable {
    let id: Int           // identificador único del personaje
    let name: String      // nombre del personaje
    let status: Status    // estado vital: Alive, Dead o Unknown
    let species: String   // especie del personaje
    let type: String      // subtipo o variante de la especie
    let gender: Gender    // género del personaje
    let origin: Location  // planeta o lugar de origen
    let location: Location // última ubicación conocida
    let image: String     // URL de la imagen del personaje
    let episode: [String] // lista de URLs de episodios donde aparece
    let url: String       // URL del personaje en la API
    let created: String   // fecha de creación en la base de datos
}

// MARK: - Status

extension Character {
    /// Estado vital del personaje
    enum Status: String, Codable {
        case alive = "Alive"
        case dead = "Dead"
        case unknown = "unknown"
        
        /// Texto legible para mostrar en la UI
        var displayText: String {
            return self.rawValue
        }
        
        /// Color representativo del estado para mostrar en la celda
        var color: UIColor {
            switch self {
            case .alive:   return .systemGreen  // verde para vivo
            case .dead:    return .systemRed    // rojo para muerto
            case .unknown: return .systemGray   // gris para desconocido
            }
        }
    }
    
    // MARK: - Gender
    
    /// Género del personaje
    enum Gender: String, Codable {
        case male = "Male"
        case female = "Female"
        case genderless = "Genderless"
        case unknown = "unknown"
    }
}

// MARK: - Location

/// Modelo que representa una ubicación
/// Se reutiliza tanto para origin como para location del personaje
struct Location: Codable {
    let name: String // nombre de la ubicación
    let url: String  // URL de la ubicación en la API
}
